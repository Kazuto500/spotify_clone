import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/displayers/horizontal_items_displayer.dart';
import 'package:spotify_clone/ui/global/items/artist_item.dart';
import 'package:spotify_clone/ui/pages/home/screens/search/components/body/modals/modal_searching_artists_displayer.dart';

class ArtistsSearchResultsSection extends StatelessWidget {
  const ArtistsSearchResultsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, SearchMediaController,
            FavoritesController>(
        builder: (context, sessionController, searchMediaController,
            favoritesController, child) {
      return HorizontalItemsDisplayer(
        title: "Artists",
        scrollHeight: 175,
        items: List.generate(
          searchMediaController.artists.length,
          (index) => Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 130,
              child: ArtistItem(
                artist: searchMediaController.artists[index],
                onFavoriteInitialized: (artistId, isFavorite) {
                  searchMediaController.changeArtistFavoriteStatus(
                    artistId: artistId,
                    isFavorite: isFavorite,
                  );
                },
                onFavoriteChanged: (artistId) {
                  searchMediaController.changeArtistFavoriteStatus(
                    artistId: artistId,
                    isFavorite: !searchMediaController.artists[index].favorite!,
                  );
                  favoritesController.getUserFavoriteArtists(
                    token: sessionController.token,
                    empty: true,
                  );
                },
              ),
            ),
          ),
        ),
        extendedModal: const ModalSearchingArtistsDisplayer(),
      );
    });
  }
}
