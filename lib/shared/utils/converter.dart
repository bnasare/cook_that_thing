import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts [Timestamp] to [DateTime] and vice versa
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  /// Converts [Timestamp] to [DateTime]
  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  /// Converts [DateTime] to [Timestamp]
  @override
  Timestamp toJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}
