import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/items/artist_item.dart';
import 'package:spotify_clone/ui/global/loaders/scroll__grid_loader.dart';

class ModalSearchingArtistsDisplayer extends StatelessWidget {
  const ModalSearchingArtistsDisplayer({
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
                      "Artists search results",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.keyboard_double_arrow_down_rounded,
                    color: Colors.green.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollGridLoader(
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
                          isFavorite:
                              !searchMediaController.artists[index].favorite!,
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
              itemsPerRow: 2,
              totalAvailableItems: searchMediaController.totalAvailableArtists,
              onMoreItemsRequested: () {
                searchMediaController.extendArtistsSearch(
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
