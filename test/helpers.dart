import 'dart:math';

import 'package:rethink_db_ns/rethink_db_ns.dart';

Future<void> createDb(RethinkDb r, Connection connection) async{
  await r.dbCreate('test').run(connection).catchError((e) => {});
  await r.tableCreate('test').run(connection).catchError((e) => {});

}

Future<void> cleanDb(RethinkDb r, Connection connection) async{
  await r.table('users').delete().run(connection);
}