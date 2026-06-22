class CategoryModel {
  int? id;
  final String name;

  CategoryModel({
    this.id,
    required this.name,
  });

  CategoryModel.withEmptyName({
    this.id,
    this.name = '',
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
    );
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name
''';
  }
}
