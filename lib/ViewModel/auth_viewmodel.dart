import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Repositeries/auth_repositeries.dart';
import '../model/user_model.dart';
import '../services/firebase_service.dart';

class AuthViewModel with ChangeNotifier {
  User? _user = FirebaseService.firebaseAuth.currentUser;

  User? get user => _user;

  UserModel? _loggedInUser;
  UserModel? get loggedInUser => _loggedInUser;


  Future<void> login(String email, String password) async {
    try {
      await AuthRepository().login(email, password);
      var response = await AuthRepository().login(email, password);
      if (kDebugMode) {
        print(response);
      }
      _user = response.user;
      if (kDebugMode) {
        print("VM  $_user");
      }
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid);
      if (kDebugMode) {
        print("VM  $_loggedInUser");
      }
      notifyListeners();
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      // AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> register(UserModel user) async {
    try {
      var response = await AuthRepository().register(user);
      _user = response!.user;
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid);
      notifyListeners();
    } catch (err) {
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> checkLogin() async {
    try {
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid);
      notifyListeners();
    } catch (err) {
      _user = null;
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await AuthRepository().logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
