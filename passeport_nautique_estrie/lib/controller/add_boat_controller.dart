import 'package:passeport_nautique_estrie/model/add_boat_model.dart';

class AddBoatController {
  final model = AddBoatModel();

  void updatePermitNumber(String number) {
    model.setPermitNumber(number);
  }

  String? getPermitNumber() {
    return model.getPermitNumber();
  }
}