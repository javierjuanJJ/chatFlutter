import 'dart:math';

import 'package:rethink_db_ns/rethink_db_ns.dart';

Future<void> createDb(RethinkDb r, Connection connection) async{
  await r.dbCreate('test').run(connection).catchError((e) => {});
  await r.tableCreate('users').run(connection).catchError((e) => {});
  await r.tableCreate('messages').run(connection).catchError((e) => {});

}

Future<void> cleanDb(RethinkDb r, Connection connection) async{
  await r.table('users').delete().run(connection);
  await r.table('messages').delete().run(connection);
}