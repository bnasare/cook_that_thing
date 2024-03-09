import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  /// Forward usecase classes to repositories
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when usecase doesn't take any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

/// Generic params for all objects
class ObjectParams<T> extends Equatable {
  /// Constructor
  const ObjectParams(this.value);

  ///  object class instance
  final T value;

  @override
  List<Object> get props => [value as Object];
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const SignUpParams(
      {required this.email, required this.password, required this.name});

  @override
  List<Object> get props => [email, password, name];
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
