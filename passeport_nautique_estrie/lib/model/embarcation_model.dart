import 'package:passeport_nautique_estrie/db.dart';

class EmbarcationModel {
  String embarcationUtilisateur;
  List<List<dynamic>> details = [];
  bool isLoading = true;

  EmbarcationModel(this.embarcationUtilisateur);

  Future<void> fetchDetailsEmbarcations() async {
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
}