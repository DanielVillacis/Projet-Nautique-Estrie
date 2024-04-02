import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passeport_nautique_estrie/view/pages/add_boat.dart';
import 'package:passeport_nautique_estrie/view/pages/custom_drawer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:passeport_nautique_estrie/controller/embarcation_controller.dart';
import 'package:passeport_nautique_estrie/model/embarcation_model.dart';

class DetailsEmbarcation extends StatefulWidget {
  final Future<void> Function() logoutAction;
  final String embarcationUtilisateur;

  const DetailsEmbarcation(
      {Key? key,
      required this.logoutAction,
      required this.embarcationUtilisateur})
      : super(key: key);

  @override
  _DetailsEmbarcationState createState() =>
      _DetailsEmbarcationState(logoutAction, embarcationUtilisateur);

  PreferredSizeWidget appBar(context) {
    return AppBar(
      title: const Text(
        'Accueil',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w200,
          fontFamily: 'Poppins-Light',
        ),
      ),
      backgroundColor: const Color(0xFF3A7667),
      centerTitle: false,
    );
  }
}

class _DetailsEmbarcationState extends State<DetailsEmbarcation> {
  final Future<void> Function() logoutAction;
  final String embarcationUtilisateur;
  final EmbarcationModel model;
  final EmbarcationController controller;

  _DetailsEmbarcationState(this.logoutAction, this.embarcationUtilisateur)
      : model = EmbarcationModel(embarcationUtilisateur),
        controller = EmbarcationController(embarcationUtilisateur) {
    controller.fetchDetails();
        }

  List<List<dynamic>> details = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DetailsEmbarcation(
        logoutAction: logoutAction,
        embarcationUtilisateur: embarcationUtilisateur,
      ).appBar(context),
      drawer: CustomDrawer(
        onEmbarcationsTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsEmbarcation(
                logoutAction: logoutAction,
                embarcationUtilisateur: embarcationUtilisateur,
              ).appBar(context),
            ),
          );
        },
        logoutAction: logoutAction,
      ),
      body: model.isLoading ? _buildLoadingIndicator() : body(),
      bottomNavigationBar: footer(context),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 400,
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Embarcation:\n ${details.isNotEmpty ? details[0][0] : ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Poppins-Bold',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onLongPress: () {
                    _showPrintDialog(context);
                    HapticFeedback.vibrate();
                  },
                  child: QrImageView(
                    data: details[0][4], // Data for the QR code
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFieldRow(
                      'Description', details.isNotEmpty ? details[0][1] : ''),
                  const SizedBox(height: 8), // Add spacing between fields
                  buildFieldRow(
                      'Marque', details.isNotEmpty ? details[0][2] : ''),
                  const SizedBox(height: 8), // Add spacing between fields
                  buildFieldRow('longueur',
                      '${details.isNotEmpty ? details[0][3] : ''} po'),
                  const SizedBox(height: 8), // Add spacing between fields
                ],
              ),
              const SizedBox(height: 8), // Add spacing between fields and image
              Image.network(
                details[0][4],
                width: 300, // Adjust the width of the image as needed
                height: 300, // Adjust the height of the image as needed
                fit: BoxFit.cover, // Adjust the fit of the image as needed
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFieldRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              fontFamily: 'Poppins-Bold',
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                value,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container footer(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 1.0,
              color:
                  Colors.grey), // Adjust the border color and width as needed
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the addBoat.dart page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddBoatPage(
                          logoutAction: logoutAction,
                        )),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18848C),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Ajouter une embarcation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Bold',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle 'Prêter une embarcation' button tap
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18848C),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Prêter une embarcation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-Bold',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Imprimer le code d' 'embarcation?'),
          content: const Text(
              'Voulez-vous imprimer le code QR de votre embarcation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Implement printing functionality here
                // For example, you can use a package like 'printing' to print the QR code
                // https://pub.dev/packages/printing
                Navigator.of(context).pop();
              },
              child: Text('Imprimer'),
            ),
          ],
        );
      },
    );
  }
}
