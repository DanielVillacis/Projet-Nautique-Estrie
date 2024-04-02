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
          child: isBusy
              ? const CircularProgressIndicator()
              : _credentials != null
                  ? HomePage(logoutAction: logoutAction)
                  : Login(loginAction, errorMessage),
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

  Future<void> logoutAction() async {
    await auth0.webAuthentication(scheme: appScheme).logout();

    setState(() {
      _credentials = null;
    });
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final Credentials credentials =
          await auth0.webAuthentication(scheme: appScheme).login();
      setState(() {
        isBusy = false;
        _credentials = credentials;
      });

      final conn = await DB.getConnection();
      await conn
          .execute(('CALl login(@sub, @nom, @prenom)'), substitutionValues: {
        'sub': credentials.user.sub,
        'nom': credentials.user.name,
        'prenom': credentials.user.givenName,
      });
      DB.closeConnection(conn);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sub', credentials.user.sub);
      await prefs.setString('prenom', credentials.user.givenName ?? 'n/a');
      await prefs.setString('nom', credentials.user.familyName ?? 'n/a');
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        errorMessage = e.toString();
      });
    }
  }
}
