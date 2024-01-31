import 'package:crisp/crisp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CrispMain crispMain;

  @override
  void initState() {
    super.initState();

    crispMain = CrispMain(
      websiteId: 'f41e1e5f-3631-4dce-9797-3e875eade4d9',
    );

    crispMain.register(
      user: CrispUser(
        email: "Amir@provider.com",
        nickname: "Amir Jabbari",
      ),
    );

    crispMain.setMessage("Amir");
    // crispMain.appendScript("console.log(\$crisp.get('session:identifier'))");
    // crispMain.appendScript("console.log(\$crisp.get())");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: CrispView(
          crispMain: crispMain,
          clearCache: true,
          // onSessionIdReceived: (sessionId) {
          //   print('------------- sessionIdCrisp  --------------');
          //   print(sessionId);
          // },
        ),
      ),
    );
  }
}
