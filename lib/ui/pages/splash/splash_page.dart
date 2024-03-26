import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/navigator_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/data/controllers/user_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  bool launchRequested = false;

  @override
  Widget build(BuildContext context) {
    return Consumer3<NavigatorController, SessionController, UserController>(
      builder: (context, navigationController, sessionController,
          userController, child) {
        if (!launchRequested) {
          launchRequested = true;
          navigationController.initDeepLinkListener();
          sessionController.launchApp(
            onSuccess: () {
              userController.initUser(
                token: sessionController.token,
                onSuccess: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("home", (route) => false);
                },
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: SvgPicture.asset(
              "lib/assets/svg/common/spotify_icon_fill.svg",
              width: 160,
            ),
          ),
        );
      },
    );
  }
}
