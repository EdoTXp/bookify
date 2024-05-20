import 'package:flutter/material.dart';

class BookcaseModel {
  final int? id;
  final String name;
  final String description;
  final Color color;

  const BookcaseModel({
    this.id,
    required this.name,
    required this.description,
    required this.color,
  });

  int get colorValue => color.value;

  BookcaseModel copyWith({
    int? id,
    String? name,
    String? description,
    Color? color,
  }) {
    return BookcaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
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
      description: map['description'] as String,
      color: Color(map['color'] as int),
    );
  }

  @override
  String toString() =>
      'BookcaseModel(id: $id, name: $name, description: $description, color: $color)';

  @override
  bool operator ==(covariant BookcaseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.color == color;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode;
}
