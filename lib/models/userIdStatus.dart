import 'package:flutter/foundation.dart';

class UserIdStatus with ChangeNotifier {
  bool haveUserId = false;
  void chngUIdStatus(bool status) {
    if (status) {
      haveUserId = true;
    } else {
      haveUserId = false;
    }
    notifyListeners();
  }
}
