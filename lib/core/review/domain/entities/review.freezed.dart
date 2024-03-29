// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  String get name => throw _privateConstructorUsedError;
  String get review => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  String get recipeID => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String get chefToken => throw _privateConstructorUsedError;
  String get chefID => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call(
      {String name,
      String review,
      DateTime time,
      String recipeID,
      double rating,
      String chefToken,
      String chefID});
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? review = null,
    Object? time = null,
    Object? recipeID = null,
    Object? rating = null,
    Object? chefToken = null,
    Object? chefID = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recipeID: null == recipeID
          ? _value.recipeID
          : recipeID // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      chefToken: null == chefToken
          ? _value.chefToken
          : chefToken // ignore: cast_nullable_to_non_nullable
              as String,
      chefID: null == chefID
          ? _value.chefID
          : chefID // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
          _$ReviewImpl value, $Res Function(_$ReviewImpl) then) =
      __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String review,
      DateTime time,
      String recipeID,
      double rating,
      String chefToken,
      String chefID});
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
      _$ReviewImpl _value, $Res Function(_$ReviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? review = null,
    Object? time = null,
    Object? recipeID = null,
    Object? rating = null,
    Object? chefToken = null,
    Object? chefID = null,
  }) {
    return _then(_$ReviewImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recipeID: null == recipeID
          ? _value.recipeID
          : recipeID // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      chefToken: null == chefToken
          ? _value.chefToken
          : chefToken // ignore: cast_nullable_to_non_nullable
              as String,
      chefID: null == chefID
          ? _value.chefID
          : chefID // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl(
      {required this.name,
      required this.review,
      required this.time,
      required this.recipeID,
      required this.rating,
      required this.chefToken,
      required this.chefID});

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final String name;
  @override
  final String review;
  @override
  final DateTime time;
  @override
  final String recipeID;
  @override
  final double rating;
  @override
  final String chefToken;
  @override
  final String chefID;

  @override
  String toString() {
    return 'Review(name: $name, review: $review, time: $time, recipeID: $recipeID, rating: $rating, chefToken: $chefToken, chefID: $chefID)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.review, review) || other.review == review) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.recipeID, recipeID) ||
                other.recipeID == recipeID) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.chefToken, chefToken) ||
                other.chefToken == chefToken) &&
            (identical(other.chefID, chefID) || other.chefID == chefID));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, review, time, recipeID, rating, chefToken, chefID);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(
      this,
    );
  }
}

abstract class _Review implements Review {
  const factory _Review(
      {required final String name,
      required final String review,
      required final DateTime time,
      required final String recipeID,
      required final double rating,
      required final String chefToken,
      required final String chefID}) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  String get name;
  @override
  String get review;
  @override
  DateTime get time;
  @override
  String get recipeID;
  @override
  double get rating;
  @override
  String get chefToken;
  @override
  String get chefID;
  @override
  @JsonKey(ignore: true)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
