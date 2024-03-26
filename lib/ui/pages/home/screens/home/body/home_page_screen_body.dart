import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/recommendations_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/data/controllers/user_controller.dart';
import 'package:spotify_clone/ui/global/animations/loader_animation.dart';
import 'package:spotify_clone/ui/global/media/image_loader.dart';
import 'package:spotify_clone/ui/pages/home/screens/home/body/sections/recommended_albums_section.dart';
import 'package:spotify_clone/ui/pages/home/screens/home/body/sections/recommended_tracks_section.dart';

class HomePageHomeScreenBody extends StatefulWidget {
  const HomePageHomeScreenBody({super.key});

  @override
  State<HomePageHomeScreenBody> createState() => _HomePageHomeScreenBodyState();
}

class _HomePageHomeScreenBodyState extends State<HomePageHomeScreenBody> {
  bool initialized = false;
  bool hasFavoritesContent = false;
  bool hasRecommendationsContent = false;

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, FavoritesController,
        RecommendationsController>(
      builder: (context, sessionController, favoritesController,
          recommendationsController, child) {
        if (!favoritesController.favoritesInitialized) {
          favoritesController.initFavorites(
            token: sessionController.token,
            language: sessionController.language,
          );
        }

        if (!hasFavoritesContent &&
            (favoritesController.favoriteTracks.isNotEmpty ||
                favoritesController.favoriteArtists.isNotEmpty ||
                favoritesController.favoriteAlbums.isNotEmpty)) {
          hasFavoritesContent = true;
        }

        if (hasFavoritesContent && !initialized) {
          initialized = true;

          recommendationsController.initializeRecommendations(
            token: sessionController.token,
            language: sessionController.language,
            artistsIds: List<String>.generate(
              (favoritesController.favoriteArtists.length >= 3
                  ? 3
                  : favoritesController.favoriteArtists.length),
              (index) => favoritesController.favoriteArtists[index].id,
            ),
            tracksIds: List<String>.generate(
              (favoritesController.favoriteTracks.length >= 2
                  ? 2
                  : favoritesController.favoriteTracks.length),
              (index) => favoritesController.favoriteTracks[index].id,
            ),
          );
        }

        if (recommendationsController.recommendationInitialized &&
            (!hasRecommendationsContent &&
                (recommendationsController.recommendedTracks.isNotEmpty ||
                    recommendationsController.recommendedAlbums.isNotEmpty))) {
          hasRecommendationsContent = true;
        }

        return Column(
          children: [
            Consumer<UserController>(
              builder: (context, userController, child) => Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + 4,
                  right: 12,
                  bottom: 4,
                  left: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          builder: (context, userController, child) =>
                              ImageLoader(
                            imageUrl: userController.currentUser!.avatarUrl,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: EdgeInsets.only(
                          top: hasRecommendationsContent ? 12 : 128,
                          right: hasRecommendationsContent ? 12 : 48,
                          bottom: hasRecommendationsContent ? 12 : 120,
                          left: hasRecommendationsContent ? 12 : 0,
                        ),
                        alignment: hasRecommendationsContent
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: Text(
                          "${userController.currentUser!.displayName}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            !recommendationsController.recommendationInitialized
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: LoaderAnimation(),
                    ),
                  )
                : Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 64,
                      ),
                      children: hasRecommendationsContent
                          ? [
                              if (recommendationsController
                                  .recommendedTracks.isNotEmpty)
                                const RecommendedTracksSection(),
                              if (recommendationsController
                                  .recommendedAlbums.isNotEmpty)
                                const RecommendedAlbumsSection(),
                            ]
                          : [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  "We have no suggestions for you, try adding some things to your favorites.",
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(height: 1.6),
                                ),
                              ),
                            ],
                    ),
                  ),
          ],
        );
      },
    );
  }
}
