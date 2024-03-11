import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconly/iconly.dart';
import 'package:recipe_hub/core/recipes/presentation/interface/widgets/recipe_info_item.dart';
import 'package:recipe_hub/core/review/presentation/interface/pages/view_reviews.dart';
import 'package:recipe_hub/shared/utils/navigation.dart';

import '../../../../../shared/presentation/theme/extra_colors.dart';

class RecipeDetailsPage extends HookWidget {
  final String recipeID;

  const RecipeDetailsPage({super.key, required this.recipeID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const SizedBox(
                    height: 300,
                    width: double.infinity,
                  ),
                  Positioned(
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://t4.ftcdn.net/jpg/02/84/46/89/360_F_284468940_1bg6BwgOfjCnE3W0wkMVMVqddJgtMynE.jpg',
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const SizedBox(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: IconButton.filledTonal(
                            icon: const Icon(CupertinoIcons.backward),
                            onPressed: () =>
                                NavigationHelper.navigateBack(context),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(ExtraColors.white),
                              minimumSize:
                                  MaterialStateProperty.all(const Size(20, 20)),
                              iconSize: MaterialStateProperty.all(20),
                              foregroundColor:
                                  MaterialStateProperty.all(ExtraColors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton.filledTonal(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(ExtraColors.white),
                              minimumSize:
                                  MaterialStateProperty.all(const Size(20, 20)),
                              iconSize: MaterialStateProperty.all(20),
                              foregroundColor:
                                  MaterialStateProperty.all(ExtraColors.black),
                            ),
                            icon: const Icon(IconlyLight.message),
                            onPressed: () {
                              NavigationHelper.navigateTo(
                                  context, const ViewReviewsPage(recipeID: ''));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        dividerHeight: 0,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        labelStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        unselectedLabelColor: ExtraColors.grey,
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Ingredient(s)'),
                          Tab(text: 'Direction(s)'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 10),
                              shrinkWrap: true,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Text(
                                      'Pizza is a popular and widely recognized dish that originated in Italy but has become a global phenomenon. It is a type of flatbread typically topped with various ingredients and baked in an oven.'),
                                ),
                                const ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('Meal'),
                                  trailing: Text('Lunch',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                ),
                                Divider(
                                    color:
                                        ExtraColors.darkGrey.withOpacity(0.3)),
                                const ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('Diet'),
                                  trailing: Text('Vegan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                ),
                                Divider(
                                    color:
                                        ExtraColors.darkGrey.withOpacity(0.3)),
                                const ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('Cooking Time'),
                                  trailing: Text('10 min',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                )
                              ],
                            ),
                            ListView.separated(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 10),
                              shrinkWrap: true,
                              itemCount: 15,
                              separatorBuilder: (context, index) => Divider(
                                color: ExtraColors.darkGrey.withOpacity(0.3),
                              ),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: Text(
                                    '${index + 1}.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: const Text('Fufu',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: ExtraColors.grey)),
                                );
                              },
                            ),
                            ListView.separated(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 10),
                              shrinkWrap: true,
                              itemCount: 15,
                              separatorBuilder: (context, index) => Divider(
                                color: ExtraColors.darkGrey.withOpacity(0.3),
                              ),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: Text(
                                    '${index + 1}.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: const Text(
                                      'Boil the hot water and add the fufu to it.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: ExtraColors.grey)),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.323,
            right: 0,
            left: 0,
            height: 130,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: ExtraColors.black.withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 6.0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Fufu',
                    style: TextStyle(
                        fontSize: 23, fontWeight: FontWeight.w600, height: 0),
                  ),
                  Divider(color: ExtraColors.darkGrey.withOpacity(0.3)),
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RecipeInfoItem(
                            icon: Icons.auto_graph_outlined,
                            text: 'Easy',
                            iconColor: ExtraColors.grey,
                            textColor: ExtraColors.black),
                        RecipeInfoItem(
                            icon: CupertinoIcons.heart,
                            text: '36',
                            iconColor: ExtraColors.grey,
                            textColor: ExtraColors.black),
                        RecipeInfoItem(
                            icon: Icons.star,
                            text: '4.5',
                            iconColor: ExtraColors.yellow,
                            textColor: ExtraColors.black),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
