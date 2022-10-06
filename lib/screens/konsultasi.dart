// ignore_for_file: prefer_final_fields, unused_local_variable

import 'package:apdks/providers/auth.dart';
import 'package:apdks/providers/result.dart';
import 'package:apdks/screens/loading.dart';
import 'package:apdks/screens/result.dart';
import 'package:apdks/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KonsultasiScreen extends StatefulWidget {
  const KonsultasiScreen({super.key});

  @override
  State<KonsultasiScreen> createState() => _KonsultasiScreenState();
}

class _KonsultasiScreenState extends State<KonsultasiScreen> {
  bool _isLoading = true;
  bool _calculating = false;
  int _index = 0;
  List _gejala = [];
  List<String?> _answers = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchGejala(context);
    });
    super.initState();
  }

  Future<void> fetchGejala(BuildContext context) async {
    final provider = Provider.of<Auth>(context, listen: false);

    Response response = await dio(token: provider.token).get("gejala");

    if (response.statusCode == 200) {
      _gejala = response.data['daftarGejala'];
      for (var element in _gejala) {
        _answers.add("Tidak");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendData() async {
    setState(() {
      _calculating = true;
      _isLoading = true;
    });

    final authProvider = Provider.of<Auth>(context, listen: false);
    final resultProvider = Provider.of<Result>(context, listen: false);
    final navigator = Navigator.of(context);

    Map data = {};

    List<Map> answers = [];
    _answers.asMap().forEach((index, value) {
      answers.add({
        "id": _gejala[index]['id'],
        "answer": value,
      });
    });

    data = {"keluhan": answers};

    try {
      Response response = await dio(token: authProvider.token).post('konsultasi', data: data);

      if (response.statusCode == 200) {
        resultProvider.updateHasil(response.data['hasil']);

        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResultScreen(),
          ),
          (route) => false,
        );
      }
    } on DioError catch (e) {
      print(e.response!.data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? LoadingScreen(
                text: _calculating ? "Sedang melakukan perhitungan, harap menunggu..." : "Silahkan tunggu...",
              )
            : _gejalaBuilder(),
      ),
    );
  }

  Stepper _gejalaBuilder() {
    return Stepper(
      currentStep: _index,
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: details.onStepCancel,
              child: const Text('Kembali'),
            ),
            const SizedBox(
              width: 15,
            ),
            ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text(_index < _gejala.length - 1 ? "Selanjutnya" : "Kirim"),
            ),
          ],
        );
      },
      steps: [
        for (var i in _gejala)
          Step(
            title: Text("Gejala"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Apakah Anda mengalami ${i['keterangan']}?",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: const Text("Ya"),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  leading: Radio(
                    value: "Ya",
                    groupValue: _answers[_index],
                    onChanged: (String? value) {
                      setState(() {
                        _answers[_index] = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Tidak"),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  leading: Radio(
                    value: "Tidak",
                    groupValue: _answers[_index],
                    onChanged: (String? value) {
                      setState(() {
                        _answers[_index] = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
      onStepContinue: () {
        if (_index < _gejala.length - 1) {
          setState(() {
            _index += 1;
          });
        } else {
          _sendData();
        }
      },
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
    );
  }
}
