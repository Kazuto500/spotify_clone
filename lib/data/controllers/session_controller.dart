import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/data/api/api_spotify.dart';
import 'package:url_launcher/url_launcher.dart';

class SessionController extends Api with ChangeNotifier {
  late SharedPreferences storageManager;

  String? _language;
  DateTime? _lastTokenTime;
  String? _token;
  String? _refreshToken;

  String get language => _language!.toUpperCase();
  String get token => _token!;

  Future initStorageManager() async {
    storageManager = await SharedPreferences.getInstance();
  }

  _getAppValues() {
    _language = storageManager.getString("language");

    String? lastTokenTime = storageManager.getString("last_token_time");

    if (lastTokenTime != null) {
      _lastTokenTime = DateTime.parse(lastTokenTime);
    }

    _token = storageManager.getString("token");
    _refreshToken = storageManager.getString("refresh_token");

    notifyListeners();
  }

  launchApp({
    required Function onSuccess,
  }) async {
    await initStorageManager().then(
      (_) async {
        _getAppValues();

        if (_language == null) {
          _setLanguage(languageCode: Platform.localeName.split("_").first);
        }

        if (_lastTokenTime == null || _token == null || _refreshToken == null) {
          Navigator.of(Get.context!).pushNamedAndRemoveUntil(
            "login",
            (route) => false,
          );
        } else {
          if (DateTime.now().difference(_lastTokenTime!).inMinutes > 50) {
            signIn();
          } else {
            await _refreshTokensNow(
              onSuccess: () {
                _periodicRefreshTokens();
              },
            ).then(
              (value) {
                onSuccess();
              },
            );
          }
        }
      },
    );
  }

  signIn() {
    Uri authorizationUrl = Uri.parse(
      "https://${Api.authDomain}/authorize?client_id=${Api.clientId}&response_type=code&redirect_uri=${Api.redirectUri}&scope=${Api.scope}",
    );

    launchUrl(
      authorizationUrl,
      mode: LaunchMode.externalApplication,
    );
  }

  processSignAuthCode({
    required String authCode,
  }) {
    postQuery(
      domain: Api.authDomain,
      route: Api.getTokenRoute,
      headers: Api.basicAuthScheme,
      parameters: {
        "code": authCode,
        "redirect_uri": Api.redirectUri,
        "grant_type": "authorization_code",
      },
      onStart: () {
        showProcessingDialog();
      },
      onSuccess: (data) async {
        await _setTokens(
          token: data["access_token"],
          refreshToken: data["refresh_token"],
        ).then((_) {
          Navigator.of(Get.context!)
              .pushNamedAndRemoveUntil("splash", (route) => false);
        });
      },
    );
  }

  _setLanguage({required String languageCode}) async {
    await storageManager.setString("language", languageCode);
    _language = languageCode;
    notifyListeners();
  }

  Future _setTokens({
    required String token,
    required String refreshToken,
  }) async {
    await storageManager.setString(
        "last_token_time", DateTime.now().toString());
    await storageManager.setString("token", token);
    await storageManager.setString("refresh_token", refreshToken);
  }

  Future _removeTokens() async {
    await storageManager.remove("last_token_time");
    await storageManager.remove("token");
    await storageManager.remove("refresh_token");
  }

  _periodicRefreshTokens() {
    Timer.periodic(
      const Duration(minutes: 50),
      (timer) => _refreshTokensNow(
        onSuccess: () {},
      ),
    );
  }

  Future _refreshTokensNow({required Function onSuccess}) async {
    postQuery(
      domain: Api.authDomain,
      route: Api.refreshTokenRoute,
      headers: Api.basicAuthScheme,
      parameters: {
        "grant_type": 'refresh_token',
        "refresh_token": _refreshToken,
      },
      onSuccess: (data) {
        _setTokens(
          token: data["access_token"],
          refreshToken: _refreshToken!,
        );
        onSuccess();
      },
    );
  }

  signOut() {
    _removeTokens().then(
      (value) => Navigator.of(Get.context!)
          .pushNamedAndRemoveUntil("splash", (route) => false),
    );
  }
}
