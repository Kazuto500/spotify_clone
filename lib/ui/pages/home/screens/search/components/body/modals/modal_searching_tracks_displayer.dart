import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/items/track_item.dart';
import 'package:spotify_clone/ui/global/loaders/scroll_loader.dart';

class ModalSearchingTracksDisplayer extends StatelessWidget {
  const ModalSearchingTracksDisplayer({
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
                        "Tracks search results",
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
              child: ScrollLoader(
                items: List.generate(
                  searchMediaController.tracks.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: (MediaQuery.sizeOf(context).width - (32)),
                        child: TrackItem(
                          track: searchMediaController.tracks[index],
                          onFavoriteInitialized: (trackId, isFavorite) {
                            searchMediaController.changeTrackFavoriteStatus(
                              trackId: trackId,
                              isFavorite: isFavorite,
                            );
                          },
                          onFavoriteChanged: (trackId) {
                            searchMediaController.changeTrackFavoriteStatus(
                              trackId: trackId,
                              isFavorite: !searchMediaController
                                  .tracks[index].favorite!,
                            );
                            favoritesController.getUserFavoriteTracks(
                              token: sessionController.token,
                              offset: 0,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                totalAvailableItems: searchMediaController.totalAvailableTracks,
                onMoreItemsRequested: () {
                  searchMediaController.extendTracksSearch(
                    token: sessionController.token,
                    language: sessionController.language,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
