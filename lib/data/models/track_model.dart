import 'package:get/get.dart';

class TrackModel {
  final String id;
  final String spotifyUri;
  final String? coverUrl;
  final String? previewCoverUrl;
  final String name;
  final List<String> artists;
  final String? previewUrl;
  bool? favorite;

  TrackModel({
    required this.id,
    required this.spotifyUri,
    this.coverUrl,
    this.previewCoverUrl,
    required this.name,
    required this.artists,
    this.previewUrl,
    this.favorite,
  });

  factory TrackModel.fromJson({required Map<String, dynamic> data}) {
    return TrackModel(
      id: data["id"],
      spotifyUri: data["uri"],
      coverUrl: List<Map<String, dynamic>>.from(data["album"]["images"])
              .firstWhereOrNull((image) => image["width"] == 64)?["url"] ??
          List<Map<String, dynamic>>.from(data["album"]["images"])
              .firstOrNull?["url"],
      previewCoverUrl: List<Map<String, dynamic>>.from(data["album"]["images"])
          .firstOrNull?["url"],
      name: data["name"],
      artists:
          List<String>.from(data["artists"].map((artist) => artist["name"])),
      previewUrl: data["preview_url"],
      favorite: data["favorite"],
    );
  }
}
