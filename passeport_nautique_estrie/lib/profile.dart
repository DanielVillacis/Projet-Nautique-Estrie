import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final UserProfile? user;

  const Profile(this.user, {final Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _connectToDatabase();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(user?.pictureUrl.toString() ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: ${user?.name}'),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () async {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF195444), // Background color
            minimumSize: const Size(200, 50),
          ),
          child: const Text(
            'Me déconnecter',
            style: TextStyle(color: Color(0xFF08A2A8)), // Text color
          ),
        ),
      ],
    );
  }
}
