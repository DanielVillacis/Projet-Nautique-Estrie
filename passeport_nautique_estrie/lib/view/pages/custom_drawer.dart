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
      child: Column(
    children: <Widget>[
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF3A7667),
            ),
            child: Text(
              'Mon Passeport Nautique',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Bold',
                fontSize: 26,
              ),
            ),
          ),
          ListTile(
            title: const Text('Mes embarcations', style: TextStyle(fontSize: 18)),
            onTap: () {
              // navigate to the home page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Mes infos', style: TextStyle(fontSize: 18)),
            onTap: () {
              // navitage to the account page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('A propos', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InformationPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Aide', style: TextStyle(fontSize: 18)),
            onTap: () {
              // Update navigation to handle drawer item tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Me déconnecter', style: TextStyle(fontSize: 18)),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          ),
          const Expanded(child: SizedBox()),
          Container(
            padding: const EdgeInsets.all(80),
            child: Image.asset(
              'assets/CREE_Logo - vert.png', // Replace with your logo path
              width: 140, // Adjust width as needed
              height: 80, // Adjust height as needed
            ),
          ),
        ],
      ),
      )
    ],
    )
    );
  }
}
