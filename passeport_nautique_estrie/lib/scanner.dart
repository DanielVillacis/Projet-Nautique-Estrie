import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeUtils {
  static Future<void> scanQR(BuildContext context,
      String embarcationUtilisateur, Function(String) onSuccess) async {
    String barcodeScanRes;
    Map<String, dynamic> qrText = {};
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      qrText = json.decode(barcodeScanRes);
      if (qrText["type"] == "lavage") {
        await addLavageToEmbarcation(embarcationUtilisateur, qrText);
        onSuccess('Lavage bien enregistré');
      }
      if (qrText["type"] == "mise à l'eau") {
        await addMiseAEauToEmbarcation(embarcationUtilisateur, qrText);
        onSuccess('Mise à l\'eau bien enregistré');
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  static Future<List<List<dynamic>>> addLavageToEmbarcation(
      String enbarcationUtilisateur, Map lavageFait) async {
    final prefs = await SharedPreferences.getInstance();
    final connection = await DB.getConnection();
    var results = await connection.query(
      "SELECT * from add_lavage_no_remove(@type_lavage,@id_embarcation_utilisateur,@code,@self_serve)",
      substitutionValues: {
        "type_lavage": lavageFait["type lavage"],
        "id_embarcation_utilisateur": enbarcationUtilisateur,
        "code": lavageFait["code unique"],
        "self_serve": lavageFait["self_serve"]
      },
    );
    DB.closeConnection(connection);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    await prefs.setString(
        'lastLavage${results[0][0]}', dateFormat.format(DateTime.now()));
    return results;
  }

  static Future<List<List<dynamic>>> addMiseAEauToEmbarcation(
      String enbarcationUtilisateur, Map MiseEauFait) async {
    final prefs = await SharedPreferences.getInstance();
    final connection = await DB.getConnection();
    var results = await connection.query(
      "SELECT * from add_mise_eau_no_remove(@p_planEau,@id_embarcation_utilisateur,@code)",
      substitutionValues: {
        "p_planEau": MiseEauFait["plan eau"],
        "id_embarcation_utilisateur": enbarcationUtilisateur,
        "code": MiseEauFait["code unique"],
      },
    );
    DB.closeConnection(connection);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    await prefs.setString(
        'lastMiseEau${results[0][0]}', dateFormat.format(DateTime.now()));
    return results;
  }
}
