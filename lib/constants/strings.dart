/// Application-wide string constants.
///
/// Centralizes magic strings to reduce duplication and typo risk.
class AppStrings {
  AppStrings._();

  // Firestore collection names
  static const String conversionsCollection = 'conversions';
  static const String premiumUsersCollection = 'premiumUsers';

  // Stripe configuration
  static const String stripePriceId = 'price_1PtWVREdYSPMuFSGos2c0D1G';
  static const double subscriptionAmount = 4.99;
  static const String subscriptionCurrency = 'USD';
  static const String subscriptionLabel = r'Subscribe $4.99 monthly';
  static const String merchantDisplayName = 'Text Extractor Pro Plan';

  // Firebase Storage paths
  static const String conversionsStoragePath = 'conversions';

  // App metadata
  static const String appTitle = 'ML Text Recognition';
}
