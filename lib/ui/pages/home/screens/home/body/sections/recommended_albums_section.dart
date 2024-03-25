import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/recommendations_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/items/album_item.dart';
import 'package:spotify_clone/utils/render_utils.dart';


class RecommendedAlbumsSection extends StatelessWidget {
  const RecommendedAlbumsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, RecommendationsController,
            FavoritesController>(
        builder: (context, sessionController, recommendationsController,
            favoritesController, child) {
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    "Recommended albums",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Column(
              children: RenderUtils().groupCountedWidgetsByRow(
                widgets: List<AlbumItem>.generate(
                  recommendationsController.recommendedAlbums.length,
                  (index) => AlbumItem(
                    album: recommendationsController.recommendedAlbums[index],
                    onFavoriteInitialized: (albumId, isFavorite) {
                      recommendationsController
                          .changeRecommendedAlbumFavoriteStatus(
                        albumId: albumId,
                        isFavorite: isFavorite,
                      );
                    },
                    onFavoriteChanged: (albumId) {
                      recommendationsController
                          .changeRecommendedAlbumFavoriteStatus(
                        albumId: albumId,
                        isFavorite: !recommendationsController
                            .recommendedAlbums[index].favorite!,
                      );
                      favoritesController.getUserFavoriteTracks(
                        token: sessionController.token,
                        offset: 0,
                      );
                    },
                  ),
                ),
                widgetsPerRow: 2,
              ),
            ),
          ),
        ],
      );
    });
  }
}
