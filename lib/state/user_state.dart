import 'package:flutter/cupertino.dart';
import 'package:jui/models/dto/response/user/user.dart';

class UserState extends ChangeNotifier {
  UserResponse? _user;

  UserResponse? get user => _user;

  void updateUser(UserResponse newUser) {
    _user = newUser;
    notifyListeners();
  }
}
