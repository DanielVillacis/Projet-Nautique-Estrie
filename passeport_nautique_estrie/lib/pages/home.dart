import 'package:flutter/material.dart';
import 'add_boat.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context),
      drawer: drawer(context),
      body: body(context),
      bottomNavigationBar: footer(context),
    );
  }

  Center body(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Mes Embarcations',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins-Bold',
              ),
            ),
            Expanded(
              child: ListView.builder(
                // itemCount: embarcations.length,
                itemBuilder: (context, index) {
                  // Replace 'EmbarcationItem' with your custom widget to display each item
                  // return EmbarcationItem(embarcation: embarcations[index]);
                },
              ),
            ),
            Image.asset(
              'Assets/CREE_Logo - vert.png',
              width: 140,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  AppBar appBar(context) {
    return AppBar(
      title: const Text(
        'Accueil',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w200,
          fontFamily: 'Poppins-Light',
        ),
      ),
      backgroundColor: const Color(0xFF3A7667),
      centerTitle: false,
    );
  }

  Drawer drawer(context) {
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
            onTap: () {
              // Update navigation to handle drawer item tap
            },
          ),
        ],
      ),
    );
  }

  Container footer(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 1.0,
              color:
                  Colors.grey), // Adjust the border color and width as needed
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the addBoat.dart page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBoatPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18848C),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Ajouter une embarcation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Bold',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle 'Prêter une embarcation' button tap
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18848C),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Prêter une embarcation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Bold',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
