import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chef.freezed.dart';
part 'chef.g.dart';

@freezed
class Chef with _$Chef {
  const factory Chef({
    required String name,
    required String email,
    required String id,
    required List<String> followers,
    required List<String> token,
  }) = _Chef;

  factory Chef.fromJson(Map<String, dynamic> json) => _$ChefFromJson(json);

  factory Chef.initial() => const Chef(
        name: '',
        email: '',
        id: '',
        followers: [],
        token: [],
      );
}
