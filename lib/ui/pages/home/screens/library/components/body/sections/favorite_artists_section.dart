import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/items/artist_item.dart';
import 'package:spotify_clone/ui/global/loaders/scroll__grid_loader.dart';

class FavoriteArtistsSection extends StatelessWidget {
  const FavoriteArtistsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, SearchMediaController,
        FavoritesController>(
      builder: (context, sessionController, searchMediaController,
          favoritesController, child) {
        if (favoritesController.favoriteArtists.isNotEmpty) {
          return ScrollGridLoader(
            items: List.generate(
              favoritesController.favoriteArtists.length,
              (index) => ArtistItem(
                artist: favoritesController.favoriteArtists[index],
                onFavoriteInitialized: (artistId, isFavorite) {
                  //No deberia acceder a este callback
                },
                onFavoriteChanged: (artistId) {
                  searchMediaController.changeArtistFavoriteStatus(
                    artistId: artistId,
                    isFavorite: false,
                  );
                },
              ),
            ),
            itemsPerRow: 2,
            totalAvailableItems:
                favoritesController.totalAvailableFavoriteArtists,
            onMoreItemsRequested: () {
              favoritesController.getUserFavoriteArtists(
                token: sessionController.token,
              );
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "This is empty, try adding some artists to your favorites",
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
