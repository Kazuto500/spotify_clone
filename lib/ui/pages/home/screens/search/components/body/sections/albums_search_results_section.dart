import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/displayers/horizontal_items_displayer.dart';
import 'package:spotify_clone/ui/global/items/album_item.dart';
import 'package:spotify_clone/ui/pages/home/screens/search/components/body/modals/modal_searching_albums_displayer.dart';

class AlbumsSearchResultsSection extends StatelessWidget {
  const AlbumsSearchResultsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, SearchMediaController,
            FavoritesController>(
        builder: (context, sessionController, searchMediaController,
            favoritesController, child) {
      return HorizontalItemsDisplayer(
        title: "Albums",
        scrollHeight: 213,
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
                  isFavorite: !searchMediaController.albums[index].favorite!,
                );
                favoritesController.getUserFavoriteAlbums(
                  token: sessionController.token,
                  offset: 0,
                );
              },
            ),
          ),
        ),
        extendedModal: const ModalSearchingAlbumsDisplayer(),
      );
    });
  }
}
