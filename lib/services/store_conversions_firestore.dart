import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:langvify/constants/strings.dart';
import 'package:langvify/models/conversion_model.dart';
import 'package:langvify/services/store_conversions_storage.dart';

/// Manages OCR conversion records in Cloud Firestore.
class StoreConversionsFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stores a conversion record (text + image) for the current user.
  ///
  /// Automatically signs in anonymously if no user session exists.
  Future<void> storeConversionData({
    required String conversionData,
    required DateTime convertedDate,
    required File imageFile,
  }) async {
    try {
      // Ensure the user is authenticated (anonymous if needed)
      if (_auth.currentUser == null) {
        await _auth.signInAnonymously();
      }

      final userId = _auth.currentUser!.uid;

      // Upload image and get download URL
      final imageUrl = await StoreConversionsStorage().uploadImage(
        postImage: imageFile,
        userId: userId,
      );

      final newConversion = ConversionModel(
        userId: userId,
        conversionData: conversionData,
        convertedDate: convertedDate,
        imageUrl: imageUrl,
      );

      await _firestore
          .collection(AppStrings.conversionsCollection)
          .add(newConversion.toMap());
    } catch (e) {
      debugPrint('Error storing conversion data: $e');
      rethrow;
    }
  }

  /// Returns a real-time stream of conversion records for the current user.
  Stream<List<ConversionModel>> getUserConversions() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      debugPrint('No user signed in — returning empty conversion stream');
      return Stream.value([]);
    }

    return _firestore
        .collection(AppStrings.conversionsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ConversionModel.fromMap(doc.data());
      }).toList();
    });
  }
}
