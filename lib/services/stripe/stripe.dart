import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:langvify/constants/strings.dart';
import 'package:langvify/services/stripe/service.dart';
import 'package:langvify/services/stripe/stripe_storage.dart';

/// Handles the complete Stripe payment and subscription flow.
///
/// WARNING: In production, move sensitive Stripe operations to a
/// secure backend (Cloud Functions). Client-side subscription
/// creation is NOT recommended for production use.
class StripePaymentService {
  /// Initiates the full subscription flow: create customer → setup intent →
  /// collect card → create subscription → store details.
  Future<void> init({
    required String name,
    required String email,
  }) async {
    debugPrint('Starting Stripe subscription flow');

    // 1. Create a new customer
    final customer = await _createCustomer(name: name, email: email);
    if (customer == null || customer['id'] == null) {
      throw Exception('Failed to create customer.');
    }

    // 2. Create a setup intent
    final setupIntent = await _createSetupIntent(customer['id']);
    if (setupIntent == null || setupIntent['client_secret'] == null) {
      throw Exception('Failed to create setup intent.');
    }

    // 3. Collect card details via Stripe Payment Sheet
    await _presentPaymentSheet(
      customer['id'],
      setupIntent['client_secret'],
    );

    // 4. Retrieve the customer's payment methods
    final paymentMethods = await _getCustomerPaymentMethods(customer['id']);
    if (paymentMethods == null || paymentMethods['data'].isEmpty) {
      throw Exception('Failed to get customer payment methods.');
    }

    // 5. Create the subscription
    final subscription = await _createSubscription(
      customer['id'],
      paymentMethods['data'][0]['id'],
    );
    if (subscription == null || subscription['id'] == null) {
      throw Exception('Failed to create subscription.');
    }

    // 6. Persist subscription details to Firestore
    await StripeStorage().storeSubscriptionDetails(
      customerId: customer['id'],
      email: email,
      userName: name,
      subscriptionId: subscription['id'],
      paymentStatus: 'active',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      planId: AppStrings.stripePriceId,
      amountPaid: AppStrings.subscriptionAmount,
      currency: AppStrings.subscriptionCurrency,
      paymentMethod: 'Credit Card',
    );
  }

  Future<Map<String, dynamic>?> _createCustomer({
    required String name,
    required String email,
  }) {
    return apiService(
      endpoint: 'customers',
      requestMethod: ApiServiceMethodType.post,
      requestBody: {
        'name': name,
        'email': email,
        'description': AppStrings.merchantDisplayName,
      },
    );
  }

  Future<Map<String, dynamic>?> _createSetupIntent(String customerId) {
    return apiService(
      requestMethod: ApiServiceMethodType.post,
      endpoint: 'setup_intents',
      requestBody: {
        'customer': customerId,
        'automatic_payment_methods[enabled]': 'true',
      },
    );
  }

  Future<void> _presentPaymentSheet(
    String customerId,
    String clientSecret,
  ) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        primaryButtonLabel: AppStrings.subscriptionLabel,
        style: ThemeMode.light,
        merchantDisplayName: AppStrings.merchantDisplayName,
        customerId: customerId,
        setupIntentClientSecret: clientSecret,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

  Future<Map<String, dynamic>?> _getCustomerPaymentMethods(
    String customerId,
  ) {
    return apiService(
      endpoint: 'customers/$customerId/payment_methods',
      requestMethod: ApiServiceMethodType.get,
    );
  }

  Future<Map<String, dynamic>?> _createSubscription(
    String customerId,
    String paymentId,
  ) {
    return apiService(
      endpoint: 'subscriptions',
      requestMethod: ApiServiceMethodType.post,
      requestBody: {
        'customer': customerId,
        'items[0][price]': AppStrings.stripePriceId,
        'default_payment_method': paymentId,
      },
    );
  }
}
