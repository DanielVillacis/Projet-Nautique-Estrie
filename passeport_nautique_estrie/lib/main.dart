import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:passeport_nautique_estrie/app_state.dart';
import 'package:passeport_nautique_estrie/firebase_options.dart';

const appScheme = 'flutterdemo';

late Auth0 auth0;

Future main() async {
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();

  static of(BuildContext context) {}
}
