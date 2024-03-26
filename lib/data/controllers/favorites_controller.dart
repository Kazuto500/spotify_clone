import 'package:flutter/material.dart';
import 'package:spotify_clone/data/api/api_spotify.dart';
import 'package:spotify_clone/data/models/album_model.dart';
import 'package:spotify_clone/data/models/artist_model.dart';
import 'package:spotify_clone/data/models/track_model.dart';


class FavoritesController extends Api with ChangeNotifier {
  List<TrackModel> _favoriteTracks = [];
  int _totalAvailableFavoriteTracks = 0;

  List<TrackModel> get favoriteTracks => _favoriteTracks;
  int get totalAvailableFavoriteTracks => _totalAvailableFavoriteTracks;

  List<ArtistModel> _favoriteArtists = [];
  int _totalAvailableFavoriteArtists = 0;

  List<ArtistModel> get favoriteArtists => _favoriteArtists;
  int get totalAvailableFavoriteArtists => _totalAvailableFavoriteArtists;

  List<AlbumModel> _favoriteAlbums = [];
  int _totalAvailableFavoriteAlbums = 0;

  List<AlbumModel> get favoriteAlbums => _favoriteAlbums;
  int get totalAvailableFavoriteAlbums => _totalAvailableFavoriteAlbums;

  bool _favoritesInitialized = false;

  bool get favoritesInitialized => _favoritesInitialized;

  initFavorites({
    required String token,
    required String language,
  }) {
    _favoritesInitialized = true;

    getUserFavoriteTracks(token: token);
    getUserFavoriteArtists(token: token);
    getUserFavoriteAlbums(token: token);
  }

  getUserFavoriteTracks({
    required String token,
    int? offset,
  }) {
    getQuery(
      route: Api.userFavoriteTracksRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "time_range": "medium_term",
        "limit": "20",
        "offset": "${offset ?? _favoriteTracks.length}",
      },
      onSuccess: (data) {
        _totalAvailableFavoriteTracks = data["total"];

        List<TrackModel> fetchedItems = List<TrackModel>.generate(
          data["items"].length,
          (index) {
            data["items"][index]["track"].addAll({"favorite": true});
            return TrackModel.fromJson(data: data["items"][index]["track"]);
          },
        );

        if (offset == null) {
          for (var item in fetchedItems) {
            if (!_favoriteTracks.any(
              (artist) => artist.id == item.id,
            )) {
              _favoriteTracks.add(item);
            }
          }
        } else {
          _favoriteTracks = fetchedItems;
        }

        notifyListeners();
      },
    );
  }

  getUserFavoriteArtists({
    required String token,
    bool? empty,
  }) {
    getQuery(
      route: Api.userFavoriteArtistsRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "type": "artist",
        "limit": "20",
        if ((empty == null || !empty) && (_favoriteArtists.isNotEmpty))
          "after": _favoriteArtists.last.id,
      },
      onSuccess: (data) {
        _totalAvailableFavoriteArtists = data["artists"]["total"];

        List<ArtistModel> fetchedItems = List<ArtistModel>.generate(
          data["artists"]["items"].length,
          (index) {
            data["artists"]["items"][index].addAll({"favorite": true});
            return ArtistModel.fromJson(data: data["artists"]["items"][index]);
          },
        );

        if (empty == null) {
          for (var item in fetchedItems) {
            if (!_favoriteArtists.any(
              (artist) => artist.id == item.id,
            )) {
              _favoriteArtists.add(item);
            }
          }
        } else {
          _favoriteArtists = fetchedItems;
        }

        notifyListeners();
      },
    );
  }

  getUserFavoriteAlbums({
    required String token,
    int? offset,
  }) {
    getQuery(
      route: Api.userFavoriteAlbumsRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "limit": "20",
        "offset": "${offset ?? _favoriteAlbums.length}",
      },
      onSuccess: (data) {
        _totalAvailableFavoriteAlbums = data["total"];

        List<AlbumModel> fetchedItems = List<AlbumModel>.generate(
          data["items"].length,
          (index) {
            data["items"][index]["album"].addAll({"favorite": true});
            return AlbumModel.fromJson(data: data["items"][index]["album"]);
          },
        );

        if (offset == null) {
          for (var item in fetchedItems) {
            if (!_favoriteAlbums.any(
              (artist) => artist.id == item.id,
            )) {
              _favoriteAlbums.add(item);
            }
          }
        } else {
          _favoriteAlbums = fetchedItems;
        }

        notifyListeners();
      },
    );
  }

  addFavoriteTrack({
    required String token,
    required String trackId,
    required Function onSuccess,
  }) {
    putQuery(
      route: Api.userFavoriteTracksRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "ids": trackId,
      },
      onSuccess: (_) {
        onSuccess();
      },
    );
  }

  addFavoriteArtist({
    required String token,
    required String artistId,
    required Function onSuccess,
  }) {
    putQuery(
      route: Api.userFavoriteArtistsRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "type": "artist",
        "ids": artistId,
      },
      onSuccess: (_) {
        onSuccess();
      },
    );
  }

  addFavoriteAlbum({
    required String token,
    required String albumId,
    required Function onSuccess,
  }) {
    putQuery(
      route: Api.userFavoriteAlbumsRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "ids": albumId,
      },
      onSuccess: (_) {
        onSuccess();
      },
    );
  }

  checkFavoriteTrack({
    required String token,
    required String trackId,
    required Function(bool isFavorite) onSuccess,
  }) {
    getQuery(
      route: Api.checkFavoriteTrackRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "ids": trackId,
      },
      onSuccess: (data) {
        onSuccess(data["response"].first);
      },
    );
  }

  checkFavoriteArtist({
    required String token,
    required String artistId,
    required Function(bool isFavorite) onSuccess,
  }) {
    getQuery(
      route: Api.checkFavoriteArtistRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "type": "artist",
        "ids": artistId,
      },
      onSuccess: (data) {
        onSuccess(data["response"].first);
      },
    );
  }

  checkFavoriteAlbum({
    required String token,
    required String albumId,
    required Function(bool isFavorite) onSuccess,
  }) {
    getQuery(
      route: Api.checkFavoriteAlbumRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "ids": albumId,
      },
      onSuccess: (data) {
        onSuccess(data["response"].first);
      },
    );
  }

  removeFavoriteTrack({
    required String token,
    required String trackId,
    required Function onSuccess,
  }) {
    deleteQuery(
      route: Api.userFavoriteTracksRoute,
      headers: {
        "Authorization": "Bearer $token",
      },
      parameters: {
        "ids": trackId,
      },
      onSuccess: (_) {
        if (_favoriteTracks.any(
          (track) => track.id == trackId,
        )) {
          _favoriteTracks.removeWhere((track) => track.id == trackId);

          notifyListeners();

          if (_favoriteTracks.length < 20 &&
              _favoriteTracks.length < _totalAvailableFavoriteTracks) {
            getUserFavoriteTracks(token: token);
          }
        }

        onSuccess();
      },
    );
  }

  removeFavoriteArtist({
    required String token,
    required String artistId,
    required Function onSuccess,
  }) {
    deleteQuery(
      route: Api.userFavoriteArtistsRoute,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      parameters: {
        "type": "artist",
        "ids": artistId,
      },
      onSuccess: (_) {
        if (_favoriteArtists.any(
          (artist) => artist.id == artistId,
        )) {
          _favoriteArtists.removeWhere((artist) => artist.id == artistId);

          notifyListeners();

          if (_favoriteArtists.length < 20 &&
              _favoriteArtists.length < _totalAvailableFavoriteArtists) {
            getUserFavoriteArtists(token: token);
          }
        }

        onSuccess();
      },
    );
  }

  removeFavoriteAlbum({
    required String token,
    required String albumId,
    required Function onSuccess,
  }) {
    deleteQuery(
      route: Api.userFavoriteAlbumsRoute,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      parameters: {
        "ids": albumId,
      },
      onSuccess: (_) {
        if (_favoriteAlbums.any(
          (album) => album.id == albumId,
        )) {
          _favoriteAlbums.removeWhere((album) => album.id == albumId);

          notifyListeners();

          if (_favoriteAlbums.length < 20 &&
              _favoriteAlbums.length < _totalAvailableFavoriteAlbums) {
            getUserFavoriteAlbums(token: token);
          }
        }

        onSuccess();
      },
    );
  }
}
