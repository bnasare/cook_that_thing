import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:recipe_hub/shared/data/collection_ids.dart';

import '../../domain/entities/chef.dart';

abstract class ChefRemoteDatabase {
  Future<Chef> retrieve(String chefId);
  Future<Chef> follow(
      String chefId, List<String> followers, List<String> token);
}

class ChefRemoteDatabaseImpl implements ChefRemoteDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Chef> retrieve(String chefId) async {
    final result = await _firestore
        .collection(DatabaseCollections.chefs)
        .doc(chefId)
        .get();
    return Chef.fromJson(result.data() ?? {});
  }

  // @override
  // Future<Chef> follow(String chefId, List<String> followers, List<String> token) async {
  // final chefDocRef = _firestore.collection('chefs').doc(chefId);

  // if (followers.isNotEmpty) {
  // await chefDocRef.update({'followers': FieldValue.arrayUnion(followers)});
  // } else {
  // await chefDocRef.update({
  // 'followers':
  // FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
  // });
  // }

  // if (token.isNotEmpty) {
  // await chefDocRef.update({'token': FieldValue.arrayUnion(token)});
  // } else {
  // await chefDocRef.update({
  // 'token': FieldValue.arrayRemove([FirebaseMessaging.instance.getToken()])
  // });
  // }

  // return retrieve(chefId);
  // }

  @override
  Future<Chef> follow(
      String chefId, List<String> followers, List<String> token) async {
    final chefDocRef =
        _firestore.collection(DatabaseCollections.chefs).doc(chefId);

    Map<String, dynamic> updates = {};

    if (followers.isNotEmpty) {
      updates['followers'] = FieldValue.arrayUnion(followers);
    } else {
      updates['followers'] =
          FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]);
    }

    if (token.isNotEmpty) {
      updates['token'] = FieldValue.arrayUnion(token);
    } else {
      String? currentToken = await FirebaseMessaging.instance.getToken();
      updates['token'] = FieldValue.arrayRemove([currentToken]);
    }

    await chefDocRef.update(updates);

    return retrieve(chefId);
  }
}
