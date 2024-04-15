import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';
import 'package:passeport_nautique_estrie/view/pages/preview.dart';

class AddExistingBoat extends StatefulWidget {
  const AddExistingBoat({Key? key}) : super(key: key);

  @override
  _AddExistingBoatState createState() => _AddExistingBoatState();
}

class _AddExistingBoatState extends State<AddExistingBoat> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _nomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context, "Partage d'embarcation"),
      body: Center(
        // Center the content vertically
        child: SingleChildScrollView(
          child: addBoatBody(context),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget addBoatBody(BuildContext context) {
    return Container(
      // Wrap the Column in a Container to center it
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Entrez l'identifiant de l'embarcation",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins-Bold',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _identifierController,
            decoration: const InputDecoration(
              labelText: "Identifiant de l'embarcation",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Entrez le nom souhaité pour l'embarcation",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins-Bold',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nomController,
            decoration: const InputDecoration(
              labelText: "Nom de l'embarcation",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String enteredIdentifier = _identifierController.text;
              String enteredNom = _nomController.text;
              if (enteredIdentifier.isNotEmpty && enteredNom.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoatPreviewPage(
                      identifier: enteredIdentifier,
                      nom: enteredNom,
                    ),
                  ),
                );
              } else {
                // Handle empty fields
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18848C),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continuer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
