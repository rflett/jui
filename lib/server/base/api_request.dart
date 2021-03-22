import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:jui/models/dto/response/problem_response.dart';

class ApiRequest {
  // Used to handle, deserialize and throw deserialized error objects back to the caller
  static void handleErrors(Response response) {
    if (response.statusCode == HttpStatus.badRequest ||
        response.statusCode == HttpStatus.unauthorized ||
        response.statusCode == HttpStatus.forbidden ||
        response.statusCode == HttpStatus.notFound ||
        response.statusCode == HttpStatus.internalServerError) {
      // Validation or other errors, show them
      var problems = ProblemResponse.fromJson(json.decode(response.body));
      throw problems;
    }
  }
}
