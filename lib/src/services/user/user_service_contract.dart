import 'package:chat1/src/models/user.dart';

import '../../models/typing_event.dart';

abstract class IUserService {
  Future<User> connect(User user);
  Future<List<User>> online();
  Future<void> disconnect(User user);
  Future<User> fetch(String id);
}