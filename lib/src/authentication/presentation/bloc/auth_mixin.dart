import 'package:flutter/material.dart';
import 'package:recipe_hub/bottom_navbar.dart';

import '../../../../injection_container.dart';
import '../../../../shared/utils/navigation.dart';
import '../../../../shared/widgets/snackbar.dart';
import '../interface/pages/login.dart';
import 'auth_bloc.dart';

mixin AuthMixin {
  final bloc = sl<AuthBloc>();

  Future<void> signUpUser(
      {required BuildContext context,
      required String email,
      required String name,
      required String password}) async {
    final result = await bloc.signUpUser(
      email,
      password,
      name,
    );
    return result.fold(
      (l) => SnackBarHelper.showErrorSnackBar(context, l.message),
      (r) {
        NavigationHelper.navigateTo(context, LoginPage());
      },
    );
  }

  Future<void> loginUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    final result = await bloc.loginUser(
      email,
      password,
    );
    return result.fold(
        (l) => SnackBarHelper.showErrorSnackBar(context, l.message),
        (r) => NavigationHelper.navigateToReplacement(context, const NavBar()));
  }

  Future<void> logoutUser({required BuildContext context}) async {
    final result = await bloc.logoutUser();
    return result.fold(
      (l) => l,
      (r) => r,
    );
  }

  Future<void> googleSignIn({required BuildContext context}) async {
    final result = await bloc.googleSignInUser();
    return result.fold(
      (l) => SnackBarHelper.showErrorSnackBar(context, l.message),
      (r) => NavigationHelper.navigateToReplacement(context, const NavBar()),
    );
  }
}
