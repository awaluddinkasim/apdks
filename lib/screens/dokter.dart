import 'package:apdks/nav_drawer.dart';
import 'package:apdks/providers/auth.dart';
import 'package:apdks/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  bool _isLoading = true;
  Map? _dokter;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchDokter();
    });
  }

  Future<void> _fetchDokter() async {
    final token = Provider.of<Auth>(context, listen: false).token;

    try {
      Response response = await dio(token: token).get('dokter');

      if (response.statusCode == 200) {
        setState(() {
          _dokter = response.data['dokter'];
          _isLoading = false;
        });
      }
    } on DioError catch (e) {
      print(e.response!.data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dokter"),
      ),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: _fetchDokter,
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: _isLoading ? _loading() : _dataDokter(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Card _loading() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Card _dataDokter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 20,
        ),
        child: _dokter != null ? _dokterTidakKosong() : _dokterKosong(),
      ),
    );
  }

  Column _dokterKosong() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            height: 180,
            width: 180,
            child: ClipOval(
              child: SvgPicture.asset("assets/kosong.svg"),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Belum ada dokter terdaftar",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  Column _dokterTidakKosong() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            height: 180,
            width: 180,
            child: ClipOval(
              child: Image.network(
                "https://serviks.egols.my.id/doctor/${_dokter!['foto']}",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "${_dokter!['nama']}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const Text(
          "Kontak",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.mail),
          title: Text("${_dokter!['email']}"),
        ),
        ListTile(
          leading: const Icon(Icons.whatsapp),
          title: Text("${_dokter!['no_hp']}"),
        )
      ],
    );
  }
}
