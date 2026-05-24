class Validator {
  static String? name(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your name';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please enter a valid name';
    }

    // Split the name and remove empty strings
    List<String> nameParts = value.trim().split(RegExp(r'\s+'));
    nameParts = nameParts.where((part) => part.isNotEmpty).toList();

    if (nameParts.length < 2) {
      return 'Please enter your full name (first and last name)';
    }

    return null;
  }

  static String? email(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // if (!RegExp(
    //         r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
    //     .hasMatch(value)) {
    //   return 'Password must contain uppercase, lowercase, number, and special character';
    // }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value!.isEmpty) {
      return 'Please confirm your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // if (!RegExp(
    //         r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
    //     .hasMatch(value)) {
    //   return 'Password must contain uppercase, lowercase, number, and special character';
    // }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length != 6) {
      return 'OTP must be exactly 6 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    return null;
  }
}
