// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../bloc/review_mixin.dart';
import '../widgets/review_textfield.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/utils/navigation.dart';
import '../../../../../shared/utils/validator.dart';
import '../../../../../shared/widgets/loading_manager.dart';

import '../../../../../shared/data/firebase_constants.dart';
import '../../../../recipes/domain/entities/recipe.dart';
import '../../../../recipes/presentation/interface/widgets/recipe_info.dart';

class CreateReviewPage extends HookConsumerWidget with ReviewMixin {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String recipeID;
  CreateReviewPage({super.key, required this.recipeID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState<bool>(false);
    final sliderValue = useState(4.0);
    final TextEditingController describeExperienceController =
        useTextEditingController();

    void handleReviewCreation() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        formKey.currentState!.save();
        await createAReview(
          context: context,
          name: FirebaseConsts.currentUser!.displayName!,
          review: describeExperienceController.text,
          time: DateTime.now(),
          recipeID: recipeID,
          rating: double.parse(sliderValue.value.toStringAsFixed(1)),
        );
        await Future.delayed(const Duration(seconds: 2));
        isLoading.value = false;
        describeExperienceController.clear();
        NavigationHelper.navigateBack(context);
      }
    }

    return LoadingManager(
      isLoading: isLoading.value,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Leave Review',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: ExtraColors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<Recipe>(
                        stream:
                            getRecipe(context: context, documentID: recipeID),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Recipe recipe = snapshot.data!;
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ExtraColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          ExtraColors.darkGrey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(3, 3),
                                    )
                                  ]),
                              child: RecipeInfo(
                                  recipe: recipe, recipeID: recipeID),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: ExtraColors.lightGrey, thickness: 2),
                      const SizedBox(height: 10),
                      const Center(
                          child: Text('How Would You \nRate This Recipe?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                              ))),
                      const SizedBox(height: 10),
                      const Divider(color: ExtraColors.lightGrey, thickness: 2),
                      const SizedBox(height: 20),
                      const Center(
                          child: Text('Your overall rating',
                              style: TextStyle(
                                  fontSize: 18, color: ExtraColors.darkGrey))),
                      const SizedBox(height: 20),
                      Center(
                        child: RatingBar.builder(
                          initialRating: sliderValue.value,
                          minRating: 1,
                          direction: Axis.horizontal,
                          unratedColor: ExtraColors.darkGrey.withOpacity(0.5),
                          allowHalfRating: true,
                          itemSize: 40,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            sliderValue.value = rating;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: ExtraColors.lightGrey, thickness: 2),
                      const SizedBox(height: 20),
                      const Text('Add detailed review',
                          style: TextStyle(
                              color: ExtraColors.black, fontSize: 15)),
                      const SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 20),
                        child: ReviewTextField(
                          validator: Validator.validateReview,
                          controller: describeExperienceController,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            handleReviewCreation();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
              onPressed: () {
                handleReviewCreation();
              },
              child: const Text('Submit')),
        ),
      ),
    );
  }
}
