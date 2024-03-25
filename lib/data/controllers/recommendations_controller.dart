import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_clone/data/api/api_spotify.dart';
import 'package:spotify_clone/data/models/album_model.dart';
import 'package:spotify_clone/data/models/track_model.dart';


class RecommendationsController extends Api with ChangeNotifier {
  final List<TrackModel> _recommendedTracks = [];

  List<TrackModel> get recommendedTracks => _recommendedTracks;

  final List<AlbumModel> _recommendedAlbums = [];

  List<AlbumModel> get recommendedAlbums => _recommendedAlbums;

  bool _recommendationInitialized = false;

  bool get recommendationInitialized => _recommendationInitialized;

  initializeRecommendations({
    required String token,
    required String language,
    required List<String> artistsIds,
    required List<String> tracksIds,
  }) {
    _recommendationInitialized = false;

    _recommendedTracks.clear();
    _recommendedAlbums.clear();

    _getRecommendations(
      token: token,
      language: language,
      artistsIds: artistsIds,
      tracksIds: tracksIds,
    );
  }

  _getRecommendations({
    required String token,
    required String language,
    required List<String> artistsIds,
    required List<String> tracksIds,
  }) {
    getQuery(
      route: Api.getRecommendationsRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      params: {
        "limit": "6",
        "market": language,
        "seed_artists": artistsIds.join(","),
        "seed_tracks": tracksIds.join(","),
      },
      onSuccess: (data) {
        _setLocaleRecommendedTracks(data: data);
        // _setLocaleRecommendedArtits(data: data);
        _setLocaleRecommendedAlbums(data: data);

        _recommendationInitialized = true;

        notifyListeners();
      },
    );
  }

  _setLocaleRecommendedTracks({
    required Map<String, dynamic> data,
  }) {
    List<TrackModel> generatedList = List<TrackModel>.generate(
      data["tracks"].length,
      (index) => TrackModel.fromJson(
        data: data["tracks"][index],
      ),
    );

    for (var item in generatedList) {
      if (!_recommendedTracks.any((track) => track.id == item.id)) {
        _recommendedTracks.add(item);
      }
    }
  }

  _setLocaleRecommendedAlbums({
    required Map<String, dynamic> data,
  }) {
    List<AlbumModel> generatedList = List<AlbumModel>.generate(
      data["tracks"].length,
      (index) => AlbumModel.fromJson(
        data: data["tracks"][index]["album"],
      ),
    );

    for (var item in generatedList) {
      if (!_recommendedAlbums.any((album) => album.id == item.id)) {
        _recommendedAlbums.add(item);
      }
    }
  }

  changeRecommendedTrackFavoriteStatus({
    required String trackId,
    required bool isFavorite,
  }) {
    _recommendedTracks
        .firstWhereOrNull((track) => track.id == trackId)
        ?.favorite = isFavorite;

    notifyListeners();
  }

  changeRecommendedAlbumFavoriteStatus({
    required String albumId,
    required bool isFavorite,
  }) {
    _recommendedAlbums
        .firstWhereOrNull((album) => album.id == albumId)
        ?.favorite = isFavorite;

    notifyListeners();
  }
}
