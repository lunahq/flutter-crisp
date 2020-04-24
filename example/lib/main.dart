import 'package:flutter/material.dart';
import 'package:crisp/crisp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    crisp.initialize('WEBSITE_ID');
    crisp.register(
      CrispUser(
        email: "leo@gmail.com",
        avatar: 'https://avatars2.githubusercontent.com/u/16270189?s=200&v=4',
        nickname: "João Cardoso",
        phone: "5511987654321",
      ),
    );

    crisp.setMessage("Olá mundo ksansans");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CrispView(
        appBar: AppBar(
          title: const Text('Widget WebView'),
        ),
        loadingWidget: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
