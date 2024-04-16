import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/model/embarcation_model.dart';
import 'package:passeport_nautique_estrie/view/pages/home.dart';

class BoatPreviewPage extends StatefulWidget {
  final String identifier;
  final String nom;

  const BoatPreviewPage({
    Key? key,
    required this.identifier,
    required this.nom,
  }) : super(key: key);

  @override
  _BoatPreviewPageState createState() => _BoatPreviewPageState();
}

class _BoatPreviewPageState extends State<BoatPreviewPage> {
  late EmbarcationModel _embarcationModel;
  late String nom;

  @override
  void initState() {
    super.initState();
    _embarcationModel = EmbarcationModel(widget.identifier);
    nom = widget.nom;
    _fetchDetailsSingleEmbarcation();
  }

  Future<void> _fetchDetailsSingleEmbarcation() async {
    try {
      await _embarcationModel.fetchDetailsSingleEmbarcation();
      setState(() {}); // Update the UI after fetching data
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context, 'Embarcation'),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 300,
            margin: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildBody(),
            ),
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            data,
            textAlign: TextAlign.right, // Align text to the right
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBody() {
    if (_embarcationModel.isLoading) {
      return [
        const CircularProgressIndicator(),
      ];
    } else if (_embarcationModel.details.isEmpty ||
        _embarcationModel.details
            .every((element) => element.every((element) => element == null))) {
      return [
        const Text('Aucune embarcation correspond a l\'identifiant entré'),
        ElevatedButton(
          onPressed: () {
            // Navigate back to the previous page
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF18848C),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Retour',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins-Bold',
            ),
          ),
        ),
      ];
    } else {
      return [
        Container(
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
                      infoLine('Embarcation :', nom,),
                      const SizedBox(height: 10),
                      infoLine('Marque :', _embarcationModel.details[0][2]),
                      const SizedBox(height: 10),
                      infoLine('Longueur', _embarcationModel.details[0][3].toString()),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        child: FutureBuilder<String?>(
                          future:
                              _embarcationModel.getImageUrl(_embarcationModel.details[0][4]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error loading image');
                            } else {
                              return Image.network(
                                snapshot.data!,
                                width: 200,
                                height: 200,
                              );
                            }
                          },
                        )
                      ),
                    ],
                  )),
            ]),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
          onPressed: () async {
            // Call the addEmbarcationUtilisateur function
            await _embarcationModel.addEmbarcationUtilisateur(
              _embarcationModel.details[0][0], // Pass the identifier
              nom, // Pass the name
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF18848C),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Ajouter cette embarcation à mon compte',
            textAlign: TextAlign.center, // Center the text
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ];
    }
  }
}
