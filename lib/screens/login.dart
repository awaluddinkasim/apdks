import 'package:apdks/providers/auth.dart';
import 'package:apdks/screens/home.dart';
import 'package:apdks/screens/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool showPassword = false;

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
    }
    if (provider.authenticated != null && provider.authenticated == false) {
      Future.delayed(Duration.zero, () {
        context.loaderOverlay.hide();
      });
    }
    return LoaderOverlay(
      child: Scaffold(
        body: ListView(
          children: [
            Transform(
              transform: Matrix4.translationValues(0, -50, 0),
              child: Stack(
                children: [
                  ClipPath(
                    clipper: CustomClipPath2(),
                    child: Container(
                      color: Colors.grey.withOpacity(0.6),
                      height: 300,
                    ),
                  ),
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 300,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Selamat Datang",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                      obscureText: showPassword ? false : true,
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(showPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill),
                        ),
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
                    if (provider.errorMsg != null)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: Colors.orange.shade400,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              provider.errorMsg!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.loaderOverlay.show();
                          login();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Login"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Belum punya akun?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Daftar Disini",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
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

  void login() {
    Map data = {
      "username": _username.text,
      "password": _password.text,
    };

    Provider.of<Auth>(context, listen: false).login(creds: data);
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h - 50);
    path.quadraticBezierTo(
      w * 0.5,
      h - 50,
      w,
      h,
    );
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomClipPath2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h - 30);
    path.quadraticBezierTo(
      w * 0.5,
      h - 50,
      w,
      h,
    );
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
