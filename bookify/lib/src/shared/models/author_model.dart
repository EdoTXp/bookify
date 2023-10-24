class AuthorModel {
  int? id;
  final String name;

  AuthorModel({
    this.id,
    required this.name,
  });

  @override
  bool operator ==(covariant AuthorModel other) {
    if (identical(this, other)) return true;
    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  AuthorModel copyWith({
    int? id,
    String? name,
  }) {
    return AuthorModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
