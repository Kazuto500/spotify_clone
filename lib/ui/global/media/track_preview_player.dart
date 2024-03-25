import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/data/models/track_model.dart';
import 'package:spotify_clone/ui/global/media/image_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';

class TrackPreviewPlayer extends StatefulWidget {
  final TrackModel track;

  const TrackPreviewPlayer({
    super.key,
    required this.track,
  });

  @override
  State<TrackPreviewPlayer> createState() => _TrackPreviewPlayerState();
}

class _TrackPreviewPlayerState extends State<TrackPreviewPlayer> {
  double reproductionProgress = 0;

  final player = AudioPlayer();

  bool playing = false;
  int timeProgress = 0;

  addFavoriteTrack({
    required SessionController sessionController,
    required SearchMediaController searchMediaController,
    required FavoritesController favoritesController,
  }) {
    favoritesController.addFavoriteTrack(
      token: sessionController.token,
      trackId: widget.track.id,
      onSuccess: () {
        onChanged(
          sessionController: sessionController,
          searchMediaController: searchMediaController,
          favoritesController: favoritesController,
          isFavorite: true,
        );
      },
    );
  }

  removeFavoriteTrack({
    required SessionController sessionController,
    required SearchMediaController searchMediaController,
    required FavoritesController favoritesController,
  }) {
    favoritesController.removeFavoriteTrack(
      token: sessionController.token,
      trackId: widget.track.id,
      onSuccess: () {
        onChanged(
          sessionController: sessionController,
          searchMediaController: searchMediaController,
          favoritesController: favoritesController,
          isFavorite: false,
        );
      },
    );
  }

  onChanged({
    required SessionController sessionController,
    required SearchMediaController searchMediaController,
    required FavoritesController favoritesController,
    required bool isFavorite,
  }) {
    searchMediaController.changeTrackFavoriteStatus(
      trackId: widget.track.id,
      isFavorite: isFavorite,
    );
    favoritesController.getUserFavoriteTracks(
      token: sessionController.token,
      offset: 0,
    );
  }

  bool checkFavorite({required FavoritesController favoritesController}) {
    return favoritesController.favoriteTracks
        .any((track) => track.id == widget.track.id);
  }

  @override
  void initState() {
    //
    super.initState();

    player.setUrl(widget.track.previewUrl!);

    player.playingStream.listen(
      (isPlaying) {
        setState(
          () {
            playing = isPlaying;
          },
        );
      },
    );

    player.positionStream.listen(
      (progress) {
        if (progress.inMilliseconds != 0) {
          setState(
            () {
              timeProgress = progress.inMilliseconds;
            },
          );
        }
      },
    );

    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        player.dispose();
      },
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              image: widget.track.previewCoverUrl != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.track.previewCoverUrl!,
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 32,
                sigmaY: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      constraints: const BoxConstraints(
                        maxWidth: 48,
                        maxHeight: 48,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: const EdgeInsets.all(4),
                      icon: Icon(
                        Icons.close_rounded,
                        color: const Color(0xff1ED760).withOpacity(0.75),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.white12,
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Material(
                                  color: const Color(0xff1e1e1e),
                                  borderRadius: BorderRadius.circular(4),
                                  clipBehavior: Clip.antiAlias,
                                  child: widget.track.previewCoverUrl != null
                                      ? ImageLoader(
                                          imageUrl:
                                              widget.track.previewCoverUrl!,
                                        )
                                      : const Icon(
                                          Icons.image_not_supported_rounded,
                                          size: 40,
                                          color: Colors.white12,
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              widget.track.name,
                                              maxLines: 4,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              widget.track.artists.join(", "),
                                              maxLines: 4,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.white12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                        ),
                                        child: LinearProgressIndicator(
                                          value:
                                              timeProgress * 100 / 29000 / 100,
                                          backgroundColor: Colors.white24,
                                          color: const Color(0xff1ED760),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "0:${((timeProgress / 1000).floor() + (playing ? 1 : 0)).toString().padLeft(2, "0")}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                  color: const Color(0xff1ED760)
                                                      .withOpacity(0.75),
                                                ),
                                          ),
                                          Text(
                                            "0:30",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                  color: Colors.white38,
                                                ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      alignment: WrapAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: 48,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: const Color(0xff2A2A2A),
                                            clipBehavior: Clip.antiAlias,
                                            child: SizedBox(
                                              width: 48,
                                              height: 48,
                                              child: InkWell(
                                                onTap: () {
                                                  launchUrl(
                                                    Uri.parse(
                                                      widget.track.spotifyUri,
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: SvgPicture.asset(
                                                    "lib/assets/svg/common/spotify_icon_no_fill.svg",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 48,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: const Color(0xff2A2A2A),
                                            child: SizedBox(
                                              width: 48,
                                              height: 48,
                                              child: IconButton(
                                                onPressed: (timeProgress / 1000)
                                                            .floor() >=
                                                        29
                                                    ? () {
                                                        player.seek(
                                                            Duration.zero);
                                                        // player.play();
                                                      }
                                                    : player.playing
                                                        ? () {
                                                            player.pause();
                                                          }
                                                        : () {
                                                            player.play();
                                                          },
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                  maxWidth: 48,
                                                  maxHeight: 48,
                                                ),
                                                iconSize: 24,
                                                icon: Icon(
                                                  (timeProgress / 1000)
                                                              .floor() >=
                                                          29
                                                      ? Icons.replay_rounded
                                                      : player.playing
                                                          ? Icons.pause_rounded
                                                          : Icons
                                                              .play_arrow_rounded,
                                                  color:
                                                      const Color(0xff1ED760),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 48,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: const Color(0xff2A2A2A),
                                            child: SizedBox(
                                              width: 48,
                                              height: 48,
                                              child: Consumer3<
                                                  SessionController,
                                                  SearchMediaController,
                                                  FavoritesController>(
                                                builder: (context,
                                                    sessionController,
                                                    searchMediaController,
                                                    favoritesController,
                                                    child) {
                                                  return IconButton(
                                                    onPressed: () {
                                                      if (checkFavorite(
                                                          favoritesController:
                                                              favoritesController)) {
                                                        removeFavoriteTrack(
                                                          sessionController:
                                                              sessionController,
                                                          searchMediaController:
                                                              searchMediaController,
                                                          favoritesController:
                                                              favoritesController,
                                                        );
                                                      } else {
                                                        addFavoriteTrack(
                                                          sessionController:
                                                              sessionController,
                                                          searchMediaController:
                                                              searchMediaController,
                                                          favoritesController:
                                                              favoritesController,
                                                        );
                                                      }
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 48,
                                                      maxHeight: 48,
                                                    ),
                                                    iconSize: 24,
                                                    icon: Icon(
                                                        color: checkFavorite(
                                                                favoritesController:
                                                                    favoritesController)
                                                            ? const Color(
                                                                0xff1ED760)
                                                            : const Color(
                                                                0xffa2a2a2),
                                                        checkFavorite(
                                                                favoritesController:
                                                                    favoritesController)
                                                            ? Icons
                                                                .favorite_rounded
                                                            : Icons
                                                                .favorite_outline_rounded),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
