// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe_hub/core/review/presentation/bloc/review_mixin.dart';
import 'package:recipe_hub/core/review/presentation/interface/widgets/review_textfield.dart';
import 'package:recipe_hub/shared/presentation/theme/extra_colors.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';
import 'package:recipe_hub/shared/utils/validator.dart';
import 'package:recipe_hub/shared/widgets/loading_manager.dart';

import '../../../../../shared/data/firebase_constants.dart';

class CreateReviewPage extends HookConsumerWidget with ReviewMixin {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String recipeID;
  CreateReviewPage({super.key, required this.recipeID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState<bool>(false);
    final color = Theme.of(context).colorScheme;
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
            'Add Review',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: ReviewTextField(
                          validator: Validator.validateReview,
                          controller: describeExperienceController,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            handleReviewCreation();
                          },
                        ),
                      ),
                      const Text(
                        'Star',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '0.0',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: const SliderThemeData(
                                trackHeight: 8.0,
                                trackShape: RoundedRectSliderTrackShape(),
                              ),
                              child: Slider.adaptive(
                                thumbColor: color.primary,
                                inactiveColor: ExtraColors.lightGrey,
                                value: sliderValue.value,
                                activeColor: color.primary,
                                min: 0.0,
                                max: 5.0,
                                divisions: 50,
                                label: sliderValue.value.toStringAsFixed(1),
                                onChanged: (value) {
                                  sliderValue.value = value;
                                },
                              ),
                            ),
                          ),
                          const Text(
                            '5.0',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ],
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
