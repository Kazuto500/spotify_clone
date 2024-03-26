import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/data/models/track_model.dart';
import 'package:spotify_clone/ui/global/media/image_loader.dart';
import 'package:spotify_clone/ui/global/media/track_preview_player.dart';

import 'package:url_launcher/url_launcher.dart';

class TrackItem extends StatefulWidget {
  final TrackModel track;
  final Function(String trackId, bool isFavorite) onFavoriteInitialized;
  final Function(String trackId) onFavoriteChanged;

  const TrackItem({
    super.key,
    required this.track,
    required this.onFavoriteInitialized,
    required this.onFavoriteChanged,
  });

  @override
  State<TrackItem> createState() => _TrackItemState();
}

class _TrackItemState extends State<TrackItem> {
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("Launching Uri: ${widget.track.spotifyUri}");

        launchUrl(
          Uri.parse(
            widget.track.spotifyUri,
          ),
        );
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Material(
                color: const Color(0xff1e1e1e),
                borderRadius: BorderRadius.circular(4),
                clipBehavior: Clip.antiAlias,
                child: widget.track.coverUrl != null
                    ? ImageLoader(
                        imageUrl: widget.track.coverUrl!,
                      )
                    : const Icon(
                        Icons.image_not_supported_rounded,
                        size: 40,
                        color: Colors.white12,
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.track.name,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      widget.track.artists.join(", "),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xff2A2A2A),
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Consumer2<SessionController, FavoritesController>(
                        builder: (context, sessionController,
                            favoritesController, child) {
                          if (!initialized) {
                            initialized = true;

                            if (widget.track.favorite == null) {
                              favoritesController.checkFavoriteTrack(
                                token: sessionController.token,
                                trackId: widget.track.id,
                                onSuccess: (isFavorite) {
                                  widget.onFavoriteInitialized(
                                    widget.track.id,
                                    isFavorite,
                                  );
                                },
                              );
                            }
                          }

                          return IconButton(
                            onPressed: widget.track.favorite != null
                                ? () {
                                    if (widget.track.favorite!) {
                                      favoritesController.removeFavoriteTrack(
                                        token: sessionController.token,
                                        trackId: widget.track.id,
                                        onSuccess: () {
                                          widget.onFavoriteChanged(
                                            widget.track.id,
                                          );
                                        },
                                      );
                                    } else {
                                      favoritesController.addFavoriteTrack(
                                        token: sessionController.token,
                                        trackId: widget.track.id,
                                        onSuccess: () {
                                          widget.onFavoriteChanged(
                                            widget.track.id,
                                          );
                                        },
                                      );
                                    }
                                  }
                                : null,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              maxWidth: 40,
                              maxHeight: 40,
                            ),
                            icon: Icon(
                              color: widget.track.favorite != null
                                  ? widget.track.favorite!
                                      ? Colors.green
                                      : const Color(0xffa2a2a2)
                                  : const Color(0xff606060),
                              widget.track.favorite != null
                                  ? widget.track.favorite!
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded
                                  : Icons.favorite_rounded,
                            ),
                          );
                        },
                      ),
                    ),
                    if (widget.track.previewUrl != null)
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.8),
                              builder: (context) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 56,
                                  ),
                                  child: TrackPreviewPlayer(
                                    track: widget.track,
                                  ),
                                ),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(maxWidth: 40, maxHeight: 40),
                          icon: const Icon(
                            color: Colors.white,
                            Icons.play_arrow_rounded,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
