import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Api {
  static String? clientId = '9d53c19ed67e4627be1464279a79a8a9';
  static String? clientSecret = '73e2b167aa034c9187ad4c1ad0fd0bd9';

  static const String authDomain = "accounts.spotify.com";
  static const String authRedirectUri = "spotifyclone://sign";
  static const String scope =
      "user-read-private user-read-email user-library-read user-library-modify user-follow-read user-follow-modify user-top-read user-read-recently-played playlist-read-private playlist-modify-public playlist-modify-private";

  static Map<String, String> basicAuthScheme = {
    "content-type": "application/x-www-form-urlencoded",
    "Authorization": "Basic ${base64Encode(
      utf8.encode('$clientId:$clientSecret'),
    )}",
  };

  static Map<String, String> refreshAuthScheme = {
    "Content-Type": "application/x-www-form-urlencoded"
  };

  static const String _apiDomain = "api.spotify.com";

  static const String getTokenRoute = "/api/token";
  static const String refreshTokenRoute = "/api/token";

  static const String getUserRoute = "/v1/me";

  static const String getSeedGenresRoute =
      "/v1/recommendations/available-genre-seeds";
  static const String getRecommendationsRoute = "/v1/recommendations";

  static const String searchMediaRoute = "/v1/search";

  static const String userFavoriteTracksRoute = "/v1/me/tracks";
  static const String userFavoriteArtistsRoute = "/v1/me/following";
  static const String userFavoriteAlbumsRoute = "/v1/me/albums";

  static const String checkFavoriteTrackRoute = "/v1/me/tracks/contains";
  static const String checkFavoriteArtistRoute = "v1/me/following/contains";
  static const String checkFavoriteAlbumRoute = "/v1/me/albums/contains";

  showProcessingDialog() {
    showDialog(
      context: Get.context!,
      barrierColor:
          Theme.of(Get.context!).scaffoldBackgroundColor.withOpacity(0.75),
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  closeProcessingDialog() {
    Navigator.of(Get.context!).pop();
  }

  showErrorPage() {
    Navigator.of(Get.context!)
        .pushNamedAndRemoveUntil("error", (route) => false);
  }

  Map<String, dynamic> _dataParser({required String body}) {
    Map<String, dynamic> data = {};

    if (body.isNotEmpty) {
      dynamic fetchedData = jsonDecode(body);

      if (fetchedData is Map<String, dynamic>) {
        data = fetchedData;
      } else {
        data = {"response": fetchedData};
      }
    } else {
      data = {"response": "Empty or null response "};
    }

    return data;
  }

  putQuery({
    String? domain,
    required String route,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Function? onStart,
    required Function(Map<String, dynamic> data) onSuccess,
    Function? onComplete,
  }) async {
    debugPrint("Post Route: $route");
    debugPrint("Params: $params");
    debugPrint("Headers: $headers");

    try {
      onStart?.call();

      await http
          .put(
        Uri.https(domain ?? _apiDomain, route, params),
        headers: headers,
      )
          .then(
        (response) async {
          debugPrint("Post '$route' response status: ${response.statusCode}");
          debugPrint("Post '$route' response: ${response.body}");

          if (response.statusCode == 200 || response.statusCode == 204) {
            onSuccess(
                _dataParser(body: response.body.isEmpty ? "" : response.body));
          } else {
            showErrorPage();
          }
        },
      ).whenComplete(
        () {
          onComplete?.call();
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showErrorPage();
    }
  }

  getQuery({
    String? domain,
    required String route,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Function? onStart,
    required Function(Map<String, dynamic> data) onSuccess,
    Function? onComplete,
  }) async {
    debugPrint("Get Route: $route");
    debugPrint("Params: $params");
    debugPrint("Headers: $headers");

    try {
      onStart?.call();

      await http
          .get(
        Uri.https(domain ?? _apiDomain, route, params),
        headers: headers,
      )
          .then(
        (response) async {
          debugPrint("Get '$route' response status: ${response.statusCode}");
          debugPrint("Get '$route' response: ${response.body}");

          if (response.statusCode == 200 || response.statusCode == 204) {
            onSuccess(
                _dataParser(body: response.body.isEmpty ? "" : response.body));
          } else {
            showErrorPage();
          }
        },
      ).whenComplete(
        () {
          onComplete?.call();
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showErrorPage();
    }
  }

  postQuery({
    String? domain,
    required String route,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Function? onStart,
    required Function(Map<String, dynamic> data) onSuccess,
    Function? onComplete,
  }) async {
    debugPrint("Post Route: $route");
    debugPrint("Params: $params");
    debugPrint("Headers: $headers");

    try {
      onStart?.call();

      await http
          .post(
        Uri.https(domain ?? _apiDomain, route, params),
        headers: headers,
      )
          .then(
        (response) async {
          debugPrint("Post '$route' response status: ${response.statusCode}");
          debugPrint("Post '$route' response: ${response.body}");

          if (response.statusCode == 200 || response.statusCode == 204) {
            onSuccess(
                _dataParser(body: response.body.isEmpty ? "" : response.body));
          } else {
            showErrorPage();
          }
        },
      ).whenComplete(
        () {
          onComplete?.call();
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showErrorPage();
    }
  }

  deleteQuery({
    String? domain,
    required String route,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Function? onStart,
    required Function(Map<String, dynamic> data) onSuccess,
    Function? onComplete,
  }) async {
    debugPrint("Delete Route: $route");
    debugPrint("Params: $params");
    debugPrint("Headers: $headers");

    try {
      onStart?.call();

      await http
          .delete(
        Uri.https(domain ?? _apiDomain, route, params),
        headers: headers,
      )
          .then(
        (response) async {
          debugPrint("Delete '$route' response status: ${response.statusCode}");
          debugPrint("Delete '$route' response: ${response.body}");

          if (response.statusCode == 200 || response.statusCode == 204) {
            onSuccess(
                _dataParser(body: response.body.isEmpty ? "" : response.body));
          } else {
            showErrorPage();
          }
        },
      ).whenComplete(
        () {
          onComplete?.call();
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showErrorPage();
    }
  }
}
