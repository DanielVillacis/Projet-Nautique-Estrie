import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center (
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Des Questions?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Pour toute aide ou questions, veuillez nous contacter à l'adresse: ",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),

                      ),
                      TextSpan(
                        text: 'eee@environnementestrie.ca', // Replace with your email
                        style: const TextStyle(color: Color.fromARGB(255, 29, 97, 154), fontSize: 18, decoration: TextDecoration.underline), 
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'eee@environnementestrie.ca',
                              query: 'subject=App Support&body=Hello, I need help with...',
                            );
                            launchUrlString(emailLaunchUri.toString());
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 380),
                Image.asset(
                    'assets/CREE_Logo - vert.png', // Replace with your logo path
                    width: 240, // Adjust width as needed
                    height: 80, // Adjust height as needed
                ),
              ],
            ),
          ),
      ),
    );
  }
}