import 'dart:collection';

import 'package:crisp/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class CrispUser {
  final String email;
  final String avatar;
  final String nickname;
  final String phone;

  CrispUser({
    @required this.email,
    this.avatar,
    this.nickname,
    this.phone,
  }) : assert(email != null);
}

class _CrispMain {
  String websiteId;
  Queue commands = Queue<String>();
  CrispUser user;

  void initialize(String id) {
    websiteId = id;
  }

  void register(CrispUser user) {
    execute("window.\$crisp.push([\"set\", \"user:email\", [\"" +
        user.email +
        "\"]])");

    if (notNull(user.nickname))
      execute("window.\$crisp.push([\"set\", \"user:nickname\", [\"" +
          user.nickname +
          "\"]])");

    if (notNull(user.avatar))
      execute("window.\$crisp.push([\"set\", \"user:avatar\", [\"" +
          user.avatar +
          "\"]])");

    if (notNull(user.phone))
      execute("window.\$crisp.push([\"set\", \"user:phone\", [\"" +
          user.phone +
          "\"]])");

    this.user = user;
  }

  setMessage(String text) {
    execute("window.\$crisp.push([\"set\", \"message:text\", [\"$text\"]])");
  }

  void execute(String script) {
    commands.add(script);
  }
}

final crisp = _CrispMain();

class CrispView extends StatefulWidget {
  final Widget loadingWidget;
  final AppBar appBar;

  @override
  _CrispViewState createState() => _CrispViewState();

  CrispView({this.loadingWidget, this.appBar});
}

class _CrispViewState extends State<CrispView> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  handleAppLifecycleState() {
    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == "AppLifecycleState.resumed") {
        flutterWebViewPlugin.reloadUrl(
            'https://go.crisp.chat/chat/embed/?website_id=${crisp.websiteId}');
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

    print(javascriptString);
    flutterWebViewPlugin.evalJavascript(javascriptString);

    flutterWebViewPlugin.onStateChanged.listen((
      WebViewStateChanged state,
    ) async {
      if (state.type == WebViewState.shouldStart) {
        if (state.url.contains('https://go.crisp.chat')) return;

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
      url: 'https://go.crisp.chat/chat/embed/?website_id=${crisp.websiteId}',
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
