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
      appBar: AppBar(
        title: const Text(
          'Embarcation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w200,
            fontFamily: 'Poppins-Light',
          ),
        ),
        backgroundColor: const Color(0xFF3A7667),
        centerTitle: false,
      ),
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
        Text(
          'Nom: $nom',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder<String?>(
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
        ),
        const SizedBox(height: 20),
        Text(
          'Longueur: ${_embarcationModel.details[0][3]}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          'Marque: ${_embarcationModel.details[0][2]}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          'Description: ${_embarcationModel.details[0][1]}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Rajouter cette embarcation à mon compte',
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
