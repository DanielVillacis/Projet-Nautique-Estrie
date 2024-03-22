import 'package:flutter/material.dart';
import 'home.dart';

class InscriptionPage extends StatefulWidget {
  final String? permitNumber;

  const InscriptionPage({
    Key? key,
    this.permitNumber,
  }) : super(key: key);

  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  String? selectedBoatType;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController marqueController = TextEditingController();
  TextEditingController modeleController = TextEditingController();
  TextEditingController longueurController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    descriptionController.dispose();
    marqueController.dispose();
    modeleController.dispose();
    longueurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // use the home.dart appBar function
      resizeToAvoidBottomInset: false,
      // use the home.dart appBar function
      appBar: HomePage(
        boatData: {},
      ).appBar(context),
      body: inscriptionBody(context),
    );
  }

  Center inscriptionBody(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(top: 60),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Text(
            "Inscription de l'embarcation",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              fontFamily: 'Poppins-Light',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.permitNumber != null) ...[
            const SizedBox(
              height: 6,
            ),
            TextFormField(
              initialValue: widget.permitNumber,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Numéro de permis',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Poppins-Light',
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3A7667)),
                ),
              ),
            ),
          ],
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          TextFormField(
            controller: marqueController,
            decoration: const InputDecoration(
              labelText: 'Marque',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          TextFormField(
            controller: modeleController,
            decoration: const InputDecoration(
              labelText: 'Modèle',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          TextFormField(
            controller: longueurController,
            decoration: const InputDecoration(
              labelText: 'Longueur',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            value: selectedBoatType,
            onChanged: (value) {
              setState(() {
                selectedBoatType = value;
              });
            },
            decoration: const InputDecoration(
              labelText: "Type d'embarcation",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins-Light',
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3A7667)),
              ),
            ),
            items: ['Kayak', 'Boat', 'Paddleboard']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          const SizedBox(
            height: 24,
          ),
          // Add "enregistrer" button
          ElevatedButton(
            // on pressed, call the saveBoatData function and pass the new boat data to the home page
            onPressed: _saveBoatData,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color(0xFF18848C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(260, 40),
            ),
            child: const Text('Enregistrer',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins-Bold')),
          ),
          const SizedBox(
            height: 80,
          ),
          // Image.asset(
          //   'Assets/CREE_Logo - vert.png',
          //   width: 140,
          // ),
        ]),
      ),
    );
  }

  void _saveBoatData() {
    // Save boat data
    Map<String, dynamic> boatData = {
      'permitNumber': widget.permitNumber,
      'description': descriptionController.text,
      'marque': marqueController.text,
      'modele': modeleController.text,
      'longueur': longueurController.text,
      'type': selectedBoatType,
    };
    // Navigate to the home page and pass the new boat data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          boatData: boatData,
        ),
      ),
    );
  }
}
