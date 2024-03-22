import 'package:postgres/postgres.dart';

class DB {
  static Future<Connection> getConnection() async {
    return await Connection.open(Endpoint(
     host: 'ep-divine-dew-a56c72dk.us-east-2.aws.neon.tech',
      port: 5432,
      database: 'PNE',
      username: 'PNE_owner',
      password: 'mJz7Re5jZVdl',
    ));
  }
}