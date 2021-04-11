class NullTokenException implements Exception {
  String errMsg() => "Stored token does not exist.";
}