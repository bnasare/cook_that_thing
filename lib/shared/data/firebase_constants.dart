import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseConsts {
  // Firebase Authentication instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase Messaging instance
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Get the current user
  static User? get currentUser => _auth.currentUser;

  // Get the authentication instance
  static FirebaseAuth get auth => _auth;

  // Get the messaging instance
  static FirebaseMessaging get messaging => _messaging;
}
