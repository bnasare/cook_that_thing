import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChefProfilePage extends HookWidget {
  final String chefID;
  const ChefProfilePage({super.key, required this.chefID});

  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final isCurrentUser = chefID == currentUserID;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
