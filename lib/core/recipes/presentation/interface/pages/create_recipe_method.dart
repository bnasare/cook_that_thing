import 'package:flutter/material.dart';
import 'package:recipe_hub/bottom_navbar.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/pages/manual_recipe_creation.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/widgets/snackbar.dart';

enum AddRecipeOption { importWeb, voiceInput, recipeScanner, manualEntry }

class CreateRecipeChoicePage extends StatefulWidget {
  const CreateRecipeChoicePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateRecipeChoicePageState createState() => _CreateRecipeChoicePageState();
}

class _CreateRecipeChoicePageState extends State<CreateRecipeChoicePage> {
  AddRecipeOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = null;
  }

  void _onNextPressed(BuildContext context) {
    if (_selectedOption == null) {
      return;
    } else if (_selectedOption == AddRecipeOption.manualEntry) {
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async {
            NavigationHelper.navigateToReplacement(context, const NavBar());
            return true;
          },
          child: AddRecipeScreen(),
        );
      }));
    } else {
      SnackBarHelper.showInfoSnackBar(context, 'Feature not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Recipe Creation Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('Manual Entry', style: TextStyle(fontSize: 18)),
              leading: Radio<AddRecipeOption>(
                value: AddRecipeOption.manualEntry,
                groupValue: _selectedOption,
                onChanged: (AddRecipeOption? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title:
                  const Text('Import from Web', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Feature not available yet',
                  style: TextStyle(color: Colors.red)),
              leading: Radio<AddRecipeOption>(
                value: AddRecipeOption.importWeb,
                groupValue: _selectedOption,
                onChanged: (AddRecipeOption? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('Voice Input', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Feature not available yet',
                  style: TextStyle(color: Colors.red)),
              leading: Radio<AddRecipeOption>(
                value: AddRecipeOption.voiceInput,
                groupValue: _selectedOption,
                onChanged: (AddRecipeOption? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title:
                  const Text('Recipe Scanner', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Feature not available yet',
                  style: TextStyle(color: Colors.red)),
              leading: Radio<AddRecipeOption>(
                value: AddRecipeOption.recipeScanner,
                groupValue: _selectedOption,
                onChanged: (AddRecipeOption? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : () => _onNextPressed(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Theme.of(context).colorScheme.primaryContainer;
                    }
                    return Theme.of(context).colorScheme.primary;
                  },
                ),
              ),
              child: Text('Next',
                  style: TextStyle(
                      fontSize: 18,
                      color: _selectedOption == null
                          ? ExtraColors.darkGrey
                          : ExtraColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
