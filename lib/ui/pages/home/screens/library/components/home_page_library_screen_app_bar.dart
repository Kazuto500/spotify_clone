import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/user_controller.dart';
import 'package:spotify_clone/ui/global/media/image_loader.dart';

class HomePageLibraryScreenAppBar extends StatelessWidget
    implements PreferredSize {
  const HomePageLibraryScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 4,
        right: 12,
        bottom: 4,
        left: 12,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff727272),
              ),
              clipBehavior: Clip.antiAlias,
              child: Consumer<UserController>(
                builder: (context, userController, child) => ImageLoader(
                  imageUrl: userController.currentUser!.avatarUrl,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Your library",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size(double.infinity, 120);
}
