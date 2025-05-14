class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException(this.message);

  @override
  String toString() => "InvalidCredetialsException: $message";
}
