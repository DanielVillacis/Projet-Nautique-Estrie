import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Your custom UI elements for the login page
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Bienvenue sur le\nPasseport Nautique de l\'estrie',
                textAlign: TextAlign.center, // Center text
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10), // Add space between title and subtitle
            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Connectez-vous pour continuer', // Your subtitle text
                textAlign: TextAlign.center, // Center subtitle text
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Set subtitle text color
                ),
              ),
            ),
            const SizedBox(height: 20), // Add space between subtitle and button
            // Google sign-in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton.icon(
                onPressed: () async {
                  // Call the method to handle Google sign-in
                  bool loggedIn = await _handleGoogleSignIn(context);
                  if (loggedIn) {
                    // Navigate to the home page if sign-in is successful
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // Set button background color
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                icon: Image.asset(
                  'assets/google_logo.png', // Path to your Google logo image asset
                  height: 24, // Adjust the height of the Google logo
                ),
                label: const Flexible(
                  child: Text(
                    'Connexion avec Google ', // Button label text
                    textAlign: TextAlign.center, // Center button label text
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Set button label text color
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleGoogleSignIn(BuildContext context) async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        final conn = await DB.getConnection();
        var result1 = await conn.query(
          'SELECT * FROM login(@sub, @display_name)',
          substitutionValues: {
            'sub': googleUser.id,
            'display_name': googleUser.displayName,
          },
        );
        var result2 = await conn.query(
          'SELECT * from get_last_lavage2(@sub);',
          substitutionValues: {
            'sub': googleUser.id,
          },
        );
        var result3 = await conn.query(
          'SELECT * from get_last_mise_a_eau2(@sub);',
          substitutionValues: {
            'sub': googleUser.id,
          },
        );
        DB.closeConnection(conn);
        final prefs = await SharedPreferences.getInstance();
        DateFormat dateformat = DateFormat('yyyy-MM-dd HH:mm');

        List<Map<String, dynamic>> lavages = [];
        for (var row in result2) {
          String idEmbarcation = row[0] as String;
          DateTime? lastLavage =
              row[1] as DateTime?; // Assuming DateTime for last_lavage

          // Create a map to store the values
          Map<String, dynamic> lavageMap = {
            'id_embarcation': idEmbarcation,
            'last_lavage': lastLavage,
          };

          // Add the map to the list
          lavages.add(lavageMap);
          if (lastLavage != null) {
            await prefs.setStringList('lastLavage$idEmbarcation',
                [idEmbarcation, dateformat.format(lastLavage!)]);
          }else{
            
          await prefs.setStringList('lastLavage$idEmbarcation',
              [idEmbarcation, 'n/a']);
          }
        }

        List<Map<String, dynamic>> misesAEau = [];
        for (var row in result2) {
          String idEmbarcation = row[0] as String;
          DateTime? lastMiseEau =
              row[1] as DateTime?; // Assuming DateTime for last_lavage

          // Create a map to store the values
          Map<String, dynamic> misesAEauMap = {
            'id_embarcation': idEmbarcation,
            'last_mise_eau': lastMiseEau,
          };

          // Add the map to the list
          misesAEau.add(misesAEauMap);
          if (lastMiseEau != null) {
            await prefs.setStringList('lastMiseEau$idEmbarcation',
                [idEmbarcation, dateformat.format(lastMiseEau!)]);
          }else{
            
          await prefs.setStringList('lastMiseEau$idEmbarcation',
              [idEmbarcation, 'n/a']);
          }
        }
        List<String> roles = [];
        for (List<dynamic> sublist in result1) {
          if (sublist.isNotEmpty) {
            roles.add(sublist[0] as String);
          }
        }
        await prefs.setStringList('roles', roles);
        await prefs.setString('sub', googleUser.id);
        await prefs.setString('prenom', googleUser.displayName ?? 'n/a');
        await prefs.setString('nom', googleUser.displayName ?? 'n/a');
        return true;
      } else {
        print("Failed to sign in with Google");
        return false;
      }
    } else {
      print("Failed to sign in with Google");
      return false;
    }
  }
}
