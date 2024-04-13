import 'package:flutter/material.dart';
import 'package:passeport_nautique_estrie/view/pages/Share_boat.dart';
import 'package:passeport_nautique_estrie/view/pages/embarcation.dart';

class PopupMenuUtil {
  static void showPopupMenu(
      BuildContext context, String embarcationUtilisateur, int index) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox itemBox = context.findRenderObject() as RenderBox;
    final Offset position = itemBox.localToGlobal(Offset.zero);

    final List<String> options = [
      'Enregistrer un lavage',
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
      if (selected == 'Enregistrer un lavage') {
        // Navigate to the QRScanPage for scanning QR code
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AddLavagePage()),
        // );
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
}
