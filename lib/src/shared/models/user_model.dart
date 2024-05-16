import 'dart:convert';

enum SignInType {
  google,
  apple,
  facebook;

  static SignInType toType(int value) {
    return switch (value) {
      1 => SignInType.google,
      2 => SignInType.apple,
      3 => SignInType.facebook,
      _ => throw Exception('Error type'),
    };
  }

  int toIntValue() {
    return switch (this) {
      SignInType.google => 1,
      SignInType.apple => 2,
      SignInType.facebook => 3,
    };
  }
}

class UserModel {
  final String name;
  final String? photo;
  final SignInType signInType;

  const UserModel({
    required this.name,
    required this.photo,
    required this.signInType,
  });

  UserModel copyWith({
    String? name,
    String? photo,
    SignInType? signInType,
  }) {
    return UserModel(
      name: name ?? this.name,
      photo: photo ?? this.photo,
      signInType: signInType ?? this.signInType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'photo': photo,
      'signInType': signInType.toIntValue(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
      signInType: SignInType.toType(map['signInType'] as int),
    );
  }

  @override
  String toString() =>
      'UserModel(name: $name, photo: $photo, signInType: $signInType)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.photo == photo &&
        other.signInType == signInType;
  }

  @override
  int get hashCode => name.hashCode ^ photo.hashCode ^ signInType.hashCode;

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
