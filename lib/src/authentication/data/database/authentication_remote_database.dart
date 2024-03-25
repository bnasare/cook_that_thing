import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/chef/domain/entities/chef.dart';
import '../../../../shared/data/collection_ids.dart';
import '../../../../shared/data/firebase_constants.dart';

abstract class AuthenticationRemoteDatabase {
  Future<Chef> signUp(String email, String password, String name);
  Future<Chef> login(String email, String password);
  Future<Chef> logout();
  Future<Chef> googleSignIn();
}

class AuthenticationRemoteDatabaseImpl implements AuthenticationRemoteDatabase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Chef> signUp(String email, String password, String name) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    Chef chef = Chef(
      name: name,
      email: userCredential.user!.email!,
      id: userCredential.user!.uid,
      chefToken: await FirebaseConsts.messaging.getToken() ?? '',
      followers: [],
      token: [],
      favorites: [],
    );

    final data = chef.toJson();
    await _firestore
        .collection(DatabaseCollections.chefs)
        .doc(chef.id)
        .set(data);

    User? user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(name);
    }

    return chef;
  }

  @override
  Future<Chef> login(String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    Chef chef = Chef(
      name: userCredential.user!.displayName!,
      email: userCredential.user!.email!,
      id: userCredential.user!.uid,
      chefToken: await FirebaseConsts.messaging.getToken() ?? '',
      followers: [],
      token: [],
      favorites: [],
    );

    return chef;
  }

  @override
  Future<Chef> logout() async {
    await _firebaseAuth.signOut();
    return Chef.initial();
  }

  @override
  Future<Chef> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (userCredential.additionalUserInfo!.isNewUser) {
      Chef chef = Chef(
        name: user!.displayName!,
        email: user.email!,
        id: user.uid,
        chefToken: await FirebaseConsts.messaging.getToken() ?? '',
        followers: [],
        token: [],
        favorites: [],
      );

      final data = chef.toJson();
      await _firestore
          .collection(DatabaseCollections.chefs)
          .doc(chef.id)
          .set(data);

      return chef;
    } else {
      Chef chef = Chef(
        name: user!.displayName!,
        email: user.email!,
        id: user.uid,
        chefToken: await FirebaseConsts.messaging.getToken() ?? '',
        followers: [],
        token: [],
        favorites: [],
      );
      return chef;
    }
  }
}
