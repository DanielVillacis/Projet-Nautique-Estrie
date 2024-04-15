import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';
import 'package:passeport_nautique_estrie/view/pages/embarcation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareBoat extends StatefulWidget {
  final String embarcationUtilisateur;

  const ShareBoat(this.embarcationUtilisateur, {Key? key}) : super(key: key);

  @override
  _ShareBoatState createState() =>
      _ShareBoatState(embarcationUtilisateur);
}

class _ShareBoatState extends State<ShareBoat> {
  final String embarcationUtilisateur;
  _ShareBoatState(this.embarcationUtilisateur);
  List<List<dynamic>> details = [];

  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  String dernierLavage = "Aucun lavage";

  String derniereMiseEau = "Aucune mise à l\'eau";

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
      DB.closeConnection(connection);
      setState(() {
        details = results;
        _isLoading = false;
      });

      final prefs = await SharedPreferences.getInstance();
      dernierLavage =
          prefs.getString('lastLavage${results[0][5]}') ?? 'Aucun lavage';
      derniereMiseEau = prefs.getString('lastMiseEau${results[0][5]}') ??
          'Aucune mise à l\'eau';
    } catch (e) {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context, 'Partage d\'embarcation'),
      body: _isLoading ? _buildLoadingIndicator() : Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: passCard(),
        ),
      ),
      );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                  'assets/CREE_Logo - vert.png',
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
                const Text(
                  "Code de l'Embarcation",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  embarcationUtilisateur,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 40),
                infoLine("Nom :"  , details[0][0]),
                infoLine("Marque :", details[0][2]),
                infoLine("Dernier Lavage :", dernierLavage),
                const SizedBox(height: 60),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Pour partager votre embarcation, communiquez ce code unique d'embarcation. \nFaites attention. La personne avec qui vous partagez votre embarcation pourra voir vos dernières\n mises à l'eau et vos derniers lavages.", 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),)
                )
              ],
            )),
      ]),
    );
  }

  Widget infoLine(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            data,
            textAlign: TextAlign.right, // Align text to the right
            style: const TextStyle(
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
