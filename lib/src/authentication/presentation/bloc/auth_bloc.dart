import 'package:dartz/dartz.dart';
import 'package:recipe_hub/shared/error/failure.dart';
import 'package:recipe_hub/src/authentication/domain/usecase/google_sign_in.dart';

import '../../../../core/chef/domain/entities/chef.dart';
import '../../../../shared/usecase/usecase.dart';
import '../../domain/usecase/login.dart';
import '../../domain/usecase/logout.dart';
import '../../domain/usecase/sign_up.dart';

class AuthBloc {
  final SignUp signUp;
  final Login login;
  final Logout logout;
  final SignInWithGoogle googleSignIn;

  AuthBloc(
      {required this.signUp,
      required this.login,
      required this.logout,
      required this.googleSignIn});

  Future<Either<Failure, Chef>> signUpUser(
      String email, String password, String name) async {
    return await signUp(
        SignUpParams(email: email, password: password, name: name));
  }

  Future<Either<Failure, Chef>> loginUser(String email, String password) async {
    return await login(LoginParams(email: email, password: password));
  }

  Future<Either<Failure, Chef>> logoutUser() async {
    return await logout(NoParams());
  }

  Future<Either<Failure, Chef>> googleSignInUser() async {
    return await googleSignIn(NoParams());
  }
}
