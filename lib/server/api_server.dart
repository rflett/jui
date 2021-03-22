import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiServer {
  static final ApiServer instance = ApiServer._construct();
  String _token = "";
  String _tokenType = "";

  ApiServer._construct();

  factory ApiServer() {
    return instance;
  }

  /// Sends a GET request to the server, url should contain query and path parameters if required
  Future<Response> get(String url) {
    return http.get(Uri.parse(url), headers: getHeaders());
  }

  /// Sends a POST request to the server, url should contain query and path parameters if required
  Future<Response> post(String url, String jsonBody) {
    return http.post(Uri.parse(url), headers: getHeaders(), body: jsonBody);
  }

  /// Sends a PUT request to the server, url should contain query and path parameters if required
  Future<Response> put(String url, String jsonBody) {
    return http.put(Uri.parse(url), headers: getHeaders(), body: jsonBody);
  }

  /// Sends a DELETE request to the server, url should contain query and path parameters if required
  Future<Response> delete(String url) {
    return http.delete(Uri.parse(url), headers: getHeaders());
  }

  /// Returns the default headers and appends the token header if available;
  Map<String, String> getHeaders() {
    // Set the default headers
    Map<String, String> headers = {
      "content-type": "application/json",
      "accept": "application/json",
    };

    // If the token is available set it too
    if (this._token.isNotEmpty) {
      headers.addAll({"Authorization": "${this._tokenType} ${this._token}"});
    }

    return headers;
  }

  void updateToken(String jwt) {
    this._token = jwt;
  }

  void updateTokenType(String tokenType) {
    this._tokenType = tokenType;
  }
}
