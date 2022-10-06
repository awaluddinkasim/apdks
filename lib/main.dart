import 'package:apdks/providers/auth.dart';
import 'package:apdks/providers/result.dart';
import 'package:apdks/screens/main_load.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Result>(
          update: (context, auth, result) => Result(auth),
          create: (BuildContext context) => Result(null),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset("assets/kanker-serviks.png").image, context);
    precacheImage(Image.asset("assets/ribbon.png").image, context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const InitApp(),
    );
  }
}
