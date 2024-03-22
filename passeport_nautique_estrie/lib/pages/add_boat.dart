import 'package:flutter/material.dart';
import 'inscription.dart';
import 'home.dart';

class AddBoatPage extends StatefulWidget {
  const AddBoatPage({Key? key}) : super(key: key);

  @override
  _AddBoatPageState createState() => _AddBoatPageState();
}

class _AddBoatPageState extends State<AddBoatPage> {
  bool showPermitForm = false;
  final permitController = TextEditingController();

  String? permitNumber; // Add a variable to store the permit number

  @override
  void dispose() {
    permitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const HomePage(
        boatData: {},
      ).appBar(context),
      body: addBoatBody(context),
    );
  }

  Widget addBoatBody(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Avez-vous un permis d'embarcation ?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins-Bold',
              ),
              textAlign: TextAlign.center,
            ),
            // Add your specific widgets for the Add Boat Page here
            const SizedBox(height: 30),
            Image.asset(
              'Assets/boat-license.jpg',
              width: 280,
            ),
            const SizedBox(height: 10),
            if (!showPermitForm) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showPermitForm = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF18848C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Oui',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InscriptionPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF18848C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Non',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Column(
                children: [
                  TextFormField(
                    controller: permitController,
                    decoration: const InputDecoration(
                      labelText: 'Numéro de permis',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      permitNumber = permitController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InscriptionPage(
                            permitNumber: permitNumber,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF18848C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
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
            ],
            const SizedBox(height: 60),
            Image.asset(
              'Assets/CREE_Logo - vert.png',
              width: 140,
            ),
          ],
        ),
      ),
    );
  }
}
