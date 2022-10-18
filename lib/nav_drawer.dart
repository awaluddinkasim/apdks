import 'package:apdks/providers/auth.dart';
import 'package:apdks/screens/dokter.dart';
import 'package:apdks/screens/home.dart';
import 'package:apdks/screens/login.dart';
import 'package:apdks/screens/profil.dart';
import 'package:apdks/screens/result.dart';
import 'package:apdks/screens/diagnosa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);

    if (provider.authenticated == null || provider.authenticated == false) {
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      });
    }
    return LoaderOverlay(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    width: 80,
                    height: 80,
                    child: Image.asset("assets/avatar.png"),
                  ),
                  Text(
                    "${provider.user != null ? provider.user?.nama : ''}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${provider.user != null ? provider.user?.username : ''}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(
              icon: Icons.home,
              text: "Home",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            _drawerItem(
              icon: CupertinoIcons.doc_checkmark_fill,
              text: "Diagnosa",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DiagnosaScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            _drawerItem(
              icon: Icons.file_copy,
              text: "Hasil Diagnosa",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResultScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            _drawerItem(
              icon: Icons.local_hospital,
              text: "Dokter",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            _drawerItem(
              icon: Icons.person,
              text: "Profil",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            const Divider(),
            _drawerItem(
              icon: Icons.exit_to_app,
              text: "Logout",
              onTap: () {
                context.loaderOverlay.show();
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile _drawerItem({required IconData icon, required String text, onTap}) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
