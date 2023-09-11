import 'package:flutter/foundation.dart';
class Message {
  String get id => _id;
  final String from;
  final String to;
  final DateTime timeStap;
  final String content;
  late String _id;


  Message({
    required this.from,
    required this.to,
    required this.timeStap,
    required this.content,
  });

  toJson() => {
    'from' : this.from,
    'to' : this.to,
    'timeStap' : this.timeStap,
    'content' : this.content,
  };

  factory Message.fromJson(Map<String,dynamic> json){
    var message = Message(
      from : json['from'],
      to : json['to'],
      timeStap : json['timeStap'],
      content : json['content'],
    );

    message._id = json['id'];
    return message;
  }

}