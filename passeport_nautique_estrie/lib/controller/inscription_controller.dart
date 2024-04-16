import 'dart:io';

import 'package:passeport_nautique_estrie/model/inscription_model.dart';

class InscriptionController {
  final model = InscriptionModel();

  void updateBoatData(String? noPermis,String nom, String description, String marque, String modele, String longueur, String selectedBoatType, File image) {
    model.noPermis = noPermis;
    model.nom = nom;
    model.description = description;
    model.marque = marque;
    model.modele = modele;
    model.longueur = longueur;
    model.selectedBoatType = selectedBoatType;
    model.image = image;
    model.saveBoatData();
  }
}