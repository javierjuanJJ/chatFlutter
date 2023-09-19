import 'dart:async';

import 'package:chat1/src/models/messages.dart';
import 'package:chat1/src/models/user.dart';
import 'package:chat1/src/services/encryption/encryption_contract.dart';
import 'package:chat1/src/services/message/message_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class MessageService implements IMessageService{

  late final Connection _connection;
  final RethinkDb r;
  final IEncryption _encryption;
  final _controller = StreamController<Message>.broadcast();



  MessageService(this.r, this._connection, this._encryption);

  late StreamSubscription _changeFeed;

  @override
  dispose() {
    _controller?.close();
    _changeFeed?.cancel();
  }

  @override
  Stream<Message> messages({required User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<Message> send(Message message) async {

    var data = message.toJson();
    data['contents'] = _encryption.encryption(message.content);


    Map record = await r.table('messages').insert(data, {'return_changes' : true}).run(_connection);
    return Message.fromJson(record['changes'].first['new_val']);
  }

  void _startReceivingMessages(User activeUser) {
    _changeFeed = r.table('messages').filter({'to': activeUser.id}).changes({'include_initial': true}).run(_connection).asStream().cast<Feed>().listen((event) {
      event.forEach((feedData) {

        if (feedData['new_val'] != null){
          final message = _messageFromFeed(feedData);
          _controller.sink.add(message);
          _removeDeliveredMessage(message);
        }

      })
          .catchError((err) => print(err))
          .onError((error, stacktrace) => print(error));
    });
  }

  Message _messageFromFeed(feedData){

    var data = feedData['new_val'];
    data['contents'] = _encryption.decrypt(data['contents']);
    return Message.fromJson(data);
  }

  _removeDeliveredMessage(Message message){
    r.table('messages').get(message.id).delete({'return_changes' : false}).run(_connection);
  }


}