import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/models/dto/shared/vote.dart';

class UserState extends ChangeNotifier {
  UserResponse? _user;
  List<Vote> _votes = List.empty();

  /// An unmodifiable view of the votes in the cart.
  UnmodifiableListView<Vote> get votes => UnmodifiableListView(_votes);

  UserResponse? get user => _user;

  void updateUser(UserResponse newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updateVotes(List<Vote> newVotes) {
    _votes = newVotes;
    notifyListeners();
  }
}
