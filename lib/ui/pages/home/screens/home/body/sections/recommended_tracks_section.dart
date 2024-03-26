import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/recommendations_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/ui/global/items/track_item.dart';

class RecommendedTracksSection extends StatelessWidget {
  const RecommendedTracksSection({super.key});

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
                    "Recommended songs",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
          ...List.generate(
            recommendationsController.recommendedTracks.length,
            (index) => Padding(
              padding: const EdgeInsets.all(8),
              child: TrackItem(
                track: recommendationsController.recommendedTracks[index],
                onFavoriteInitialized: (trackId, isFavorite) {
                  recommendationsController
                      .changeRecommendedTrackFavoriteStatus(
                    trackId: trackId,
                    isFavorite: isFavorite,
                  );
                },
                onFavoriteChanged: (trackId) {
                  recommendationsController
                      .changeRecommendedTrackFavoriteStatus(
                    trackId: trackId,
                    isFavorite: !recommendationsController
                        .recommendedTracks[index].favorite!,
                  );
                  favoritesController.getUserFavoriteTracks(
                    token: sessionController.token,
                    offset: 0,
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
