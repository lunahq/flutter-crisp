import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CrispUser {
  final String email;
  final String avatar;
  final String nickname;
  final String phone;

  CrispUser({
    this.email,
    this.avatar,
    this.nickname,
    this.phone,
  });
}

class _CrispMain {
  String websiteId;
  Queue commands = Queue<String>();

  void initialize(String id) {
    websiteId = id;
  }

  void register(CrispUser user) {
    execute("window.\$crisp.push([\"set\", \"user:email\", [\"" +
        user.email +
        "\"]])");

    execute("window.\$crisp.push([\"set\", \"user:nickname\", [\"" +
        user.nickname +
        "\"]])");

    execute("window.\$crisp.push([\"set\", \"user:avatar\", [\"" +
        user.avatar +
        "\"]])");

    execute("window.\$crisp.push([\"set\", \"user:phone\", [\"" +
        user.phone +
        "\"]])");
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
  @override
  _CrispViewState createState() => _CrispViewState();
}

class _CrispViewState extends State<CrispView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl:
          'https://go.crisp.chat/chat/embed/?website_id=${crisp.websiteId}',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
        _controller.complete(webViewController);
      },
      // ignore: prefer_collection_literals
      javascriptChannels: <JavascriptChannel>[
        _toasterJavascriptChannel(context),
      ].toSet(),
      navigationDelegate: (NavigationRequest request) {
        if (request.url.contains('mailto:') ||
            request.url.contains('https://') ||
            request.url.contains('http://')) {
          launch(request.url);

          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) async {
        // await Future.delayed(Duration(seconds: 5));
        crisp.commands.forEach((javascriptString) {
          _webViewController.evaluateJavascript(javascriptString);
        });

        crisp.commands.clear();

        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
