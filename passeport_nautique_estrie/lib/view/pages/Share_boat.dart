import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';

class ShareBoat extends StatelessWidget {
  final String embarcationUtilisateur;

  const ShareBoat(this.embarcationUtilisateur, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context, 'Partage d\'embarcation'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SelectableText(
            'Pour partager votre embarcation, communiquez ce code unique d\'embarcation : $embarcationUtilisateur'
            '\nFaites attention. La personne avec qui vous partagez votre embarcation pourra voir vos dernières'
            '\n mise à l\'eau et vos derniers lavages',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18.0, fontFamily: 'Poppins-Light', fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
