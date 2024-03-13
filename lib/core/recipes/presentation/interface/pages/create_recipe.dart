// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/category_dropdown.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/diet_dropdown.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/difficulty_dropdown.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/utils/validator.dart';
import 'package:recipe_hub/shared/widgets/loading_manager.dart';
import 'package:recipe_hub/shared/widgets/snackbar.dart';
import 'package:recipe_hub/src/home/presentation/interface/pages/nav_bar.dart';
import 'package:uuid/uuid.dart';

import '../../../../../shared/widgets/clickable.dart';
import '../widgets/custom_textfeld.dart';
import '../widgets/list_ingredients.dart';
import '../widgets/list_instructions.dart';

class CreateRecipePage extends HookConsumerWidget with RecipeMixin {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CreateRecipePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = useState<String?>(null);
    final diet = useState<String?>(null);
    final difficultyLevel = useState<String?>(null);
    final submittedIngredients = useState<List<String>>([]);
    final submittedInstructions = useState<List<String>>([]);
    final duration = useState(const Duration(hours: 0, minutes: 0));

    final selectedImage = useState<File?>(null);
    final isLoading = useState<bool>(false);
    final webImage = useState<Uint8List>(Uint8List(8));

    final titleController = useTextEditingController();
    final ingredientsController = useTextEditingController();
    final instructionsController = useTextEditingController();
    final overviewController = useTextEditingController();
    final durationController = useTextEditingController(text: '30min');

    Future<void> pickImage() async {
      if (!kIsWeb) {
        final ImagePicker imagePicker = ImagePicker();
        XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          var selected = File(image.path);
          selectedImage.value = selected;
        } else {
          SnackBarHelper.showInfoSnackBar(context, 'No image has been picked');
        }
      } else if (kIsWeb) {
        final ImagePicker imagePicker = ImagePicker();
        XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          var f = await image.readAsBytes();
          webImage.value = f;
          selectedImage.value = File('a');
        } else {
          SnackBarHelper.showInfoSnackBar(context, 'No image has been picked');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(context, 'Something went wrong');
      }
    }

    void handleRecipeCreation() async {
      if (selectedImage.value == null) {
        SnackBarHelper.showErrorSnackBar(context, 'Please select an image');
        return;
      }

      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        formKey.currentState!.save();
        final uuid = const Uuid().v4();
        final ref = FirebaseStorage.instance
            .ref()
            .child('recipeImages')
            .child('$uuid.jpg');
        String imageUrl;
        if (kIsWeb) {
          await ref.putData(webImage.value);
        } else {
          await ref.putFile(selectedImage.value!);
        }
        imageUrl = await ref.getDownloadURL();
        await createARecipe(
          context: context,
          diet: diet.value!,
          difficultyLevel: difficultyLevel.value!,
          title: titleController.text,
          overview: overviewController.text,
          duration: durationController.text,
          category: category.value!,
          image: imageUrl,
          createdAt: DateTime.now(),
          ingredients: submittedIngredients.value,
          instructions: submittedInstructions.value,
        );
        isLoading.value = false;
        NavigationHelper.navigateToAndRemoveUntil(context, const NavBar());
        titleController.clear();
        overviewController.clear();
        ingredientsController.clear();
        instructionsController.clear();
        selectedImage.value = null;
        submittedIngredients.value = [];
        submittedInstructions.value = [];
      }
    }

    return LoadingManager(
      isLoading: isLoading.value,
      child: Scaffold(
        appBar: AppBar(title: const Text('New Recipe')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 30),
                          height: 300,
                          width: 300,
                          child: selectedImage.value != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: kIsWeb
                                      ? Image.memory(
                                          webImage.value,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          selectedImage.value!,
                                          fit: BoxFit.fill,
                                        ),
                                )
                              : DottedBorder(
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: const [6.7],
                                  borderType: BorderType.RRect,
                                  color: ExtraColors.grey,
                                  radius: const Radius.circular(12),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.image_outlined,
                                          color: ExtraColors.darkGrey,
                                          size: 80,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextButton(
                                          onPressed: (() {
                                            pickImage();
                                          }),
                                          child: const Text(
                                            'Choose an image',
                                            style: TextStyle(
                                              color: ExtraColors.link,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Clickable(
                                onClick: () {
                                  if (selectedImage.value != null) {
                                    selectedImage.value = null;
                                    webImage.value = Uint8List(8);
                                  }
                                },
                                child: Text(
                                  'Clear',
                                  style: TextStyle(
                                    height: 2,
                                    color: selectedImage.value == null
                                        ? ExtraColors.darkGrey
                                        : ExtraColors.link,
                                  ),
                                ),
                              ),
                              Clickable(
                                onClick: () {
                                  if (selectedImage.value != null) {
                                    pickImage();
                                  }
                                },
                                child: Text(
                                  'Update image',
                                  style: TextStyle(
                                    color: selectedImage.value == null
                                        ? ExtraColors.darkGrey
                                        : ExtraColors.link,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                CustomTextFormField(
                  controller: titleController,
                  labelText: 'Title',
                  hintText: 'Title of your recipe',
                  validator: Validator.recipeTitle,
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: overviewController,
                  labelText: 'Overview',
                  hintText: 'A brief description of your recipe',
                  validator: Validator.recipeOverview,
                  maxLines: 2,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryDropdown(
                      category: category,
                      onCategoryChanged: (newValue) {
                        category.value = newValue;
                      },
                    ),
                    const SizedBox(width: 20),
                    DietDropdown(
                      diet: diet,
                      onDietChanged: (newValue) {
                        diet.value = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ListIngredients(
                  ingredientsController: ingredientsController,
                  submittedIngredients: submittedIngredients,
                ),
                SizedBox(
                    height: submittedIngredients.value.isNotEmpty ? 20 : 30),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final initialMinutes = int.tryParse(
                              durationController.text.split('min')[0]);
                          final initialTime =
                              Duration(minutes: initialMinutes ?? 30);
                          var resultingDuration = await showDurationPicker(
                            context: context,
                            initialTime: initialTime,
                          );
                          if (resultingDuration != null) {
                            final hours = resultingDuration.inHours;
                            final minutes =
                                resultingDuration.inMinutes.remainder(60);
                            final durationText = hours > 0
                                ? '${hours}h ${minutes}min'
                                : '${minutes}min';
                            final validationError =
                                Validator.validateTime(durationText);
                            if (validationError == null) {
                              duration.value = resultingDuration;
                              durationController.text = durationText;
                            } else {
                              SnackBarHelper.showErrorSnackBar(
                                  context, validationError);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 25),
                          height: 49,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ExtraColors.transparent,
                            border: Border.all(
                              color: ExtraColors.darkGrey.withOpacity(0.5),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Icon(Icons.timer_outlined,
                                  color: ExtraColors.darkGrey, size: 20),
                              const SizedBox(width: 7),
                              Text(
                                durationController.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ExtraColors.grey.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    DifficultyLevelDropDown(
                      difficultyLevel: difficultyLevel,
                      onDifficultyLevelChanged: (newValue) {
                        difficultyLevel.value = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ListInstructions(
                  instructionsController: instructionsController,
                  submittedInstructions: submittedInstructions,
                ),
              ],
            ),
          )
        ]),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              handleRecipeCreation();
            },
            child: const Text('Create new recipe'),
          ),
        ),
      ),
    );
  }
}
