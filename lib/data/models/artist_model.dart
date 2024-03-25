import 'package:get/get.dart';

class ArtistModel {
  final String id;
  final String spotifyUri;
  final String? coverUrl;
  final String name;
  bool? favorite;

  ArtistModel({
    required this.id,
    required this.spotifyUri,
    this.coverUrl,
    required this.name,
    this.favorite,
  });

  factory ArtistModel.fromJson({required Map<String, dynamic> data}) {
    return ArtistModel(
      id: data["id"],
      spotifyUri: data["uri"],
      coverUrl: List<Map<String, dynamic>>.from(data["images"])
              .firstWhereOrNull((image) => image["width"] == 320)?["url"] ??
          List<Map<String, dynamic>>.from(data["images"]).firstOrNull?["url"],
      name: data["name"],
      favorite: data["favorite"],
    );
  }
}
