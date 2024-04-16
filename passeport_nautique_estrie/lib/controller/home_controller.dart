import 'package:passeport_nautique_estrie/model/home_model.dart';

class HomeController {
  final model = HomeModel();

  Future<List<List<dynamic>>> getEmbarcations(String? sub) {
    return model.fetchData(sub);
  }
}