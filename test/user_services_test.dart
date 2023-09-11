import 'package:chat1/src/models/user.dart';
import 'package:chat1/src/services/user/user_service_contract.dart';
import 'package:chat1/src/services/user/user_service_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helpers.dart';

void main(){
  RethinkDb r = new RethinkDb();
  Connection connection;
  UserService sub;

  setUp(() async {
    connection = await r.connect(host: "", port: 28015);
    await createDb(r, connection);
    sub = UserService(r,connection);
  });

  tearDown(() async {
    await cleanDb(r, connection);
  });

  test('Creates a new user document in database', () async {

    final user = User(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastSeen: DateTime.now()
    );
    final userWithId = await sub.connect(user);
    expect(userWithId.id, isNotEmpty);
  });

  test('Get online users', () async {

    final user = User(
        username: 'test',
        photoUrl: 'url',
        active: true,
        lastSeen: DateTime.now()
    );

    await sub.connect(user);
    final users = await sub.online();
    expect(users.length, 1);

  });

}