import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context, 'À propos'),
      body: const SingleChildScrollView(  
      ),
    );
  }
}