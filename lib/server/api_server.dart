import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/utilities/storage.dart';

class ApiServer {
  static final ApiServer instance = ApiServer._construct();
  String _token = "";

  // TODO remake this so there's a more straightforward way to retrieve the JWT
  bool _isInitialised = false;

  ApiServer._construct();

  factory ApiServer() {
    return instance;
  }

  Future<void> _init() async {
    _token = (await DeviceStorage.retrieveValue(storageToken)) ?? "";
  }

  /// Sends a GET request to the server, url should contain query and path parameters if required
  Future<Response> get(String url) async {
    var headers = await getHeaders();
    return http.get(Uri.parse(url), headers: headers);
  }

  /// Sends a POST request to the server, url should contain query and path parameters if required
  Future<Response> post(String url, String jsonBody) async {
    var headers = await getHeaders();
    return http.post(Uri.parse(url), headers: headers, body: jsonBody);
  }

  /// Sends a PUT request to the server, url should contain query and path parameters if required
  Future<Response> put(String url, String jsonBody) async {
    var headers = await getHeaders();
    return http.put(Uri.parse(url), headers: headers, body: jsonBody);
  }

  /// Sends a DELETE request to the server, url should contain query and path parameters if required
  Future<Response> delete(String url) async {
    var headers = await getHeaders();
    return http.delete(Uri.parse(url), headers: headers);
  }

  /// Returns the default headers and appends the token header if available;
  Future<Map<String, String>> getHeaders() async {
    // Set the default headers
    Map<String, String> headers = {
      "content-type": "application/json",
      "accept": "application/json",
    };

    // See if the api has been used yet. If not retrieve the stored JWT first
    if (!_isInitialised) {
      await _init();
    }

    // If the token is available set it too
    if (this._token.isNotEmpty) {
      headers.addAll({"Authorization": "Bearer ${this._token}"});
    }

    return headers;
  }

  void updateToken(String token) {
    this._token = token;
  }
}
