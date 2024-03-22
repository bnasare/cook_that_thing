// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:recipe_hub/core/chef/domain/entities/chef.dart';
import 'package:recipe_hub/shared/data/collection_ids.dart';
import 'package:recipe_hub/src/authentication/presentation/interface/pages/wrapper.dart';

import '../../../../injection_container.dart';
import '../../../../shared/utils/navigation.dart';
import '../../../../src/authentication/presentation/bloc/auth_bloc.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/presentation/bloc/recipe_bloc.dart';
import 'chef_bloc.dart';

mixin ChefMixin {
  final bloc = sl<ChefBloc>();
  final authBloc = sl<AuthBloc>();
  final recipeBloc = sl<RecipeBloc>();

  Stream<Chef> retrieve(
      {required BuildContext context, required String chefId}) async* {
    final result = await bloc.retrieve(chefId);
    yield result.fold(
      (l) {
        l;
        return Chef.initial();
      },
      (r) => r,
    );
  }

  Stream<Chef> retrieveChefStream(
      {required BuildContext context, required String chefId}) async* {
    final result = await bloc.retrieve(chefId);
    yield* result.fold(
      (l) {
        return const Stream.empty();
      },
      (r) => Stream.value(r),
    );
  }

  Future<void> follow(
      {required BuildContext context,
      required String chefId,
      required List<String> followers,
      required List<String> token}) async {
    final result = await bloc.follow(chefId, followers, token);
    return result.fold(
      (l) => l,
      (r) => r,
    );
  }

  Future<void> logoutUser({required BuildContext context}) async {
    final result = await authBloc.logoutUser();
    return result.fold(
      (l) => l,
      (r) => NavigationHelper.navigateToAndRemoveUntil(
          context, const AuthWrapper()),
    );
  }

  Stream<List<Recipe>> getRecipes({
    required BuildContext context,
    required String documentID,
  }) async* {
    final result = await recipeBloc.getRecipes(documentID);
    yield result.fold(
      (l) {
        return <Recipe>[];
      },
      (r) => r,
    );
  }

  Stream<List<Recipe>> fetchAllRecipesByChefID(
      BuildContext context, String chefID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.recipes;
    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where('chefID', isEqualTo: chefID)
        .orderBy("createdAt", descending: true)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Recipe> allRecipes = [];
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        List<Recipe> recipesForDocumentId =
            await getRecipes(context: context, documentID: documentId).first;
        allRecipes.addAll(recipesForDocumentId);
      }
      yield allRecipes;
    }
  }

  Stream<int> retrieveRecipeLength(
    BuildContext context,
    String documentID,
  ) async* {
    final List<Recipe> recipes =
        await fetchAllRecipesByChefID(context, documentID).first;
    yield recipes.length;
  }

  Stream<int> retrieveFollowersCount(
      {required BuildContext context, required String chefId}) async* {
    while (true) {
      final result = await bloc.retrieve(chefId);
      yield result.fold(
        (l) {
          return 0;
        },
        (r) => r.followers.length,
      );
    }
  }
}
