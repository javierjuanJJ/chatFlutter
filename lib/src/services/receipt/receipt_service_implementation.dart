import 'dart:async';

import 'package:chat1/src/models/receipt.dart';
import 'package:chat1/src/models/user.dart';
import 'package:chat1/src/services/receipt/receipt_service_contract.dart';
import 'package:chat1/src/models/messages.dart';
import 'package:chat1/src/models/user.dart';
import 'package:chat1/src/services/encryption/encryption_contract.dart';
import 'package:chat1/src/services/message/message_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
class ReceiptService implements IReceiptService{

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }

  late final Connection _connection;
  final RethinkDb r;
  final IEncryption _encryption;
  final _controller = StreamController<Receipt>.broadcast();



  ReceiptService(this.r, this._connection, this._encryption);

  late StreamSubscription _changeFeed;

  @override
  dispose() {
    _controller?.close();
    _changeFeed?.cancel();
  }

  @override
  Stream<Receipt> messages({required User activeUser}) {
    _startReceivingReceipts(activeUser);
    return _controller.stream;
  }

  @override
  Future<bool> send(Receipt message) async {

    var data = message.toJson();

    Map record = await r.table('receipts').insert(data).run(_connection);
    return record['inserted'] == 1;
  }

  void _startReceivingReceipts(User activeUser) {
    _changeFeed = r.table('receipts').filter({'recipient': activeUser.id}).changes({'include_initial': true}).run(_connection).asStream().cast<Feed>().listen((event) {
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

  Receipt _receiptFromFeed(feedData){

    var data = feedData['new_val'];
    return Receipt.fromJson(data);
  }

  _removeDeliveredReceipt(Receipt message){
    r.table('receipts').get(message.id).delete({'return_changes' : false}).run(_connection);
  }


}