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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory AuthorModel.fromMap(Map<String, dynamic> map) {
    return AuthorModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
    );
  }
}
