import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/displayers/vertical_items_displayer.dart';
import 'package:spotify_clone/ui/global/items/track_item.dart';
import 'package:spotify_clone/ui/pages/home/screens/search/components/body/modals/modal_searching_tracks_displayer.dart';

class TracksSearchResultsSection extends StatelessWidget {
  const TracksSearchResultsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionController, SearchMediaController,
            FavoritesController>(
        builder: (context, sessionController, searchMediaController,
            favoritesController, child) {
      return VerticalItemsDisplayer(
        title: "Tracks",
        items: List.generate(
          searchMediaController.tracks.length,
          (index) => Material(
            color: Colors.transparent,
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
                  isFavorite: !searchMediaController.tracks[index].favorite!,
                );
                favoritesController.getUserFavoriteTracks(
                  token: sessionController.token,
                  offset: 0,
                );
              },
            ),
          ),
        ),
        extendedModal: const ModalSearchingTracksDisplayer(),
      );
    });
  }
}
