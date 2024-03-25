class UserModel {
  final String spotifyUri;
  final String avatarUrl;
  final String displayName;

  UserModel({
    required this.spotifyUri,
    required this.avatarUrl,
    required this.displayName,
  });

  factory UserModel.fromJson({required Map<String, dynamic> data}) {
    return UserModel(
      spotifyUri: data["uri"],
      avatarUrl: List<Map<String, dynamic>>.from(data["images"])
          .firstWhere((image) => image["width"] == 300)["url"],
      displayName: data["display_name"],
    );
  }
}
