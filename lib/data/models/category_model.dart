class CategoryModel {
  final String id;
  final String coverUrl;
  final String name;

  CategoryModel({
    required this.id,
    required this.coverUrl,
    required this.name,
  });

  factory CategoryModel.fromJson({required Map<String, dynamic> data}) {
    return CategoryModel(
      id: data["id"],
      coverUrl: List<Map<String, dynamic>>.from(data["icons"]).first["url"],
      name: data["name"],
    );
  }
}
