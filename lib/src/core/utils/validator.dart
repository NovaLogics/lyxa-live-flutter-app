class Validator {
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    } else if (value.length < 6) {
      return "Password should be at least 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else {
      return null;
    }
  }

  static String? validatePasswordFileds({
    required String? password,
    required String confirmPassword,
  }) {
    if (password == null || password.isEmpty) {
      return "Password cannot be empty";
    } else if (password.length < 6) {
      return "Password should be at least 6 characters";
    } else if (password.length > 15) {
      return "Password should not be greater than 15 characters";
    } else if (password != confirmPassword) {
      return "Passwords do not match!";
    } else {
      return null;
    }
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
      return "Enter a valid email address";
    } else {
      return null;
    }
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username cannot be empty";
    } else if (value.length < 3) {
      return "Username should be at least 3 characters long";
    } else if (value.length > 30) {
      return "Username should not be greater than 30 characters";
    } else if (!RegExp(r"^[a-zA-Z0-9 ]+$").hasMatch(value)) {
      return "Username can only contain letters, numbers, and spaces";
    } else {
      return null;
    }
  }
}
