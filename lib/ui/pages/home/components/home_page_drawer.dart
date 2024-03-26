import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/data/controllers/user_controller.dart';
import 'package:spotify_clone/ui/global/buttons/secondary_button.dart';
import 'package:spotify_clone/ui/global/media/image_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.5,
      child: Material(
        color: const Color(0xff2a2a2a),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8,
            right: 8,
            bottom: 64,
            left: 8,
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Consumer<UserController>(
                    builder: (context, userController, child) {
                      return GestureDetector(
                        onTap: () {
                          launchUrl(
                            Uri.parse(
                              userController.currentUser!.spotifyUri,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff727272),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Consumer<UserController>(
                                    builder: (context, userController, child) =>
                                        ImageLoader(
                                            imageUrl: userController
                                                .currentUser!.avatarUrl),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  " ${userController.currentUser!.displayName}",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SessionController>(
                  builder: (context, sessionController, child) =>
                      SecondaryButton(
                    icon: const Icon(Icons.exit_to_app_rounded),
                    onPressed: () {
                      sessionController.signOut();
                    },
                    label: "Logout",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
