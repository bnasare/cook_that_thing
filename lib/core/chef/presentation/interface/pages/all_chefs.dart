import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../shared/data/firebase_constants.dart';
import '../../../../../shared/presentation/theme/extra_colors.dart';
import '../../../../../shared/presentation/widgets/error_view.dart';
import '../../../../../src/home/presentation/interface/widgets/recipe_search_box.dart';
import '../../../../recipes/presentation/bloc/recipe_mixin.dart';
import '../../../domain/entities/chef.dart';
import '../widgets/chef_widget.dart';

class AllChefsPage extends HookWidget with RecipeMixin {
  AllChefsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalChefs = useState<int?>(null);
    final searchController = useTextEditingController();
    final searchResults = useState<List<Chef>?>(null);
    final listChefStreamm =
        useMemoized(() => listChefStream(FirebaseConsts.currentUser!.uid));

    void handleSearch(String query) async {
      if (query.isEmpty) {
        searchResults.value = null;
      } else {
        List<Chef> allChefs =
            await listChefStream(FirebaseConsts.currentUser!.uid).first;
        List<Chef> filteredChefs = allChefs
            .where(
                (chef) => chef.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searchResults.value = filteredChefs;
      }
    }

    useEffect(() {
      final StreamSubscription<List<Chef>> subscription =
          listChefStream(FirebaseConsts.currentUser!.uid).listen((allRecipes) {
        totalChefs.value = allRecipes.length;
      }, onError: (error) {
        debugPrint(error.toString());
      });

      return subscription.cancel;
    }, []);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: const Text('Chefs')),
          body: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 20),
                title: Text(
                  searchController.text.isNotEmpty
                      ? '${searchResults.value?.length ?? 0} ${searchResults.value != null && searchResults.value!.length == 1 ? 'chef found' : 'chefs found'}'
                      : '${totalChefs.value != null ? '${totalChefs.value}' : '0'} ${totalChefs.value == 1 ? 'chef in total' : 'chefs in total'} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ExtraColors.grey,
                    fontSize: 17,
                  ),
                ),
                subtitle: const Text(
                  'Find the perfect chef for you',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: ExtraColors.darkGrey,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 5),
                    CustomSearchBox(
                        handleSearch: handleSearch,
                        controller: searchController,
                        hintText: 'Search for a chef',
                        label: 'Search',
                        enabled:
                            totalChefs.value == null || totalChefs.value == 0
                                ? false
                                : true,
                        readOnly:
                            totalChefs.value == null || totalChefs.value == 0),
                    searchResults.value != null &&
                            searchController.text.isNotEmpty
                        ? searchResults.value!.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: ErrorViewWidget(),
                              )
                            : ChefWidget(chefs: searchResults.value!)
                        : searchController.text.isEmpty
                            ? StreamBuilder(
                                stream: listChefStreamm,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const ErrorViewWidget();
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3),
                                      child: SpinKitFadingCircle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    );
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.isEmpty) {
                                    return const ErrorViewWidget();
                                  } else if (snapshot.hasData) {
                                    return ChefWidget(chefs: snapshot.data!);
                                  } else {
                                    return const ErrorViewWidget();
                                  }
                                })
                            : const ErrorViewWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
