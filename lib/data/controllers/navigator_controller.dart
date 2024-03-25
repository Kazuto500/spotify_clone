import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:uni_links/uni_links.dart';

class NavigatorController with ChangeNotifier {
  StreamSubscription? deepLinkNavigationListener;

  initDeepLinkListener() {
    deepLinkNavigationListener = linkStream.listen(
      (link) {
        if (link != null) {
          debugPrint("DeepLink uri: $link");

          Uri uri = Uri.parse(link);

          switch (uri.host) {
            case "":
              Navigator.of(Get.context!)
                  .pushNamedAndRemoveUntil("splash", (route) => false);
            case "sign":
              Provider.of<SessionController>(Get.context!, listen: false)
                  .processSignAuthCode(authCode: uri.queryParameters["code"]!);
            default:
              return;
          }
        }
      },
    );
  }
}
