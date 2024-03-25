import 'package:get/get.dart';

class AlbumModel {
  final String id;
  final String spotifyUri;
  final String? coverUrl;
  final String name;
  final List<String> artists;
  final String? releaseYear;
  bool? favorite;

  AlbumModel({
    required this.id,
    required this.spotifyUri,
    this.coverUrl,
    required this.name,
    required this.artists,
    this.releaseYear,
    this.favorite,
  });

  factory AlbumModel.fromJson({required Map<String, dynamic> data}) {
    return AlbumModel(
      id: data["id"],
      spotifyUri: data["uri"],
      coverUrl: List<Map<String, dynamic>>.from(data["images"])
              .firstWhereOrNull((image) => image["width"] == 300)?["url"] ??
          List<Map<String, dynamic>>.from(data["images"]).firstOrNull?["url"],
      name: data["name"],
      artists: List<String>.from((data["artists"] as List<dynamic>)
          .map((artist) => artist["name"].toString())),
      releaseYear: data["release_date"]?.substring(0, 4),
      favorite: data["favorite"],
    );
  }
}
