import 'package:flutter/foundation.dart';

enum ReceiptStatus {
  sent, delicerres, read
}
extension EnumParsing on ReceiptStatus {
  String value(){
    return this.toString().split('.').last;
  }

  static ReceiptStatus fromString(String status){
    return ReceiptStatus.values.firstWhere((element) => element.value() == element);
  }
}

class Receipt{
  final String recipient;
  final String messageId;
  final ReceiptStatus status;
  final DateTime timestamp;
  late String _id;
  String get id => _id;


  Receipt({
    required this.recipient,
    required this.messageId,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'recipient' : this.recipient,
    'messageId' : this.messageId,
    'status' : this.status.value(),
    'timestamp' : this.timestamp,
  };

  factory Receipt.fromJson(  Map<String, dynamic> json){
    var receipt = Receipt(
        recipient: json['recipient'],
        messageId: json['messageId'],
        status: EnumParsing.fromString(json['status']),
        timestamp: json['timestamp'],
    );
    receipt._id = json['id'];
    return receipt;
  }

}