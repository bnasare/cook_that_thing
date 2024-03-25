// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chef.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChefImpl _$$ChefImplFromJson(Map<String, dynamic> json) => _$ChefImpl(
      name: json['name'] as String,
      email: json['email'] as String,
      id: json['id'] as String,
      chefToken: json['chefToken'] as String,
      followers:
          (json['followers'] as List<dynamic>).map((e) => e as String).toList(),
      token: (json['token'] as List<dynamic>).map((e) => e as String).toList(),
      favorites:
          (json['favorites'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ChefImplToJson(_$ChefImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'id': instance.id,
      'chefToken': instance.chefToken,
      'followers': instance.followers,
      'token': instance.token,
      'favorites': instance.favorites,
    };
