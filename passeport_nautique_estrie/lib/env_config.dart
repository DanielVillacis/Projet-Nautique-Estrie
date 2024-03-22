import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  final domain = dotenv.env['DOMAIN'];
  final clientId = dotenv.env['CLIENT_ID'];
  final host = dotenv.env['HOST'];
  final int? port = int.parse(dotenv.env['PORT']??'');
  final database = dotenv.env['DATABASE'];
  final username = dotenv.env['USERNAME'];
  final password = dotenv.env['PASSWORD'];

}