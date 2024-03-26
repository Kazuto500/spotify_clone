import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/items/track_item.dart';
import 'package:spotify_clone/ui/global/loaders/scroll_loader.dart';

class FavoriteTracksSections extends StatelessWidget {
  const FavoriteTracksSections({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, SearchMediaController,
        FavoritesController>(
      builder: (context, sessionController, searchMediaController,
          favoritesController, child) {
        if (favoritesController.favoriteTracks.isNotEmpty) {
          return ScrollLoader(
            items: List.generate(
              favoritesController.favoriteTracks.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8),
                child: TrackItem(
                  track: favoritesController.favoriteTracks[index],
                  onFavoriteInitialized: (trackId, isFavorite) {
                  },
                  onFavoriteChanged: (trackId) {
                    searchMediaController.changeTrackFavoriteStatus(
                      trackId: trackId,
                      isFavorite: false,
                    );
                  },
                ),
              ),
            ),
            totalAvailableItems:
                favoritesController.totalAvailableFavoriteTracks,
            onMoreItemsRequested: () {
              favoritesController.getUserFavoriteTracks(
                  token: sessionController.token);
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "This is empty, try adding some tracks to your favorites",
                maxLines: 4,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(height: 1.6),
              ),
            ),
          );
        }
      },
    );
  }
}
