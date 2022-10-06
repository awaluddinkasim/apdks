import 'package:apdks/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const DrawerWidget(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/research.svg",
                    width: 200,
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Text(
                          "Apa itu Kanker Serviks?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Kanker serviks adalah kanker yang tumbuh pada sel-sel di leher rahim. Kanker ini umumnya berkembang perlahan dan baru menunjukkan gejala ketika sudah memasuki stadium lanjut. Oleh sebab itu, penting untuk mendeteksi kanker serviks sejak dini sebelum timbul masalah serius.",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Penyebab Kanker Serviks",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Kanker serviks terjadi ketika sel-sel yang sehat mengalami perubahan atau mutasi. Mutasi ini menyebabkan sel-sel tersebut tumbuh tidak normal dan tidak terkendali sehingga membentuk sel kanker. Belum diketahui apa yang menyebabkan perubahan pada gen tersebut. Namun, kondisi ini diketahui terkait dengan infeksi HPV.",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Pengobatan dan Pencegahan Kanker Serviks",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Pengobatan kanker serviks tergantung pada stadium kanker yang dialami pasien dan kondisi kesehatannya. Tindakan yang dilakukan dokter meliputi kemoterapi, radioterapi, bedah, atau kombinasi dari ketiganya. Peluang penderita kanker serviks untuk sembuh akan lebih besar jika kondisi ini terdeteksi sejak dini. Oleh sebab itu, setiap wanita disarankan untuk menjalani skrining kanker serviks secara berkala sejak usia 21 tahun atau sejak menikah. Selain itu, pencegahan infeksi HPV yang dapat memicu kanker ini juga dapat dilakukan dengan vaksin sejak usia 10 tahun.",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
