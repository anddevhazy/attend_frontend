class Validators {
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    const pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    return RegExp(pattern).hasMatch(email);
  }

  static bool isValidPassword(String? password, {int minLength = 6}) {
    if (password == null || password.isEmpty) return false;
    return password.length >= minLength;
  }

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
