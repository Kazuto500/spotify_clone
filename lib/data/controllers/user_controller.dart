import 'package:flutter/material.dart';
import 'package:spotify_clone/data/api/api_spotify.dart';
import 'package:spotify_clone/data/models/user_model.dart';

class UserController extends Api with ChangeNotifier {
  UserModel? _currentUser;

  get currentUser => _currentUser;

  initUser({
    required String token,
    required Function onSuccess,
  }) {
    _getCurrentUser(
      token: token,
      onSuccess: (data) {
        _setCurrentUser(data: data);
        onSuccess();
      },
    );
  }

  _getCurrentUser({
    required String token,
    required Function(Map<String, dynamic> data) onSuccess,
  }) {
    getQuery(
      route: Api.getUserRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      onSuccess: (data) {
        onSuccess(data);
      },
    );
  }

  _setCurrentUser({required Map<String, dynamic> data}) {
    _currentUser = UserModel.fromJson(data: data);
    notifyListeners();
  }
}
