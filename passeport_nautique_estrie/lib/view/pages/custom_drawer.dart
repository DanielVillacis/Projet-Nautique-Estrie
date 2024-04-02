import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback? onEmbarcationsTap;
  final Future<void> Function() logoutAction;
  // Add more parameters as needed

  const CustomDrawer({
    Key? key,
    this.onEmbarcationsTap,
    required this.logoutAction,
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
                MaterialPageRoute(builder: (context) =>  HomePage(logoutAction: logoutAction,)),
              );
            },
          ),
          ListTile(
            title: const Text('Mes infos'),
            onTap: () {
              // Update navigation to handle drawer item tap
            },
          ),
          ListTile(
            title: const Text('A propos'),
            onTap: () {
              // Update navigation to handle drawer item tap
            },
          ),
          ListTile(
            title: const Text('Aide'),
            onTap: () {
              // Update navigation to handle drawer item tap
            },
          ),
          ListTile(
              title: const Text('Me déconnecter'),
              onTap: () async {
                logoutAction();
              }),
        ],
      ),
    );
  }
}