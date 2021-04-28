import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/auth_token.dart';
import 'package:jui/utilities/exceptions.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

abstract class Token {

  static Future<AuthToken> get() async {
    var tkn = await DeviceStorage.retrieveValue(storageToken);
    if (tkn != null) {
      Map<String, dynamic> payload = Jwt.parseJwt(tkn);
      var authToken = AuthToken.fromJson(payload);
      return authToken;
    }
    throw NullTokenException();
  }
}
