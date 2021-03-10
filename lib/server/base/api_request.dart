import 'dart:convert';
import 'dart:io';

import 'package:friendsbet/models/response/problem_response.dart';
import 'package:http/http.dart';

class ApiRequest {
  // Used to handle, deserialize and throw deserialized error objects back to the caller
  static void handleErrors(Response response) {
    if (response.statusCode == HttpStatus.badRequest ||
        response.statusCode == HttpStatus.notFound ||
        response.statusCode == HttpStatus.notAcceptable ||
        response.statusCode == HttpStatus.conflict ||
        response.statusCode == HttpStatus.internalServerError) {
      // Validation or other errors, show them
      var problems = ProblemResponse.fromJson(json.decode(response.body));
      throw problems;
    }
  }
}
