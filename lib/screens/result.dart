import 'package:apdks/nav_drawer.dart';
import 'package:apdks/providers/auth.dart';
import 'package:apdks/providers/result.dart';
import 'package:apdks/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    final resultProvider = Provider.of<Result>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Tes"),
      ),
      drawer: const DrawerWidget(),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Data Pribadi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Nama"),
                          Text("Jenis Kelamin"),
                          Text("Umur"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(":"),
                            Text(":"),
                            Text(":"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "${authProvider.user != null ? authProvider.user!.nama : '...'}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(authProvider.user != null ? 'Perempuan' : '...'),
                            Text("${authProvider.user != null ? authProvider.user!.umur : '...'} Tahun"),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (resultProvider.isFetching == false)
            if (resultProvider.hasil.isNotEmpty)
              resultProvider.hasil["kanker"] == null
                  ? _tidakTerindikasi(resultProvider)
                  : _terindikasi(context, resultProvider)
            else
              _belumKonsultasi(context)
          else
            _loading()
        ],
      ),
    );
  }

  Card _belumKonsultasi(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            const Text(
              "Anda belum mengambil tes gejala",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TestScreen(),
                  ),
                );
              },
              child: const Text("Tap disini"),
            ),
          ],
        ),
      ),
    );
  }

  Column _terindikasi(BuildContext context, provider) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Hasil",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Anda terindikasi mengalami Kanker Serviks ${provider.hasil['kanker']['stadium']}, hasil perhitungan gejala menunjukkan bahwa tingkat probabilitas Anda adalah ditingkat ${provider.hasil['resiko']}.",
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    "Silahkan konsultasikan langsung ke dokter untuk penanganan lebih lanjut dan hasil yang lebih akurat."),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Keterangan Kanker",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ReadMoreText(
                  provider.hasil['kanker']["keterangan"],
                  trimMode: TrimMode.Line,
                  trimLines: 5,
                  trimCollapsedText: 'Tampilkan semua',
                  trimExpandedText: 'Sembunyikan',
                  moreStyle: TextStyle(color: Theme.of(context).primaryColor),
                  lessStyle: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Solusi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  provider.hasil['kanker']['solusi'],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Card _tidakTerindikasi(provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Hasil",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Anda tidak terindikasi mengalami Kanker Serviks, hasil perhitungan gejala menunjukkan bahwa Anda memiliki tingkat probabilitas ${provider.hasil['resiko']} terkena Kanker Serviks.",
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Terus jaga kesehatan Anda."),
            Center(
              child: SizedBox(
                height: 200,
                child: SvgPicture.asset("assets/woman.svg"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Card _loading() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
