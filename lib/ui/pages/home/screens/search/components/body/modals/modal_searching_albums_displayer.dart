import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/items/album_item.dart';
import 'package:spotify_clone/ui/global/loaders/scroll__grid_loader.dart';

class ModalSearchingAlbumsDisplayer extends StatelessWidget {
  const ModalSearchingAlbumsDisplayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, SearchMediaController,
            FavoritesController>(
        builder: (context, sessionController, searchMediaController,
            favoritesController, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Albums search results",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.keyboard_double_arrow_down_rounded,
                    color: const Color(0xff1ED760).withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollGridLoader(
              items: List.generate(
                searchMediaController.albums.length,
                (index) => Material(
                  color: Colors.transparent,
                  child: AlbumItem(
                    album: searchMediaController.albums[index],
                    onFavoriteInitialized: (albumId, isFavorite) {
                      searchMediaController.changeAlbumFavoriteStatus(
                        albumId: albumId,
                        isFavorite: isFavorite,
                      );
                    },
                    onFavoriteChanged: (albumId) {
                      searchMediaController.changeAlbumFavoriteStatus(
                        albumId: albumId,
                        isFavorite:
                            !searchMediaController.albums[index].favorite!,
                      );
                      favoritesController.getUserFavoriteAlbums(
                        token: sessionController.token,
                        offset: 0,
                      );
                    },
                  ),
                ),
              ),
              itemsPerRow: 2,
              totalAvailableItems: searchMediaController.totalAvailableAlbums,
              onMoreItemsRequested: () {
                searchMediaController.extendAlbumsSearch(
                  token: sessionController.token,
                  language: sessionController.language,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
