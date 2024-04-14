import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:passeport_nautique_estrie/db.dart';
import 'dart:convert';

import 'package:passeport_nautique_estrie/view/pages/home.dart';

class AddLavagePage extends StatefulWidget {
  final String embarcationUtilisateur;
  const AddLavagePage({super.key, required this.embarcationUtilisateur});

  @override
  _AddLavagePageState createState() => _AddLavagePageState();
}

class _AddLavagePageState extends State<AddLavagePage> {
  String _scanBarcode = 'Unknown';
  Map<String, dynamic> lavage = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      lavage = json.decode(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePage().appBar(context),
      resizeToAvoidBottomInset: true,
      body: QRScanBoddy(context),
    );
  }

  @override
  Widget QRScanBoddy(BuildContext context) {
    return Center(
        child: Container(
            alignment: Alignment.center,
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await scanQR();
                      await addLavageToEmbarcation(
                          widget.embarcationUtilisateur, lavage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF18848C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Scanner un code de lavage',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ])));
  }

  Future<List<List<dynamic>>> addLavageToEmbarcation(String enbarcationUtilisateur, Map lavageFait) async {
    final connection = await DB.getConnection();
    var results = await connection.query(
      "SELECT * from add_lavage_no_remove(@type_lavage,@id_embarcation_utilisateur,@code,@self_serve)",
      substitutionValues: {
        "type_lavage": lavage["type lavage"],
        "id_embarcation_utilisateur": enbarcationUtilisateur,
        "code": lavage["code unique"],
        "self_serve": lavage["self_serve"]
      },
    );
    print(results);
    await connection.close();
    return results;
  }
}
