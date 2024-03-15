import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: inscriptionBody(context),
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

  Center inscriptionBody(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(top: 60),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Text(
            "Inscription de l'embarcation",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              fontFamily: 'Poppins-Light',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Marque',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Modèle',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Longueur',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          // Add "enregistrer" button
          ElevatedButton(
            onPressed: () {
              // Add onPressed function
            },
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF18848C),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(260, 40),
            ),
            child: const Text('Enregistrer',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins-Bold')),
          ),
          const SizedBox(
            height: 90,
          ),
          Image.asset(
            'Assets/CREE_Logo - vert.png',
            width: 140,
          ),
        ]),
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
