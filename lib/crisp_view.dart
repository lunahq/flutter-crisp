import 'package:crisp/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/main.dart';

const CRISP_BASE_URL = 'https://go.crisp.chat';

String crispEmbedUrl(String websiteId, String locale) {
  String url = CRISP_BASE_URL + '/chat/embed/?website_id=$websiteId';

  if (notNull(locale)) url += '&locale=$locale';

  return url;
}

class CrispView extends StatefulWidget {
  final Widget loadingWidget;
  final AppBar appBar;

  @override
  _CrispViewState createState() => _CrispViewState();

  CrispView({this.loadingWidget, this.appBar});
}

class _CrispViewState extends State<CrispView> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  bool browserContextChanged = false;

  handleAppLifecycleState() {
    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == "AppLifecycleState.resumed" && browserContextChanged) {
        flutterWebViewPlugin
            .reloadUrl(crispEmbedUrl(crisp.websiteId, crisp.locale));
        browserContextChanged = false;
      }
      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    handleAppLifecycleState();

    final javascriptString = """
      var a = setInterval(function(){
        if (typeof \$crisp !== 'undefined'){  
          ${crisp.commands.join(';\n')}
          clearInterval(a);
        } 
      },500)
      """;

    crisp.commands.clear();

    flutterWebViewPlugin.onStateChanged.listen((
      WebViewStateChanged state,
    ) async {
      if (state.type == WebViewState.finishLoad) {
        flutterWebViewPlugin.evalJavascript(javascriptString);
      }

      if (state.type == WebViewState.shouldStart) {
        if (state.url.contains(CRISP_BASE_URL)) return;

        browserContextChanged = true;
        print("navigating to...${state.url}");
        if (state.url.startsWith("mailto") ||
            state.url.startsWith("tel") ||
            state.url.startsWith("http") ||
            state.url.startsWith("https")) {
          await flutterWebViewPlugin.stopLoading();

          if (await canLaunch(state.url)) {
            await launch(state.url);
            return;
          }
          print("couldn't launch $state.url");
        }
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: crispEmbedUrl(crisp.websiteId, crisp.locale),
      mediaPlaybackRequiresUserGesture: false,
      appBar: widget.appBar,
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: widget.loadingWidget,
      withJavascript: true,
      resizeToAvoidBottomInset: true,
    );
  }
}
