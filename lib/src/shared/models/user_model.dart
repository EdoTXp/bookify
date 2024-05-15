import 'dart:convert';

class UserModel {
  final String name;
  final String? photo;

  const UserModel({
    required this.name,
    required this.photo,
  });

  UserModel copyWith({
    String? name,
    String? photo,
  }) {
    return UserModel(
      name: name ?? this.name,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'photo': photo,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(name: $name, photo: $photo)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.photo == photo;
  }

  @override
  int get hashCode => name.hashCode ^ photo.hashCode;
}
