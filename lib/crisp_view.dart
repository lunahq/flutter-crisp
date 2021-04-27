import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/main.dart';

const CRISP_BASE_URL = 'https://go.crisp.chat';

String crispEmbedUrl({
  required String websiteId,
  required String locale,
  String? userToken,
}) {
  String url = CRISP_BASE_URL + '/chat/embed/?website_id=$websiteId';

  url += '&locale=$locale';
  if (userToken != null) url += '&token_id=$userToken';

  return url;
}

class CrispView extends StatefulWidget {
  final CrispMain crispMain;
  final Widget? loadingWidget;
  final AppBar? appBar;

  @override
  _CrispViewState createState() => _CrispViewState();

  CrispView({
    required this.crispMain,
    this.loadingWidget,
    this.appBar,
  });
}

class _CrispViewState extends State<CrispView> {
  InAppWebViewController? webViewController;
  String? javascriptString;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();

    javascriptString = """
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
        initialUrlRequest: URLRequest(
          url: Uri.parse(crispEmbedUrl(
            websiteId: widget.crispMain.websiteId,
            locale: widget.crispMain.locale,
            userToken: widget.crispMain.userToken,
          )),
        ),
        initialOptions: options,
        onWebViewCreated: (InAppWebViewController controller) {
          webViewController = controller;
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          webViewController?.evaluateJavascript(source: javascriptString!);
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url;
          var url = uri.toString();

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

          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
