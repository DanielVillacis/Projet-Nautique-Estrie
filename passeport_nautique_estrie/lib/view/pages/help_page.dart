import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context, 'Aide'),
      body: SingleChildScrollView(  
      ),
    );
  }
}