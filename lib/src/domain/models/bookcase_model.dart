class BookcaseModel {
  final int? id;
  final String name;
  final String? description;
  final int colorValue;

  const BookcaseModel({
    this.id,
    required this.name,
    this.description,
    required this.colorValue,
  });

  BookcaseModel copyWith({
    int? id,
    String? name,
    String? description,
    int? colorValue,
  }) {
    return BookcaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  BookcaseModel copyWithDescriptionNull({
    int? id,
    String? name,
    int? colorValue,
  }) {
    return BookcaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: null,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'color': colorValue,
    };
  }

  factory BookcaseModel.fromMap(Map<String, dynamic> map) {
    return BookcaseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      colorValue: map['color'] as int,
    );
  }

  @override
  String toString() =>
      'BookcaseModel(id: $id, name: $name, description: $description, colorValue: $colorValue)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookcaseModel &&
          other.id == id &&
          other.name == name &&
          other.description == description &&
          other.colorValue == colorValue;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ colorValue.hashCode;
}
