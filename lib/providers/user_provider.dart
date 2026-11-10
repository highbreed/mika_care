import '../modals/user_modal.dart';
import 'package:flutter/material.dart';


class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  String? get role => _user!.role[0].name;

  // bool get isLoggedIn => _user != null;

  bool hasRole(String role) {
    return _user?.role == role;
  }
  bool isLoggedIn() {
    if(_user != null){
      return true;
    }
    return false;
  }
  void login(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() async {
    _user = null;
    notifyListeners();
  }
  
  void clearSession() {
    _user = null;
  }

  bool hasRoleName(String roleName) {
    return _user!.role[0].name == roleName;
  }

  bool hasPermission(String permission) {
    bool hasPermission = false;

    for (var element in _user!.role) {
      for (var i = 0; i < element.permissions.length; i++) {
        if (element.permissions[i].name == permission) {
          hasPermission = true;
          break;
        }
      }
    }
  
    return hasPermission;
  }

}
