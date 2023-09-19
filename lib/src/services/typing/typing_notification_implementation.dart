import 'dart:async';

import 'package:chat1/src/models/typing_event.dart';
import 'package:chat1/src/models/user.dart';
import 'package:chat1/src/services/typing/typing_notification_service.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import '../user/user_service_contract.dart';

class TypingNotification implements ITypingNotification{

  late final Connection _connection;
  final RethinkDb _r;
  final _controller = StreamController<TypingEvent>.broadcast();

  late StreamSubscription _changeFeed;

  IUserService _userService;

  TypingNotification(this._r, this._connection,this._userService);


  @override
  Future<bool> send({required TypingEvent event}) async {

    final receiver = await _userService.fetch(event.to);
    if (!receiver.active){
      return false;
    }

    Map record = await _r.table('typing_events').insert(event.toJson(), {'conflict':'update'}).run(_connection);
    return record['inserted'] == 1;

  }

  void _startReceivingReceipts(User activeUser, List<String> userIds) {
    _changeFeed = _r.
    table('typing_events').
    filter((event) {
      return event('to').eq(activeUser.id).and(_r.expr(userIds).contains(event('from')));
    }).
    changes({'include_initial': true}).
    run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
      event.forEach((feedData) {

        if (feedData['new_val'] != null){
          final receipt = _receiptFromFeed(feedData);
          _controller.sink.add(receipt);

        }

      })
          .catchError((err) => print(err))
          .onError((error, stacktrace) => print(error));
    });
  }

  TypingEvent _receiptFromFeed(feedData){

    var data = feedData['new_val'];
    return TypingEvent.fromJson(data);
  }

  _removeDeliveredReceipt(TypingEvent message){
    _r.table('typing_events').get(message.id).delete({'return_changes' : false}).run(_connection);
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String> userIds) {
    _startReceivingReceipts(user, userIds);
    return _controller.stream;
  }

  @override
  void dispose() {
    _changeFeed?.cancel();
    _controller?.close();
  }

}