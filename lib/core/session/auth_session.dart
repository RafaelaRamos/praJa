import 'package:flutter/foundation.dart';

import '../../features/auth/domain/entities/user.dart';

class AuthSession extends ChangeNotifier {
  User? user;
  bool isLoading = true;

  void setUser(User? value) {
    user = value;
    isLoading = false;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
