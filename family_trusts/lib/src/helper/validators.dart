import 'package:quiver/strings.dart' as quiver;

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  //static final RegExp _passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  bool isValidEmail(String? email) {

    return _emailRegExp.hasMatch(email!);
  }

  bool isValidPassword(String? password) {
    //return _passwordRegExp.hasMatch(password);
    return quiver.isNotBlank(password) && password!.length > 3;
  }

  bool isValidName(String? name) {
    return quiver.isNotBlank(name);
  }

  bool isValidSurname(String? surname) {
    return quiver.isNotBlank(surname);
  }
}
