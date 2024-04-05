import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set button background color
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                icon: Image.asset(
                  'Assets/google_logo.png', // Path to your Google logo image asset
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
        await conn
            .execute(('CALl login(@sub, @nom, @prenom)'), substitutionValues: {
          'sub': googleUser.id,
          'nom': googleUser.displayName,
          'prenom': googleUser.displayName,
        });
        DB.closeConnection(conn);

        final prefs = await SharedPreferences.getInstance();
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
