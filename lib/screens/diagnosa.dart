import 'package:apdks/nav_drawer.dart';
import 'package:apdks/providers/result.dart';
import 'package:apdks/screens/diagnosa-awal.dart';
import 'package:apdks/screens/result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiagnosaScreen extends StatelessWidget {
  const DiagnosaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset("assets/kanker-serviks.png").image, context);

    final resultProvider = Provider.of<Result>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Konsultasi"),
      ),
      drawer: const DrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: Image.asset("assets/kanker-serviks.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            if (resultProvider.isFetching)
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              )
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DiagnosaAwalScreen()),
                      );
                    },
                    child: const Text("Mulai Diagnosa"),
                  ),
                  if (resultProvider.hasil.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResultScreen(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
                      ),
                      child: const Text("Lihat Hasil"),
                    ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
