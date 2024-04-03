import 'package:passeport_nautique_estrie/model/embarcation_model.dart';

class EmbarcationController {
  final EmbarcationModel model;

  EmbarcationController(String embarcationUtilisateur)
      : model = EmbarcationModel(embarcationUtilisateur);

  Future<void> fetchDetails() async {
    await model.fetchDetailsEmbarcations();
  }
}