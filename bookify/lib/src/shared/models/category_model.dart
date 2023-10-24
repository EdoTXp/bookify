class CategoryModel {
  int? id;
  final String name;

  CategoryModel({
    this.id,
    required this.name,
  });

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;
    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  CategoryModel copyWith({
    int? id,
    String? name,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
