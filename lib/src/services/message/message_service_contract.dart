import 'package:chat1/src/models/messages.dart';
import 'package:flutter/cupertino.dart';

import '../../models/user.dart';

abstract class IMessageService{
  Future<Message> send(Message message);
  Stream<Message> messages({required User activeUser});
  dispose();
}