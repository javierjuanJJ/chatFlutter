import 'package:flutter/foundation.dart';

extension TypingParsing on Typing {
  String value(){
    return this.toString().split('.').last;
  }

  static Typing fromString(String status){
    return Typing.values.firstWhere((element) => element.value() == element);
  }
}

enum Typing{
  start,stop
}
class TypingEvent{
  final String from;
  final String to;
  final Typing event;
  late String _id;
  String get id => _id;

  TypingEvent({
    required this.from,
    required this.to,
    required this.event,
  });

  Map<String, dynamic> toJson() => {
    'from' : this.from,
    'to' : this.to,
    'event' : this.event.value(),
  };

  factory TypingEvent.fromJson(  Map<String, dynamic> json){
    var receipt = TypingEvent(
      from: json['from'],
      to: json['to'],
      event: TypingParsing.fromString(json['event']),
    );
    receipt._id = json['id'];
    return receipt;
  }

}