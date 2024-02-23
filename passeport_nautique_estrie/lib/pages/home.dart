import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: Text(
      'Accueil',
      style: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.w200,
        fontFamily: 'Poppins-Light',
      ),
    ),
    backgroundColor: Color(0xFF3A7667),
    centerTitle: false,
    leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(16),
          child: SvgPicture.asset(
            'Assets/icons/menu-svgrepo-com.svg',
            height: 30,
            width: 30,
            color: Color.fromARGB(255, 31, 62, 54),
          ),
          decoration: BoxDecoration(color: Color(0xFF3A7667)),
        )),
    actions: [
      GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.all(10),
            child: SvgPicture.asset(
              'Assets/icons/notification-svgrepo-com.svg',
              height: 30,
              width: 30,
              color: Color.fromARGB(255, 31, 62, 54),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF3A7667),
            ),
          )),
    ],
  );
}
