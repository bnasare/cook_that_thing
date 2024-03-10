class Validator {
  static String? name(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your name';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please enter a valid name';
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
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? recipeTitle(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a recipe title';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please enter a valid recipe title';
    }
    return null;
  }

  static String? recipeOverview(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a recipe description';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please enter a valid recipe description';
    }
    return null;
  }

  static String? recipeCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a meal type';
    }
    return null;
  }

  static String? recipeDiet(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a diet type';
    }
    return null;
  }
}
