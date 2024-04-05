import 'dart:io';

import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passeport_nautique_estrie/db.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class InscriptionModel {
  String? noPermis;
  String? nom;
  String? description;
  String? marque;
  String? modele;
  String? longueur;
  String? selectedBoatType;
  File? image;

  Future<void> saveBoatData() async {
    PostgreSQLConnection conn = await DB.getConnection();
    final prefs = await SharedPreferences.getInstance();
    final sub = prefs.getString('sub');
    if(noPermis.isBlank!){
      await conn.execute(('call creer_embarcation(@description,@marque,@longueur,@nom,@sub,@photo)'), substitutionValues: {
      'sub': sub,
      'nom': nom,
      'longueur': int.parse(longueur!),
      'marque': marque,
      'description': description,
      'photo': image!.path,
    });
    try{
      await firebase_storage.FirebaseStorage.instance.ref('embarcationImages/${image!.path}').putFile(image!);

    } on firebase_core.FirebaseException catch (e){
      print(e);
    }

    DB.closeConnection(conn);
    }else{
      await conn.execute(('call creer_embarcation_permis(@noPermis,@description,@marque,@longueur,@nom,@sub,@photo)'), substitutionValues: {
      'noPermis': noPermis,
      'sub': sub,
      'nom': nom,
      'longueur': int.parse(longueur!),
      'marque': marque,
      'description': description,
      'photo': image!.path,
    });
    }
    
  }
}