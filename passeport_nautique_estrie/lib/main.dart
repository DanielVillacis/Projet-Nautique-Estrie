/// -----------------------------------
///          External Packages
/// -----------------------------------
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/app_state.dart';

const appScheme = 'flutterdemo';

late Auth0 auth0;

/// -----------------------------------
///                 App
/// -----------------------------------

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  
  MyAppState createState() => MyAppState();

}