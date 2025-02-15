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