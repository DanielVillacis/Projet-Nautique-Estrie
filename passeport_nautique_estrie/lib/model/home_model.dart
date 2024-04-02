import 'package:passeport_nautique_estrie/db.dart';

class HomeModel {
  
  Future<List<List<dynamic>>> fetchData(String? sub) async {
    final connection = await DB.getConnection();
    var results = await connection.query(
      "SELECT * from voir_embarcation_utilisateur(@sub)",
      substitutionValues: {"sub": sub},
    );
    await connection.close();
    return results;
  }
}