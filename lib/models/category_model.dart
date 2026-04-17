class CategoryModel {
  final String id;
  final String slug;
  final String name;

  CategoryModel({required this.id, required this.slug, required this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: (map['id'] ?? '').toString(),
      slug: (map['slug'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
    );
  }
}
