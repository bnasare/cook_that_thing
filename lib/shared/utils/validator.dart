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

  static String? recipeIngredients(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your recipe\'s ingredient';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please enter a valid recipe ingredient';
    }
    return null;
  }

  static String? recipeInstructions(String? value) {
    if (value!.isEmpty) {
      return 'Please enter steps to prepare your recipe';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please enter a valid recipe instruction';
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

  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Duration cannot be empty';
    }

    if (value.trim() == '0min') {
      return 'Duration cannot be 0 min';
    }

    return null;
  }
}
