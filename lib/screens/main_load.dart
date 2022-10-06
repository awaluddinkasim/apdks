import 'package:apdks/providers/auth.dart';
import 'package:apdks/screens/home.dart';
import 'package:apdks/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      validateAuth(context);
    });
    super.initState();
  }

  void validateAuth(BuildContext context) async {
    final provider = Provider.of<Auth>(context, listen: false);
    final navigator = Navigator.of(context);

    String? token = await storage.read(key: "token");

    if (token != null) {
      provider.userData(token);
    } else {
      Future.delayed(Duration.zero, () {
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);

    if (provider.authenticated != null && provider.authenticated == true) {
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      });
    } else if (provider.authenticated != null && provider.authenticated == false) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      body: SafeArea(
        child: Column(
          children: [
            const LinearProgressIndicator(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Image.asset("assets/ribbon.png"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
