
import 'package:flutter/foundation.dart';

class User {
  late String _id;
  String get id => _id;
  late String username = "";
  late String photoUrl = "";

  late bool active;
  late DateTime lastSeen;
  User(
      {
        required String username,
        required String photoUrl,
        required bool active,
        required DateTime lastSeen
      }
      );


  toJson() => {
    'username': username,
    'photoUrl': photoUrl,
    'active': active,
    'last_seen': lastSeen,
  };

  factory User.fromJson(Map<String, dynamic> json){
    final user = User(
      username: json['username'],
      photoUrl: json['photoUrl'],
      active: json['active'],
      lastSeen: json['last_seen']
    );

    user._id = json['id'];
    return user;
  }
}