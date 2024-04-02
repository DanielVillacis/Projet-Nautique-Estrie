import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passeport_nautique_estrie/db.dart';

class InscriptionModel {
  String? nom;
  String? description;
  String? marque;
  String? modele;
  String? longueur;
  String? selectedBoatType;

  Future<void> saveBoatData() async {
    PostgreSQLConnection conn = await DB.getConnection();
    final prefs = await SharedPreferences.getInstance();
    final sub = prefs.getString('sub');
    await conn.execute(('call creer_embarcation(@description,@marque,@longueur,@nom,@sub)'), substitutionValues: {
      'sub': sub,
      'nom': nom,
      'longueur': int.parse(longueur!),
      'marque': marque,
      'description': description
    });
    DB.closeConnection(conn);
  }
}