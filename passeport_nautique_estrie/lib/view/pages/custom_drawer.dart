import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/login.dart';
import 'package:passeport_nautique_estrie/view/pages/account_page.dart';
import 'package:passeport_nautique_estrie/view/pages/help_page.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';
import 'package:passeport_nautique_estrie/view/pages/information_page.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback? onEmbarcationsTap;
  // Add more parameters as needed

  const CustomDrawer({
    Key? key,
    this.onEmbarcationsTap,
    // Add more parameters as needed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF3A7667),
            ),
            child: Text(
              'Mon Passeport Nautique',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Bold',
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Mes embarcations'),
            onTap: () {
              // navigate to the home page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Mes infos'),
            onTap: () {
              // navitage to the account page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          ListTile(
            title: const Text('A propos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InformationPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Aide'),
            onTap: () {
              // Update navigation to handle drawer item tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Me déconnecter'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          ),
        ],
      ),
    );
  }
}
