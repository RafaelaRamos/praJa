import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  return sha256.convert('$password:praja_salt'.codeUnits).toString();
}
