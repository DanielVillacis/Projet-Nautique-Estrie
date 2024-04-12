import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passeport_nautique_estrie/view/pages/add_boat.dart';
import 'package:passeport_nautique_estrie/view/pages/custom_drawer.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:passeport_nautique_estrie/db.dart';
// import 'package:passeport_nautique_estrie/controller/embarcation_controller.dart';
// import 'package:passeport_nautique_estrie/model/embarcation_model.dart';

class DetailsEmbarcation extends StatefulWidget {
  final String embarcationUtilisateur;

  const DetailsEmbarcation(
      {Key? key,
      required this.embarcationUtilisateur})
      : super(key: key);

  @override
  _DetailsEmbarcationState createState() =>
      _DetailsEmbarcationState(embarcationUtilisateur);
}

class _DetailsEmbarcationState extends State<DetailsEmbarcation> {
  final String embarcationUtilisateur;
  _DetailsEmbarcationState(this.embarcationUtilisateur);

  List<List<dynamic>> details = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetailsEmbarcations();
  }

  Future<void> _fetchDetailsEmbarcations() async {
    try {
      final connection = await DB.getConnection();
      var results = await connection.query(
        "select * from voir_details_embarcationUtilisateur(@eu)",
        substitutionValues: {"eu": embarcationUtilisateur},
      );
      setState(() {
        details = results;
         _isLoading = false;
      });
      await connection.close();
    } catch (e) {
      print("Error fetching data: $e");
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const HomePage().appBar(context, 'Mon embarcation'),
      drawer: CustomDrawer(
        onEmbarcationsTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsEmbarcation(
                embarcationUtilisateur: embarcationUtilisateur,
              ),
            ),
          );
        },
      ),
      body: _isLoading ? _buildLoadingIndicator() : body(),
      // bottomNavigationBar: footer(context),
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
          width: 290,
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              passCard(),
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF18848C),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ), 
                child: const Text(
                  'Ajouter un lavage', 
                  style: TextStyle(
                    color: Colors.white
                  )
                ),
              )
            ]
          ),
        ),
      ),
    );
  }

  Widget infoLine(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          data,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget passCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      // padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 251, 241),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white, // Change this to your desired color
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Passeport Nautique Estrie',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 10, 10, 10),
                  ),
                ),
              ),
              Image.asset(
                'Assets/CREE_Logo - vert.png',
                height: 50,
              ),
            ],
          ),
        ),
        ),
        Padding(
          padding: const EdgeInsets.all(30), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              infoLine('Embarcation :', details.isNotEmpty ? details[0][0] : ''),
              const SizedBox(height: 10),
              infoLine('Marque :', details.isNotEmpty ? details[0][2] : ''),
              const SizedBox(height: 10),
              infoLine('Dernier Lavage :', ''),
              const SizedBox(height: 10),
              infoLine('Derniere mise a l\'eau :', ''),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onLongPress: () {
                    _showPrintDialog(context);
                    HapticFeedback.vibrate();
                  },
                  child: QrImageView(
                    data: details.isNotEmpty ? details[0][4] : '',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
            ],
          )
        ),
      ]),
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

  // Container footer(BuildContext context) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       border: Border(
  //         top: BorderSide(
  //             width: 1.0,
  //             color:
  //                 Colors.grey), // Adjust the border color and width as needed
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         ElevatedButton(
  //           onPressed: () {
  //             // Navigate to the addBoat.dart page
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => const AddBoatPage(
  //                       )),
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFF18848C),
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(14),
  //             ),
  //           ),
  //           child: const Text(
  //             'Ajouter une embarcation',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 12,
  //               fontWeight: FontWeight.bold,
  //               fontFamily: 'Poppins-Bold',
  //             ),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Handle 'Prêter une embarcation' button tap
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFF18848C),
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(14),
  //             ),
  //           ),
  //           child: const Text(
  //             'Prêter une embarcation',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 12,
  //               fontWeight: FontWeight.bold,
  //               fontFamily: 'Poppins-Bold',
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
