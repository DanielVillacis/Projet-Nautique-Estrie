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
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Concernant le Projet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Les espèces exotiques envahissantes sont une menace majeure pour la biodiversité, les écosystèmes et l'économie. Le CRE Estrie vise à coordonner les efforts de prévention contre ces espèces dans la région en dirigeant la table estrienne sur les espèces exotiques envahissantes (TEEEE). En agissant en tant que rassembleur, le CRE Estrie cherche à uniformiser les actions de lutte pour contrer cette menace.", 
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Light', fontWeight: FontWeight.w300), textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Questions?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Pour toutes questions concernant le projet, contactez-nous au eee@environnementestrie.ca', // Replace with your email
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Light', fontWeight: FontWeight.w300), textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Image.asset('assets/CREE_Logo - vert.png', width: 200, height: 80,), // Replace with your logo path
            ],
          ),
        ),
    );
  }
}

