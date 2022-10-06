import 'package:apdks/nav_drawer.dart';
import 'package:apdks/providers/auth.dart';
import 'package:apdks/screens/login.dart';
import 'package:apdks/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _tglLahir = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _showPassword = false;
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    _nama.text = auth.user == null ? "" : auth.user!.nama!;
    _username.text = auth.user == null ? "" : auth.user!.username!;
    _tglLahir.text = auth.user == null ? "" : auth.user!.tanggalLahir!;

    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
        ),
        drawer: const DrawerWidget(),
        body: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/avatar.png",
                        width: 150,
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
                                readOnly: _editMode ? false : true,
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
                                readOnly: _editMode ? false : true,
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
                              if (_editMode)
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
                                      icon:
                                          Icon(_showPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill),
                                    ),
                                  ),
                                ),
                              TextFormField(
                                readOnly: true,
                                keyboardType: TextInputType.none,
                                controller: _tglLahir,
                                onTap: _editMode ? () => pickDate(context) : null,
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
                                  if (_editMode) {
                                    if (_formKey.currentState!.validate()) {
                                      context.loaderOverlay.show();
                                      updateProfil(context);
                                    }
                                  } else {
                                    setState(() {
                                      _editMode = true;
                                    });
                                  }
                                },
                                child: Text(_editMode ? "Simpan" : "Edit"),
                              ),
                              if (_editMode)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _editMode = false;
                                    });
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
                                  ),
                                  child: const Text("Batal"),
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

  void updateProfil(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    Map data = {
      'nama': _nama.text,
      'username': _username.text,
      'password': _password.text,
      'tgl_lahir': _tglLahir.text,
    };

    try {
      Response response = await dio(token: auth.token).put('update-profil', data: data);

      if (response.statusCode == 200) {
        auth.updateUser(response.data['user']);

        const snackBar = SnackBar(
          content: Text('Update profil berhasil'),
        );

        scaffoldMessenger.showSnackBar(snackBar);
        setState(() {
          _editMode = false;
        });
      }
    } on DioError catch (e) {
      SnackBar snackBar = SnackBar(
        content: Text('Gagal update profil, ${e.response!.data["message"]}'),
      );

      scaffoldMessenger.showSnackBar(snackBar);
    }

    context.loaderOverlay.hide();
  }
}
