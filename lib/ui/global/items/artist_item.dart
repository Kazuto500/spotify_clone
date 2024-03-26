import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/data/models/artist_model.dart';
import 'package:spotify_clone/ui/global/media/image_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistItem extends StatefulWidget {
  final ArtistModel artist;
  final Function(String artistId, bool isFavorite) onFavoriteInitialized;
  final Function(String artistId) onFavoriteChanged;

  const ArtistItem({
    super.key,
    required this.artist,
    required this.onFavoriteInitialized,
    required this.onFavoriteChanged,
  });

  @override
  State<ArtistItem> createState() => _ArtistItemState();
}

class _ArtistItemState extends State<ArtistItem> {
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("Launching Uri: ${widget.artist.spotifyUri}");

        launchUrl(
          Uri.parse(
            widget.artist.spotifyUri,
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff1e1e1e),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: widget.artist.coverUrl != null
                        ? ImageLoader(
                            imageUrl: widget.artist.coverUrl!,
                          )
                        : const Icon(
                            Icons.image_not_supported_rounded,
                            size: 40,
                            color: Colors.white12,
                          ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    borderRadius: BorderRadius.circular(24),
                    color: const Color(0xff2A2A2A),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Consumer2<SessionController, FavoritesController>(
                        builder: (context, sessionController,
                            favoritesController, child) {
                          if (!initialized) {
                            initialized = true;

                            if (widget.artist.favorite == null) {
                              favoritesController.checkFavoriteArtist(
                                token: sessionController.token,
                                artistId: widget.artist.id,
                                onSuccess: (isFavorite) {
                                  widget.onFavoriteInitialized(
                                    widget.artist.id,
                                    isFavorite,
                                  );
                                },
                              );
                            }
                          }

                          return IconButton(
                            onPressed: widget.artist.favorite != null
                                ? () {
                                    if (widget.artist.favorite!) {
                                      favoritesController.removeFavoriteArtist(
                                        token: sessionController.token,
                                        artistId: widget.artist.id,
                                        onSuccess: () {
                                          widget.onFavoriteChanged(
                                            widget.artist.id,
                                          );
                                        },
                                      );
                                    } else {
                                      favoritesController.addFavoriteArtist(
                                        token: sessionController.token,
                                        artistId: widget.artist.id,
                                        onSuccess: () {
                                          widget.onFavoriteChanged(
                                            widget.artist.id,
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
                              color: widget.artist.favorite != null
                                  ? widget.artist.favorite!
                                      ? Colors.green
                                      : const Color(0xffa2a2a2)
                                  : const Color(0xff606060),
                              widget.artist.favorite != null
                                  ? widget.artist.favorite!
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded
                                  : Icons.favorite_rounded,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.artist.name,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
