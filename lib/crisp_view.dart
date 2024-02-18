import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/main.dart';

const CRISP_BASE_URL = 'https://go.crisp.chat';

String _crispEmbedUrl({
  required String websiteId,
  required String locale,
  String? userToken,
}) {
  String url = CRISP_BASE_URL + '/chat/embed/?website_id=$websiteId';

  url += '&locale=$locale';
  if (userToken != null) url += '&token_id=$userToken';

  return url;
}

/// The main widget to provide the view of the chat
class CrispView extends StatefulWidget {
  /// Model with main settings of this chat
  final CrispMain crispMain;

  /// Set to true to have all the browser's cache cleared before the new WebView is opened. The default value is false.
  final bool clearCache;
  final void Function(String url)? onLinkPressed;

  ///Set to true to make the background of the WebView transparent.
  ///If your app has a dark theme,
  ///this can prevent a white flash on initialization. The default value is false.
  final bool transparentBackground;

  ///  A callback that is called when the session id is received.
  ///  This is useful for tracking the user's session.
  ///  The session id is a unique identifier for the user's session.
  final void Function(String sessionId)? onSessionIdReceived;

  @override
  _CrispViewState createState() => _CrispViewState();

  CrispView({
    required this.crispMain,
    this.clearCache = false,
    this.onLinkPressed,
    this.transparentBackground = false,
    this.onSessionIdReceived,
  });
}

class _CrispViewState extends State<CrispView> {
  InAppWebViewController? _webViewController;
  String? _javascriptString;

  late InAppWebViewGroupOptions _options;

  @override
  void initState() {
    super.initState();
    _options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        transparentBackground: widget.transparentBackground,
        clearCache: widget.clearCache,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        cacheMode: AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ),
    );

    _javascriptString = """
      var a = setInterval(function(){
        if (typeof \$crisp !== 'undefined'){
          ${widget.crispMain.commands.join(';\n')}
          clearInterval(a);
        }
      },500)
      """;

    widget.crispMain.commands.clear();
  }

  void getSessionId() async {
    await Future.delayed(const Duration(seconds: 3));
    String? sessionId = await _webViewController?.evaluateJavascript(
        source: 'window.\$crisp.get("session:identifier")');
    if (sessionId != null && widget.onSessionIdReceived != null) {
      widget.onSessionIdReceived!(sessionId);
      return;
    }
    if (sessionId == null) getSessionId();
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      gestureRecognizers: Set()
        ..add(
          Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(),
          ),
        ),
      initialUrlRequest: URLRequest(
        url: WebUri(
          _crispEmbedUrl(
            websiteId: widget.crispMain.websiteId,
            locale: widget.crispMain.locale,
            userToken: widget.crispMain.userToken,
          ),
        ),
      ),
      initialOptions: _options,
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        _webViewController?.evaluateJavascript(source: _javascriptString!);
        getSessionId();
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;
        var url = uri.toString();

        if (uri?.host != 'go.crisp.chat') {
          if ([
            "http",
            "https",
            "tel",
            "mailto",
            "file",
            "chrome",
            "data",
            "javascript",
            "about"
          ].contains(uri?.scheme)) {
            if (await canLaunch(url)) {
              if (widget.onLinkPressed != null)
                widget.onLinkPressed!(url);
              else {
                await launch(url);
              }
              return NavigationActionPolicy.CANCEL;
            }
          }
        }

        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}
