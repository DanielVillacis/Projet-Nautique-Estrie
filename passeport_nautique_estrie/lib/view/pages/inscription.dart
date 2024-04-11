import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';
import 'package:passeport_nautique_estrie/controller/inscription_controller.dart';

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
  final controller = InscriptionController();

  _InscriptionPageState({Key? key});

  String? selectedBoatType;
  TextEditingController nomController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController marqueController = TextEditingController();
  TextEditingController modeleController = TextEditingController();
  TextEditingController longueurController = TextEditingController();
  TextEditingController noPermisController = TextEditingController();

  File? _selectedImage;

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
      resizeToAvoidBottomInset: true,
      // use the home.dart appBar function
      appBar: const HomePage().appBar(context),
      body: inscriptionBody(context),
    );
  }

  Widget inscriptionBody(BuildContext context) {
    return Center(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: SizedBox(
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                    controller:
                        TextEditingController(text: widget.permitNumber),
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
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
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
                  keyboardType:
                      TextInputType.number, // Opens numbers only keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly // Allows only digits
                  ],
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      // Check if the entered value contains only digits
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Veuillez entrer seulement un nombre';
                      }
                    }
                    return null; // Return null if validation succeeds
                  },
                  decoration: const InputDecoration(
                    labelText: 'Longueur (po)',
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
                const SizedBox(height: 60),
                // Buttons to add photo or take picture
                ElevatedButton(
                  onPressed: () {
                    _pickImageFromGallery();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18848C),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Ajouter une photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _pickImageFromCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18848C),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Prendre une photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildPictureWidget(),
                const SizedBox(
                  height: 24,
                ),
                // Add "enregistrer" button
                ElevatedButton(
                  // on pressed, call the saveBoatData function and pass the new boat data to the home page
                  onPressed: _saveBoatData,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF18848C),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Widget _buildPictureWidget() {
    return _selectedImage != null
        ? Image.file(
            _selectedImage!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
        : Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.photo,
              size: 80,
              color: Colors.grey[600],
            ),
          );
  }

  Future<void> _saveBoatData() async {
    // Save boat data
    controller.updateBoatData(
      noPermisController.text,
      nomController.text,
      descriptionController.text,
      marqueController.text,
      modeleController.text,
      longueurController.text,
      selectedBoatType!,
      _selectedImage!,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
