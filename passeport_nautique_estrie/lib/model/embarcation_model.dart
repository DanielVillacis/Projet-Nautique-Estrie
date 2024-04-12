import 'package:passeport_nautique_estrie/db.dart';
import 'package:passeport_nautique_estrie/services/firebase_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmbarcationModel {
  String embarcationUtilisateur;
  List<List<dynamic>> details = [];
  bool isLoading = true;

  EmbarcationModel(this.embarcationUtilisateur);

  Future<void> fetchDetailsEmbarcations() async {
    try {
      final connection = await DB.getConnection();
      var results = await connection.query(
        "select * from voir_details_embarcationUtilisateur(@eu)",
        substitutionValues: {"eu": embarcationUtilisateur},
      );
      details = results;
      isLoading = false;
      await connection.close();
    } catch (e) {
      print("Error fetching data: $e");
      isLoading = false;
    }
  }

  Future<void> fetchDetailsSingleEmbarcation() async {
    try {
      final connection = await DB.getConnection();
      var results = await connection.query(
        "select * from voir_details_embarcation(@eu)",
        substitutionValues: {"eu": embarcationUtilisateur},
      );
      details = results;
      isLoading = false;
      await connection.close();
    } catch (e) {
      print("Error fetching data: $e");
      isLoading = false;
    }
  }

  Future<String?> getImageUrl(String file) async {
    // Use FirebaseStorageService to fetch image URL based on embarcationUtilisateur
    return FirebaseStorageService().getImage(file);
  }

  Future<void> addEmbarcationUtilisateur(
      String id_embarcation, String nom) async {
    try {
      final connection = await DB.getConnection();
      final prefs = await SharedPreferences.getInstance();
      final sub = prefs.getString('sub');
      await connection.query(
        "CALL ajouter_embarcation_utilisateur(@sub, @id_embarcation, @nom);",
        substitutionValues: {
          "sub": sub,
          "id_embarcation": id_embarcation,
          "nom": nom
        },
      );
      isLoading = false;
      await connection.close();
    } catch (e) {
      print("Error fetching data: $e");
      isLoading = false;
    }
  }
}
