import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:jui/models/dto/response/problem_response.dart';

class ApiRequest {
  // Used to handle, deserialize and throw deserialized error objects back to the caller
  static void handleErrors(Response response) {
    // nothing to handle if there's no content
    if (response.statusCode == HttpStatus.noContent) {
      return;
    }

    var jsonBody = json.decode(response.body);

    // redirect to login
    if (response.statusCode == HttpStatus.unauthorized) {
      throw ProblemResponse.fromJson(jsonBody);
    }

    // these are bad, maybe an error styled notification
    if (response.statusCode == HttpStatus.forbidden ||
        response.statusCode == HttpStatus.conflict ||
        response.statusCode == HttpStatus.internalServerError) {
      throw ProblemResponse.fromJson(jsonBody);
    }

    // these are not so bad, show a warning style notification
    if (response.statusCode == HttpStatus.badRequest ||
        response.statusCode == HttpStatus.notFound) {
      throw ProblemResponse.fromJson(jsonBody);
    }
  }
}
