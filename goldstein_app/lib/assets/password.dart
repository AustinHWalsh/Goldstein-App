import 'package:password/password.dart';

class LoginPassword {
  final algorithm = PBKDF2();

  // Hash the given password using the same algorithm
  String _hashPassword(String password) {
    return Password.hash(password, this.algorithm);
  }

  // Determine if the given password is the same as the hashed one
  bool verifyPassword(String password) {
    return Password.verify(
        _hashPassword(password), _hashPassword(_Password().password));
  }
}

class _Password {
  final password = "";
}
