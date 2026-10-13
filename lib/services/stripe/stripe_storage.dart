import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:langvify/constants/strings.dart';

/// Manages Stripe subscription data persistence in Firestore.
class StripeStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stores subscription details to the [AppStrings.premiumUsersCollection] collection.
  Future<void> storeSubscriptionDetails({
    required String customerId,
    required String email,
    required String userName,
    required String subscriptionId,
    required String paymentStatus,
    required DateTime startDate,
    required DateTime endDate,
    required String planId,
    required double amountPaid,
    required String currency,
    String? paymentMethod,
    String? subscriptionType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? autoRenewal,
    String? cancellationReason,
    String? promoCode,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await _firestore
          .collection(AppStrings.premiumUsersCollection)
          .doc(customerId)
          .set({
        'userId': userId,
        'customerId': customerId,
        'email': email,
        'userName': userName,
        'subscriptionId': subscriptionId,
        'paymentStatus': paymentStatus,
        'startDate': startDate,
        'endDate': endDate,
        'planId': planId,
        'amountPaid': amountPaid,
        'currency': currency,
        'paymentMethod': paymentMethod ?? '',
        'subscriptionType': subscriptionType ?? 'premium',
        'createdAt': createdAt ?? DateTime.now(),
        'updatedAt': updatedAt ?? DateTime.now(),
        'autoRenewal': autoRenewal ?? true,
        'cancellationReason': cancellationReason ?? '',
        'promoCode': promoCode ?? '',
        'metadata': metadata ?? {},
      });

      debugPrint('Subscription details stored successfully');
    } catch (e) {
      debugPrint('Error storing subscription details: $e');
      rethrow;
    }
  }

  /// Checks if the current user has an active premium subscription.
  Future<bool> checkIfUserIsPremium() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final querySnapshot = await _firestore
          .collection(AppStrings.premiumUsersCollection)
          .where('userId', isEqualTo: user.uid)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking premium status: $e');
      return false;
    }
  }
}
