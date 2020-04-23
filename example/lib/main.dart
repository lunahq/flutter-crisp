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

    crisp.initialize('11385bfa-3cf8-4a0f-beba-44629aec6779');
    crisp.register(
      CrispUser(
        email: "fala@oiluna.com",
        avatar: 'https://avatars2.githubusercontent.com/u/16270189?s=200&v=4',
        nickname: "jao",
        phone: "5511987654321",
      ),
    );

    crisp.setMessage("Olá mundo");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CrispView(),
        appBar: AppBar(),
      ),
    );
  }
}
