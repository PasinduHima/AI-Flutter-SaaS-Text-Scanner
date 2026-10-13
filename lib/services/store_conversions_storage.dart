import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:langvify/constants/strings.dart';

/// Handles image uploads to Firebase Storage for conversion records.
class StoreConversionsStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads an image file and returns its download URL.
  ///
  /// Images are stored under `conversions/<userId>/<timestamp>`.
  Future<String> uploadImage({
    required File postImage,
    required String userId,
  }) async {
    final ref = _storage
        .ref()
        .child(AppStrings.conversionsStoragePath)
        .child('$userId/${DateTime.now().millisecondsSinceEpoch}');

    try {
      final task = ref.putFile(
        postImage,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final snapshot = await task;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
  }
}
