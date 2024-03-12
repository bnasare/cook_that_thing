// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chef.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Chef _$ChefFromJson(Map<String, dynamic> json) {
  return _Chef.fromJson(json);
}

/// @nodoc
mixin _$Chef {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get chefToken => throw _privateConstructorUsedError;
  List<String> get followers => throw _privateConstructorUsedError;
  List<String> get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChefCopyWith<Chef> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChefCopyWith<$Res> {
  factory $ChefCopyWith(Chef value, $Res Function(Chef) then) =
      _$ChefCopyWithImpl<$Res, Chef>;
  @useResult
  $Res call(
      {String name,
      String email,
      String id,
      String chefToken,
      List<String> followers,
      List<String> token});
}

/// @nodoc
class _$ChefCopyWithImpl<$Res, $Val extends Chef>
    implements $ChefCopyWith<$Res> {
  _$ChefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? id = null,
    Object? chefToken = null,
    Object? followers = null,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chefToken: null == chefToken
          ? _value.chefToken
          : chefToken // ignore: cast_nullable_to_non_nullable
              as String,
      followers: null == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChefImplCopyWith<$Res> implements $ChefCopyWith<$Res> {
  factory _$$ChefImplCopyWith(
          _$ChefImpl value, $Res Function(_$ChefImpl) then) =
      __$$ChefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String email,
      String id,
      String chefToken,
      List<String> followers,
      List<String> token});
}

/// @nodoc
class __$$ChefImplCopyWithImpl<$Res>
    extends _$ChefCopyWithImpl<$Res, _$ChefImpl>
    implements _$$ChefImplCopyWith<$Res> {
  __$$ChefImplCopyWithImpl(_$ChefImpl _value, $Res Function(_$ChefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? id = null,
    Object? chefToken = null,
    Object? followers = null,
    Object? token = null,
  }) {
    return _then(_$ChefImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chefToken: null == chefToken
          ? _value.chefToken
          : chefToken // ignore: cast_nullable_to_non_nullable
              as String,
      followers: null == followers
          ? _value._followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      token: null == token
          ? _value._token
          : token // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChefImpl with DiagnosticableTreeMixin implements _Chef {
  const _$ChefImpl(
      {required this.name,
      required this.email,
      required this.id,
      required this.chefToken,
      required final List<String> followers,
      required final List<String> token})
      : _followers = followers,
        _token = token;

  factory _$ChefImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChefImplFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final String id;
  @override
  final String chefToken;
  final List<String> _followers;
  @override
  List<String> get followers {
    if (_followers is EqualUnmodifiableListView) return _followers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followers);
  }

  final List<String> _token;
  @override
  List<String> get token {
    if (_token is EqualUnmodifiableListView) return _token;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_token);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Chef(name: $name, email: $email, id: $id, chefToken: $chefToken, followers: $followers, token: $token)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Chef'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('chefToken', chefToken))
      ..add(DiagnosticsProperty('followers', followers))
      ..add(DiagnosticsProperty('token', token));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChefImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chefToken, chefToken) ||
                other.chefToken == chefToken) &&
            const DeepCollectionEquality()
                .equals(other._followers, _followers) &&
            const DeepCollectionEquality().equals(other._token, _token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      email,
      id,
      chefToken,
      const DeepCollectionEquality().hash(_followers),
      const DeepCollectionEquality().hash(_token));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChefImplCopyWith<_$ChefImpl> get copyWith =>
      __$$ChefImplCopyWithImpl<_$ChefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChefImplToJson(
      this,
    );
  }
}

abstract class _Chef implements Chef {
  const factory _Chef(
      {required final String name,
      required final String email,
      required final String id,
      required final String chefToken,
      required final List<String> followers,
      required final List<String> token}) = _$ChefImpl;

  factory _Chef.fromJson(Map<String, dynamic> json) = _$ChefImpl.fromJson;

  @override
  String get name;
  @override
  String get email;
  @override
  String get id;
  @override
  String get chefToken;
  @override
  List<String> get followers;
  @override
  List<String> get token;
  @override
  @JsonKey(ignore: true)
  _$$ChefImplCopyWith<_$ChefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
