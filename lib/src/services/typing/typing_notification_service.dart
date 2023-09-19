import 'package:chat1/src/models/typing_event.dart';
import 'package:chat1/src/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class ITypingNotification {
  Future<bool> send({required TypingEvent event});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}