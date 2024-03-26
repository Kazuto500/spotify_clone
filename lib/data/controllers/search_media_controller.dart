import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_clone/data/api/api_spotify.dart';
import 'package:spotify_clone/data/models/album_model.dart';
import 'package:spotify_clone/data/models/artist_model.dart';
import 'package:spotify_clone/data/models/track_model.dart';


class SearchMediaController extends Api with ChangeNotifier {
  final TextEditingController searchInputController = TextEditingController();

  List<TrackModel> _tracks = [];
  int _totalAvailableTracks = 0;

  List<TrackModel> get tracks => _tracks;
  int get totalAvailableTracks => _totalAvailableTracks;

  List<ArtistModel> _artists = [];
  int _totalAvailableArtists = 0;

  List<ArtistModel> get artists => _artists;
  int get totalAvailableArtists => _totalAvailableArtists;

  List<AlbumModel> _albums = [];
  int _totalAvailableAlbums = 0;

  List<AlbumModel> get albums => _albums;
  int get totalAvailableAlbums => _totalAvailableAlbums;

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  search({
    required String token,
    required String search,
    required String language,
  }) {
    getQuery(
      route: Api.searchMediaRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "q": search,
        "type": "track,artist,album",
        "market": language,
        "limit": "10",
        "offset": "0",
      },
      onStart: () {
        _isSearching = true;
        notifyListeners();
      },
      onSuccess: (data) {
        if (data.containsKey("tracks")) {
          _totalAvailableTracks = data["tracks"]["total"];

          _tracks = List.generate(
            data["tracks"]["items"].length,
            (index) => TrackModel.fromJson(
              data: data["tracks"]["items"][index],
            ),
          );
        }

        if (data.containsKey("artists")) {
          _totalAvailableArtists = data["artists"]["total"];

          _artists = List.generate(
            data["artists"]["items"].length,
            (index) => ArtistModel.fromJson(
              data: data["artists"]["items"][index],
            ),
          );
        }

        if (data.containsKey("albums")) {
          _totalAvailableAlbums = data["albums"]["total"];

          _albums = List.generate(
            data["albums"]["items"].length,
            (index) => AlbumModel.fromJson(
              data: data["albums"]["items"][index],
            ),
          );
        }

        notifyListeners();
      },
      onComplete: () {
        _isSearching = false;
        notifyListeners();
      },
    );
  }

  clearSearch() {
    _tracks = [];
    notifyListeners();
  }

  extendTracksSearch({
    required String token,
    required String language,
  }) {
    getQuery(
      route: Api.searchMediaRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "q": searchInputController.value.text.trim(),
        "type": "track",
        "market": language,
        "limit": "10",
        "offset": "${_tracks.length}",
      },
      onSuccess: (data) {
        if (data.containsKey("tracks")) {
          List<TrackModel> fetchedItems = List.generate(
            data["tracks"]["items"].length,
            (index) => TrackModel.fromJson(
              data: data["tracks"]["items"][index],
            ),
          );

          for (var item in fetchedItems) {
            if (!_tracks.any(
              (track) => track.id == item.id,
            )) {
              _tracks.add(item);
            }
          }
        }

        notifyListeners();
      },
    );
  }

  extendArtistsSearch({
    required String token,
    required String language,
  }) {
    getQuery(
      route: Api.searchMediaRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "q": searchInputController.value.text.trim(),
        "type": "artist",
        "market": language,
        "limit": "10",
        "offset": "${_artists.length}",
      },
      onSuccess: (data) {
        if (data.containsKey("artists")) {
          List<ArtistModel> fetchedItems = List.generate(
            data["artists"]["items"].length,
            (index) => ArtistModel.fromJson(
              data: data["artists"]["items"][index],
            ),
          );

          for (var item in fetchedItems) {
            if (!_artists.any(
              (artist) => artist.id == item.id,
            )) {
              _artists.add(item);
            }
          }
        }

        notifyListeners();
      },
    );
  }

  extendAlbumsSearch({
    required String token,
    required String language,
  }) {
    getQuery(
      route: Api.searchMediaRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "q": searchInputController.value.text.trim(),
        "type": "album",
        "market": language,
        "limit": "10",
        "offset": "${_albums.length}",
      },
      onSuccess: (data) {
        if (data.containsKey("albums")) {
          List<AlbumModel> fetchedItems = List.generate(
            data["albums"]["items"].length,
            (index) => AlbumModel.fromJson(
              data: data["albums"]["items"][index],
            ),
          );

          for (var item in fetchedItems) {
            if (!_albums.any(
              (album) => album.id == item.id,
            )) {
              _albums.add(item);
            }
          }
        }

        notifyListeners();
      },
    );
  }

  changeTrackFavoriteStatus({
    required String trackId,
    required bool isFavorite,
  }) {
    _tracks.firstWhereOrNull((track) => track.id == trackId)?.favorite =
        isFavorite;

    notifyListeners();
  }

  changeArtistFavoriteStatus({
    required String artistId,
    required bool isFavorite,
  }) {
    _artists.firstWhereOrNull((artist) => artist.id == artistId)?.favorite =
        isFavorite;

    notifyListeners();
  }

  changeAlbumFavoriteStatus({
    required String albumId,
    required bool isFavorite,
  }) {
    _albums.firstWhereOrNull((album) => album.id == albumId)?.favorite =
        isFavorite;

    notifyListeners();
  }
}
