import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String text;
  const LoadingScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset("assets/ribbon.png").image, context);

    return Scaffold(
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
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
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
