import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'package:passeport_nautique_estrie/env_config.dart';
import 'package:passeport_nautique_estrie/login.dart';
import 'package:passeport_nautique_estrie/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/pages/home.dart';

class MyAppState extends State<MyApp> {
  Credentials? _credentials;
  late Auth0 auth0;

  bool isBusy = false;
  late String errorMessage;
  final title = "Passeport Nautique de l'estrie";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Place your login widget here
              Login(
                onNavigateToHomePage: () {
                  // Navigation logic to the HomePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    auth0 = Auth0(
        EnvironmentConfig().domain ?? '', EnvironmentConfig().clientId ?? '');
    errorMessage = '';
  }

  // Future<void> logoutAction() async {
  //   await auth0.webAuthentication(scheme: appScheme).logout();

  //   setState(() {
  //     _credentials = null;
  //   });
  // }
}