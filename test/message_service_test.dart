import 'package:chat1/src/models/messages.dart';
import 'package:chat1/src/models/user.dart';
import 'package:chat1/src/services/message/message_service_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helpers.dart';

void main(){
  RethinkDb r = RethinkDb();
  Connection connection;
  MessageService sut;

  setUp(() async {
    connection = await r.connect(host: "", port: 28015);
    await createDb(r, connection);
    sut = MessageService(r, connection);
  });

  tearDown(() async {
    sut.dispose();
    await cleanDb(r, connection);
  });

  final user1 = User.fromJson({
    'id': '11111',
    'photoUrl': 'photoUrl',
    'active': true,
    'lastSeen': DateTime.now()
  });

  final user2 = User.fromJson({
    'id': '11112',
    'photoUrl': 'photoUrl',
    'active': true,
    'lastSeen': DateTime.now()
  });

  test('Sent message succesfully', ()async {
    Message message = Message(from: user1, to: user2, timeStap: DateTime.now(), content: "This is a message");
    final res = await sut.send(message);
    final res = await sut.send(message).whenComplete(() => sut.messages(activeUser: user2).listen((expectAsync1((message) => expect(message.to, user2.id) , count: 2))));
    expect(res, true);
  });

}