import 'package:http/http.dart' as http;
import 'package:friendsbet/utilities/storage.dart';
import 'package:http/http.dart';

class ApiServer {
  static final ApiServer instance = ApiServer._construct();
  String _token = "";

  ApiServer._construct(){
  }

  factory ApiServer() {
    return instance;
  }

  /// Sends a GET request to the server, url should contain query parameters if required
  Future<Response> get(String url) {
    return http.get(url, headers: getHeaders());
  }

  /// Sends a POST request to the server, url should contain query parameters if required
  Future<Response> post(String url, String jsonBody) {
    return http.post(url, headers: getHeaders(), body: jsonBody);
  }

  /// Sends a PUT request to the server, url should contain query parameters if required
  Future<Response> put(String url, String jsonBody) {
    return http.put(url, headers: getHeaders(), body: jsonBody);
  }

  /// Sends a DELETE request to the server, url should contain query parameters if required
  Future<Response> delete(String url) {
    return http.delete(url, headers: getHeaders());
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
      headers.addAll({"Authorization": "Bearer ${this._token}"});
    }

    return headers;
  }

  void updateToken(String jwt) {
    this._token = jwt;
  }
}
