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

  @override
  _CrispViewState createState() => _CrispViewState();

  CrispView({required this.crispMain});
}

class _CrispViewState extends State<CrispView> {
  InAppWebViewController? _webViewController;
  String? _javascriptString;

  InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
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

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: InAppWebView(
        gestureRecognizers: Set()
          ..add(
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
          ),
        initialUrlRequest: URLRequest(
          url: Uri.parse(_crispEmbedUrl(
            websiteId: widget.crispMain.websiteId,
            locale: widget.crispMain.locale,
            userToken: widget.crispMain.userToken,
          )),
        ),
        initialOptions: _options,
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          _webViewController?.evaluateJavascript(source: _javascriptString!);
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
                await launch(url);

                return NavigationActionPolicy.CANCEL;
              }
            }
          }

          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
