import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/items/album_item.dart';
import 'package:spotify_clone/ui/global/loaders/scroll__grid_loader.dart';

class FavoriteAlbumsSection extends StatelessWidget {
  const FavoriteAlbumsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, SearchMediaController,
        FavoritesController>(
      builder: (context, sessionController, searchMediaController,
          favoritesController, child) {
        if (favoritesController.favoriteAlbums.isNotEmpty) {
          return ScrollGridLoader(
            items: List.generate(
              favoritesController.favoriteAlbums.length,
              (index) => AlbumItem(
                album: favoritesController.favoriteAlbums[index],
                onFavoriteInitialized: (albumId, isFavorite) {
                  //No deberia acceder a este callback
                },
                onFavoriteChanged: (albumId) {
                  searchMediaController.changeAlbumFavoriteStatus(
                    albumId: albumId,
                    isFavorite: false,
                  );
                },
              ),
            ),
            itemsPerRow: 2,
            totalAvailableItems:
                favoritesController.totalAvailableFavoriteAlbums,
            onMoreItemsRequested: () {
              favoritesController.getUserFavoriteAlbums(
                token: sessionController.token,
              );
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "This is empty, try adding some albums to your favorites",
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
