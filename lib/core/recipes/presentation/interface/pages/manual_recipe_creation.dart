import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_hub/shared/widgets/clickable.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../widgets/build_dialog_item.dart';
import '../widgets/list_ingredients.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  List<String> submittedIngredients = [];
  List<String> submittedInstructions = [];
  File? selectedImage;
  bool isLoading = false;
  Uint8List webImage = Uint8List(8);

  final titleController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  final difficultyLevelController = TextEditingController();
  final categoryController = TextEditingController();
  final dietController = TextEditingController();
  final overviewController = TextEditingController();
  final durationController = TextEditingController(text: '45min');
  final ImagePicker _picker = ImagePicker();

  int _index = 0;
  final int _stepAmount = 7;

  File? _image;

  String? uploadedImageURL;
  String? name;
  String difficulty = "Beginner";
  Duration duration = const Duration(minutes: 0);
  String? toolsInput;
  String? ingredientsInput;
  String? stepsInput;

  bool _isSaving = false;

  List<String> stringToList(String string) {
    var list = string.split("+");

    return list;
  }

  Map<dynamic, dynamic> stringToMap(String string) {
    var bigList = string.split("+");
    var smallList = [];

    for (var item in bigList) {
      smallList.add(item.split(","));
    }

    var finalMap = {};

    for (var item in smallList) {
      finalMap[item[0]] = item[1];
    }

    return finalMap;
  }

  bool isEmpty(String s) {
    if (s.trim() == "") {
      return true;
    } else {
      return false;
    }
  }

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

  Future uploadFile(int id) async {
    // StorageReference reference =
    //     _storage.ref().child("recipe_images/").child("${id.toString()}.jpg");
    // StorageUploadTask uploadTask = reference.putFile(_image);

    // StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

    // uploadedImageURL = (await downloadUrl.ref.getDownloadURL());

    //print(uploadedImageURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              if (isEmpty(name!) ||
                  isEmpty(ingredientsInput!) ||
                  isEmpty(toolsInput!) ||
                  isEmpty(stepsInput!)) {
                // Form not filled out correctly
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Some fields are still empty."),
                      content: const Text(
                          "Please make sure to fill out every step."),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              } else {
                setState(() {
                  _isSaving = true;
                });

                // QuerySnapshot snapshot =
                //     await _database.collection("recipes").orderBy("id").get();

                // int highestID = snapshot.docs.last.data()!["id"];

                // uploadFile(highestID + 1);

                if (!isEmpty(uploadedImageURL!)) {
                  // await _database
                  //     .collection("recipes")
                  //     .doc((highestID + 1).toString())
                  //     .set({
                  //   'name': name,
                  //   'id': highestID + 1,
                  //   'image': uploadedImageURL,
                  //   'difficulty': difficulty,
                  //   'time': duration.inMinutes >= 60
                  //       ? duration.inHours.toString() + " h"
                  //       : duration.inMinutes.toString() + " min",
                  //   'ingredients': stringToMap(ingredientsInput),
                  //   'tools': stringToList(toolsInput),
                  //   'steps': stringToList(stepsInput),
                  // });

                  // // Display spinner
                  // Navigator.pop(context);
                  // setState(() {
                  //   _isSaving = false;
                  // });
                } else {
                  // Image did not upload correctly
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                            "Something went wrong when uploading the image."),
                        content: const Text(
                            "Mabe try another image or try again later."),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                  setState(() {
                    _isSaving = false;
                  });
                }
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
                              fit: BoxFit.fill,
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                decoration:
                    const InputDecoration(hintText: "Difficulty", filled: true),
              ),
            ),
            Step(
                title: const Text("How much time does it take?"),
                content: DurationPicker(
                  duration: duration,
                  onChange: (value) {
                    print("Duration selected: $value");
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
              title: const Text("What tools do you need?"),
              subtitle: const Text(
                "Seperate each with a plus (+)",
                overflow: TextOverflow.fade,
              ),
              content: TextField(
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: "e.g. Blender+Cutting Plate"),
                onChanged: (value) {
                  toolsInput = value;
                },
              ),
            ),
            Step(
              title: const Text("How do you make it?"),
              subtitle: const Text(
                "Enter all the steps required for your recipe one by one.",
                overflow: TextOverflow.fade,
              ),
              content: TextField(
                maxLines: null,
                decoration: const InputDecoration(
                    hintText:
                        "e.g. Mix flour with baking soda.+Bake for 30 min."),
                onChanged: (value) {
                  stepsInput = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
