import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'add_boat.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(context),
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
            const SizedBox(
              height: 160,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the addBoat.dart page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBoatPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF18848C),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'Assets/icons/plus-large-svgrepo-com.svg',
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Ajouter une\nembarcation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins-Bold',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 200),
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
