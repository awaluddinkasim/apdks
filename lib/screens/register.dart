import 'package:apdks/screens/login.dart';
import 'package:apdks/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _tglLahir = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.teal.shade800,
        body: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 100,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Silahkan lengkapi data",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 15,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                controller: _nama,
                                decoration: const InputDecoration(
                                  labelText: "Nama Lengkap",
                                  prefixIcon: Icon(Icons.badge),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Harap diisi";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.none,
                                controller: _username,
                                decoration: const InputDecoration(
                                  labelText: "Username",
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Harap diisi";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.none,
                                obscureText: _showPassword ? false : true,
                                controller: _password,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                    icon: Icon(_showPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Harap diisi";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                readOnly: true,
                                keyboardType: TextInputType.none,
                                controller: _tglLahir,
                                onTap: () => pickDate(context),
                                decoration: const InputDecoration(
                                  labelText: "Tanggal Lahir",
                                  prefixIcon: Icon(CupertinoIcons.calendar_today),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Harap diisi";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.loaderOverlay.show();
                                    register();
                                  }
                                },
                                child: const Text("Daftar"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickDate(BuildContext context) async {
    final DateFormat formatter = DateFormat("yyyy-MM-dd");

    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 50),
      lastDate: DateTime.now(),
    );

    if (newDate == null) return;

    setState(() {
      _tglLahir.text = formatter.format(newDate);
    });
  }

  void register() async {
    final navigator = Navigator.of(context);
    Map data = {
      'nama': _nama.text,
      'username': _username.text,
      'password': _password.text,
      'tgl_lahir': _tglLahir.text,
    };

    try {
      Response response = await dio().post('register', data: data);

      if (response.statusCode == 200) {
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    } on DioError catch (e) {
      SnackBar snackBar = SnackBar(
        content: Text('Gagal mendaftar, ${e.response!.data["message"]}'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      context.loaderOverlay.hide();
    }
  }
}
