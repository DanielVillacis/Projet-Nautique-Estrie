import 'package:passeport_nautique_estrie/model/inscription_model.dart';

class InscriptionController {
  final model = InscriptionModel();

  void updateBoatData(String nom, String description, String marque, String modele, String longueur, String selectedBoatType) {
    model.nom = nom;
    model.description = description;
    model.marque = marque;
    model.modele = modele;
    model.longueur = longueur;
    model.selectedBoatType = selectedBoatType;
    model.saveBoatData();
  }
}