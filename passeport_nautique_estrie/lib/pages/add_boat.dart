import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'inscription.dart';

class AddBoatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: addBoatBody(context),
      bottomNavigationBar: footer(context),
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
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'Assets/icons/check-circle-svgrepo-com.svg',
              height: 26,
              width: 26,
              color: const Color.fromARGB(255, 65, 65, 65),
            ),
            label: 'Mes Codes',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'Assets/icons/settings-svgrepo-com.svg',
              height: 26,
              width: 26,
              color: const Color.fromARGB(255, 65, 65, 65),
            ),
            label: 'Paramètres',
          ),
        ],
        // Other properties...
        backgroundColor: const Color(0xFFF6F7E9),
      ),
    );
  }

  Center addBoatBody(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Avez vous un permis d'embarcation ?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins-Bold',
              ),
              textAlign: TextAlign.center,
            ),
            // Add your specific widgets for the Add Boat Page here
            const SizedBox(height: 30),
            Image.asset(
              'Assets/boat-license.jpg',
              width: 280,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the page for adding a boat
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InscriptionPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18848C),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Oui',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the page for adding a boat
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InscriptionPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18848C),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Non',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 90),
            Image.asset(
              'Assets/CREE_Logo - vert.png',
              width: 140,
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
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
      leading: GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFF3A7667)),
            child: SvgPicture.asset(
              'Assets/icons/menu-svgrepo-com.svg',
              height: 30,
              width: 30,
              color: const Color.fromARGB(255, 31, 62, 54),
            ),
          )),
      actions: [
        GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF3A7667),
              ),
              child: SvgPicture.asset(
                'Assets/icons/notification-svgrepo-com.svg',
                height: 30,
                width: 30,
                color: const Color.fromARGB(255, 31, 62, 54),
              ),
            )),
      ],
    );
  }
}
