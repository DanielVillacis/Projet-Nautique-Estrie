import 'package:passeport_nautique_estrie/env_config.dart';
import 'package:postgres/postgres.dart';

class DB {
  static Future<PostgreSQLConnection> getConnection() async {
    return await PostgreSQLConnection(
        'ep-divine-dew-a56c72dk.us-east-2.aws.neon.tech/PNE?sslmode=require', 5432, 'PNE',
        username: 'PNE_owner', password: 'mJz7Re5jZVdl');
  }
}
