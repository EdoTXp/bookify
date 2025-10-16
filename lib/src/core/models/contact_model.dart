import 'dart:typed_data';

class ContactModel {
  final String id;
  final String name;
  final Uint8List? photo;
  final String? phoneNumber;

  const ContactModel({
    required this.id,
    required this.name,
    this.photo,
    this.phoneNumber,
  });

  ContactModel copyWith({
    String? id,
    String? name,
    Uint8List? photo,
    String? phoneNumber,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, name: $name, photo: $photo, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.photo == photo &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ photo.hashCode ^ phoneNumber.hashCode;
  }
}
