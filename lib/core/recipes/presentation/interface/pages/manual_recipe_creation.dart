// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_hub/core/recipes/presentation/bloc/recipe_mixin.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';
import 'package:recipe_hub/shared/widgets/loading_manager.dart';
import 'package:uuid/uuid.dart';

import '../../../../../bottom_navbar.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/widgets/fullscreen_dialog.dart';
import '../../../../../shared/widgets/warning_modal.dart';
import '../widgets/build_dialog_item.dart';
import '../widgets/list_ingredients.dart';
import '../widgets/list_instructions.dart';

class AddRecipeScreen extends StatefulWidget with RecipeMixin {
  AddRecipeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  List<String> submittedIngredients = [];
  List<String> submittedInstructions = [];
  File? _image;
  bool _isSaving = false;

  final titleController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  final difficultyLevelController = TextEditingController();
  final categoryController = TextEditingController();
  final overviewController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  int _index = 0;
  final int _stepAmount = 8;

  String? uploadedImageURL;
  Duration duration = const Duration(minutes: 0);

  Future getImageGallery() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future getImageCamera() async {
    var image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingManager(
      isLoading: _isSaving,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Recipe"),
        ),
        body: SizedBox(
          child: Stepper(
            currentStep: _index,
            onStepTapped: (value) {
              setState(() {
                _index = value;
              });
            },
            onStepCancel: () {
              //print("You are clicking the cancel button.");
              if (_index == 0) {
                Navigator.pop(context);
              } else {
                setState(() {
                  _index -= 1;
                });
              }
            },
            onStepContinue: () async {
              //print("You are clicking the continue button.");
              if (_index + 1 < _stepAmount) {
                setState(() {
                  _index += 1;
                });
              } else {
                // Finished with form | submit everything to firebase

                if (titleController.text.isEmpty ||
                    difficultyLevelController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    overviewController.text.isEmpty ||
                    _image == null ||
                    submittedIngredients.isEmpty ||
                    submittedInstructions.isEmpty ||
                    duration.inMinutes == 0) {
                  // Form not filled out correctly
                  showDialog(
                    context: context,
                    builder: (context) {
                      return WarningModal(
                        title: "Some fields are still empty.",
                        content: "Please make sure to fill out every step.",
                        primaryButtonLabel: "OK",
                        primaryAction: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                } else {
                  setState(() {
                    _isSaving = true;
                  });
                  final uuid = const Uuid().v4();
                  final ref = FirebaseStorage.instance
                      .ref()
                      .child('recipeImages')
                      .child('$uuid.jpg');
                  String imageUrl;

                  await ref.putFile(_image!);

                  imageUrl = await ref.getDownloadURL();
                  await widget.createARecipe(
                    context: context,
                    diet: '',
                    difficultyLevel: difficultyLevelController.text,
                    title: titleController.text,
                    overview: overviewController.text,
                    duration: duration.inMinutes >= 60
                        ? '${duration.inHours}h ${duration.inMinutes.remainder(60)}min'
                        : '${duration.inMinutes}min',
                    category: categoryController.text,
                    image: imageUrl,
                    createdAt: DateTime.now(),
                    ingredients: submittedIngredients,
                    instructions: submittedInstructions,
                  );
                  setState(() {
                    _isSaving = false;
                  });
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => FullscreenDialog(
                      title: 'Recipe published successfully!',
                      content: 'Access your recipes from your profile',
                      dialogType: DialogType.success,
                      primaryButtonLabel: 'OK',
                      primaryAction: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );

                  NavigationHelper.navigateToAndRemoveUntil(
                      context, const NavBar());
                  titleController.clear();
                  overviewController.clear();
                  ingredientsController.clear();
                  instructionsController.clear();
                  difficultyLevelController.clear();
                  categoryController.clear();
                  duration = const Duration(minutes: 0);
                  _image = null;
                  submittedIngredients = [];
                  submittedInstructions = [];
                }
              }
            },
            steps: [
              Step(
                title: const Text("Enter a title"),
                subtitle: const Text(
                    "This name will be displayed when looking at the recipe."),
                content: TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(hintText: "Title", filled: true),
                ),
              ),
              Step(
                title: const Text("Pick an image"),
                subtitle: const Text("The cover image of your recipe."),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 150,
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : DottedBorder(
                                strokeWidth: 1,
                                strokeCap: StrokeCap.round,
                                dashPattern: const [6.7],
                                color: ExtraColors.grey,
                                radius: const Radius.circular(12),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: ExtraColors.darkGrey,
                                    size: 80,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Clickable(
                            child: Text('Choose Picture',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                            onClick: () {
                              getImageGallery();
                            }),
                        Clickable(
                            child: Text('Take Picture',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                            onClick: () {
                              getImageCamera();
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text("Enter meal description"),
                subtitle: const Text(
                  "Provide a brief description of the meal.",
                  overflow: TextOverflow.fade,
                ),
                content: TextField(
                  maxLines: null,
                  controller: overviewController,
                  decoration: const InputDecoration(
                      hintText: "Description", filled: true),
                ),
              ),
              Step(
                title: const Text("Choose meal type"),
                subtitle: const Text("Select the type of meal."),
                content: TextField(
                  controller: categoryController,
                  readOnly: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          shadowColor: ExtraColors.white,
                          title: const Text('Select meal type'),
                          content: SingleChildScrollView(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BuildItem(
                                  label: 'Breakfast',
                                  controller: categoryController),
                              BuildItem(
                                  label: 'Lunch',
                                  controller: categoryController),
                              BuildItem(
                                  label: 'Dinner',
                                  controller: categoryController),
                              BuildItem(
                                  label: 'Dessert',
                                  controller: categoryController),
                              BuildItem(
                                  label: 'Main',
                                  controller: categoryController),
                              BuildItem(
                                  label: 'Snacks',
                                  controller: categoryController),
                            ],
                          )),
                        );
                      },
                    );
                  },
                  decoration: const InputDecoration(
                      hintText: "Meal type", filled: true),
                ),
              ),
              Step(
                title: const Text("Choose a difficulty"),
                subtitle: const Text("How hard is it to make your recipe?"),
                content: TextField(
                  controller: difficultyLevelController,
                  readOnly: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          shadowColor: ExtraColors.white,
                          title: const Text('Select difficulty level'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BuildItem(
                                    label: 'Beginner',
                                    controller: difficultyLevelController),
                                BuildItem(
                                    label: 'Intermediate',
                                    controller: difficultyLevelController),
                                BuildItem(
                                    label: 'Advanced',
                                    controller: difficultyLevelController),
                                BuildItem(
                                    label: 'Expert',
                                    controller: difficultyLevelController),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  decoration: const InputDecoration(
                      hintText: "Difficulty", filled: true),
                ),
              ),
              Step(
                  title: const Text("How much time does it take?"),
                  content: DurationPicker(
                    duration: duration,
                    onChange: (value) {
                      setState(() {
                        duration = value;
                      });
                    },
                    snapToMins: 5,
                  )),
              Step(
                title: const Text("List the ingredients"),
                subtitle: const Text(
                  "Enter all the ingredients required for your recipe one by one.",
                  overflow: TextOverflow.fade,
                ),
                content: ListIngredients(
                  ingredientsController: ingredientsController,
                  submittedIngredients: submittedIngredients,
                ),
              ),
              Step(
                title: const Text("How do you make it?"),
                subtitle: const Text(
                  "Enter all the steps required for your recipe one by one.",
                  overflow: TextOverflow.fade,
                ),
                content: ListInstructions(
                  instructionsController: instructionsController,
                  submittedInstructions: submittedInstructions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
