import 'package:flutter/material.dart';

class ShareBoat extends StatelessWidget {
  final String embarcationUtilisateur;

  const ShareBoat(this.embarcationUtilisateur, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partage d\'embarcation.'),
        backgroundColor: const Color(0xFF3A7667),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SelectableText(
            'Pour partager votre embarcation, communiquez ce code unique d\'embarcation : $embarcationUtilisateur',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
