import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final VoidCallback onNavigateToHomePage; // Define the callback function type

  const Login({Key? key, required this.onNavigateToHomePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            //await loginAction();
            signInWithGoogle();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            // }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF195444), // Background color
            minimumSize: const Size(200, 50),
          ),
          child: const Text(
            'Me connecter',
            style: TextStyle(color: Color(0xFF08A2A8)), // Text color
          ),
        ),
      ],
    );
  }

  Future<int> signInWithGoogle() async {
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
        return 1;
      } else {
        print("Failed to sign in with Google");
        return 0;
      }
    } else {
      print("Failed to sign in with Google");
      return 0;
    }
  }
}
