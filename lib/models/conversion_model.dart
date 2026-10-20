import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionModel {
  final String userId;
  final String conversionData;
  final DateTime convertedDate;
  final String imageUrl;

  ConversionModel({
    required this.userId,
    required this.conversionData,
    required this.convertedDate,
    required this.imageUrl,
  });

  factory ConversionModel.fromMap(Map<String, dynamic> map) {
    return ConversionModel(
      userId: map['userId'] as String? ?? '',
      conversionData: map['conversionData'] as String? ?? '',
      convertedDate: _parseDate(map['convertedDate']),
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }

  /// Safely parses a Firestore date field that may be a [Timestamp],
  /// a [DateTime], or null.
  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'conversionData': conversionData,
      'convertedDate': convertedDate,
      'imageUrl': imageUrl,
    };
  }
}
