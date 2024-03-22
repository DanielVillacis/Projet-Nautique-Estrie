import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError, {final Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await loginAction();
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
        Text(
          loginError,
        ),
      ],
    );
  }
}
