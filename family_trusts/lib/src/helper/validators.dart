import 'package:quiver/strings.dart' as quiver;

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _phoneRegExp = RegExp(
    r'^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}$',
  );

  //static final RegExp _passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  bool isValidEmail(String? email) {
    return _emailRegExp.hasMatch(email!);
  }

  bool isValidPassword(String? password) {
    //return _passwordRegExp.hasMatch(password);
    return quiver.isNotBlank(password) && password!.length > 3;
  }

  bool isValidLastName(String? lastName) {
    return quiver.isNotBlank(lastName);
  }

  bool isValidFirstName(String? firstName) {
    return quiver.isNotBlank(firstName);
  }

  bool isValidPhone(String? val) {
    return quiver.isNotBlank(val) && _phoneRegExp.hasMatch(val!);
  }
}
