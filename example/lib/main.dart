import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:crisp/crisp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();

    crisp.initialize("");
    crisp.register(
      CrispUser(
        email: "",
        avatar:
            '',
        nickname: "",
        phone: "",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: CrispView(
            id: '11385bfa-3cf8-4a0f-beba-44629aec6779',
          ),
        ),
      ),
    );
  }
}
