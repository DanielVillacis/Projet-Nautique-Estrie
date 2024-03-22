import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/login.dart';
import 'package:passeport_nautique_estrie/main.dart';
import 'package:passeport_nautique_estrie/profile.dart';

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
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(color: Color(0xFF195444)), // Text color
          ),
          centerTitle: true, // Center the title
        ),
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : _credentials != null
                  ? Profile(logoutAction, _credentials?.user)
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    auth0 = Auth0('dev-lmexjjh8yiz0b2mi.us.auth0.com',
        '8GwTucxYUBqotD7WUwNueykcsb6uAR32');
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
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        errorMessage = e.toString();
      });
    }
  }
}
