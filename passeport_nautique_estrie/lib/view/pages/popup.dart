import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'package:passeport_nautique_estrie/scanner.dart';
import 'package:passeport_nautique_estrie/view/pages/Share_boat.dart';
import 'package:passeport_nautique_estrie/view/pages/embarcation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupMenuUtil {
  static void showPopupMenu(
      BuildContext context, String embarcationUtilisateur, int index) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox itemBox = context.findRenderObject() as RenderBox;
    final Offset position = itemBox.localToGlobal(Offset.zero);

    final List<String> options = [
      'Enregistrer un lavage ou une mise à l\'eau',
      'Voir l\'embarcation',
      'Prêter cette embarcation'
    ];

    final String? selected = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          position,
          position.translate(itemBox.size.width, itemBox.size.height),
        ),
        Offset.zero & overlay.size,
      ),
      items: options.map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );

    if (selected != null) {
      // Handle the selected option here
      if (selected == 'Enregistrer un lavage ou une mise à l\'eau') {
        // Call the scanQR method directly
        BarcodeUtils.scanQR(context, embarcationUtilisateur, (message) {
          showSuccessMessage(context, message);
        });
      } else if (selected == 'Voir l\'embarcation') {
        // Navigate to DetailsEmbarcationPage to view the details of the boat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsEmbarcation(
              embarcationUtilisateur: embarcationUtilisateur,
            ),
          ),
        );
      } else if (selected == 'Prêter cette embarcation') {
        // Navigate to the ShareEmbarcationPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShareBoat(embarcationUtilisateur),
          ),
        );
      }
    }
  }

  // static Future<void> scanQR(BuildContext context,
  //     String embarcationUtilisateur, Function(String) onSuccess) async {
  //   String barcodeScanRes;
  //   Map<String, dynamic> qrText = {};
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.QR);
  //     qrText = json.decode(barcodeScanRes);
  //     if (qrText["type"] == "lavage") {
  //       await addLavageToEmbarcation(embarcationUtilisateur, qrText);
        
  //     }
  //     if (qrText["type"] == "mise à l'eau") {
  //       await addMiseAEauToEmbarcation(embarcationUtilisateur, qrText);
  //       onSuccess('Mise à l\'eau bien enregistré');
  //     }

  //     // After adding the lavage, show a success message
      
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  // }

  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Adjust the duration as needed
    ));
  }

  // static Future<List<List<dynamic>>> addLavageToEmbarcation(
  //     String enbarcationUtilisateur, Map lavageFait) async {
  //   final connection = await DB.getConnection();
  //   var results = await connection.query(
  //     "SELECT * from add_lavage_no_remove(@type_lavage,@id_embarcation_utilisateur,@code,@self_serve)",
  //     substitutionValues: {
  //       "type_lavage": lavageFait["type lavage"],
  //       "id_embarcation_utilisateur": enbarcationUtilisateur,
  //       "code": lavageFait["code unique"],
  //       "self_serve": lavageFait["self_serve"]
  //     },
  //   );
  //   DB.closeConnection(connection);
  //   String idEmbarcation = results[0][0] as String;
  //   final prefs = await SharedPreferences.getInstance();
  //   DateFormat dateformat = DateFormat('yyyy-MM-dd HH:mm');
  //   DateTime now = DateTime.now().toLocal();

  //   await prefs.setStringList(
  //       'lastLavage$idEmbarcation', [idEmbarcation, dateformat.format(now)]);

  //   return results;
  // }

  // static Future<List<List<dynamic>>> addMiseAEauToEmbarcation(
  //     String enbarcationUtilisateur, Map MiseEauFait) async {
  //   final connection = await DB.getConnection();
  //   var results = await connection.query(
  //     "SELECT * from add_mise_eau_no_remove(@p_planEau,@id_embarcation_utilisateur,@code)",
  //     substitutionValues: {
  //       "p_planEau": MiseEauFait["plan eau"],
  //       "id_embarcation_utilisateur": enbarcationUtilisateur,
  //       "code": MiseEauFait["code unique"],
  //     },
  //   );
  //   DB.closeConnection(connection);
  //   String idEmbarcation = results[0][0] as String;
  //   final prefs = await SharedPreferences.getInstance();
  //   DateFormat dateformat = DateFormat('yyyy-MM-dd HH:mm');
  //   DateTime now = DateTime.now().toLocal();

  //   await prefs.setStringList(
  //       'lastMiseEau$idEmbarcation', [idEmbarcation, dateformat.format(now)]);

  //   return results;
  // }
}
