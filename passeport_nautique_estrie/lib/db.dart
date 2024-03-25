import 'package:passeport_nautique_estrie/env_config.dart';
import 'package:postgres/postgres.dart';

class DB {
  static Future<PostgreSQLConnection> getConnection() async {
    var conn = PostgreSQLConnection(
        EnvironmentConfig().host ?? '',
        EnvironmentConfig().port ?? 0000,
        EnvironmentConfig().database ?? '',
        username: EnvironmentConfig().username ?? '',
        password: EnvironmentConfig().password ?? '',
        useSSL: true,
      );
      await conn.open();
      return conn;
  }
  static void closeConnection(PostgreSQLConnection conn) async {
   conn.close();
  }
}
