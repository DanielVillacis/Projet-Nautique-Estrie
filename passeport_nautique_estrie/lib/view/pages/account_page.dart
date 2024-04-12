import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context, 'Mes infos'),
      body: SingleChildScrollView(  
      ),
    );
  }
}