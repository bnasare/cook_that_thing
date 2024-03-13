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

  static String? recipeIngredientsList(List<String> ingredients) {
    if (ingredients.isEmpty) {
      return 'Please add at least one ingredient';
    }
    return null;
  }

  static String? recipeInstructionsList(List<String> instructions) {
    if (instructions.isEmpty) {
      return 'Please add at least one step';
    }

    return null;
  }

  static String? recipeCategory(String? value) {
    if (value!.isEmpty) {
      return 'Please select a recipe category';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please select a recipe category';
    }
    return null;
  }

  static String? recipeDiet(String? value) {
    if (value!.isEmpty) {
      return 'Please select a diet type';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please select a diet type';
    }
    return null;
  }

  static String? recipeDifficulty(String? value) {
    if (value!.isEmpty) {
      return 'Please select difficulty level';
    }
    if (!RegExp(r"^[a-zA-Z'\- ]+$").hasMatch(value)) {
      return 'Please select difficulty level';
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

  static String? validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Image URL cannot be empty';
    }
    return null;
  }

  static String? validateReview(String? value) {
    if (value == null || value.isEmpty) {
      return 'Review cannot be empty';
    }
    return null;
  }
}
