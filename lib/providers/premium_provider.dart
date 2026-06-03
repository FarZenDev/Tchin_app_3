import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumProvider extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;

  bool _isPremium = false;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Product ID - IMPORTANT: Replace with your actual product ID from Google Play Console / App Store Connect
  static const String premiumProductId = 'tchin_premium_subscription';

  bool get isPremium => _isPremium;
  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;

  PremiumProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // In-App Purchase is not supported on web platform
    // Enable demo mode on web where all features are available
    if (kIsWeb) {
      _isAvailable = false;
      _isPremium = true; // Demo mode: all features unlocked on web
      debugPrint('PremiumProvider: Running in demo mode on web platform');
      notifyListeners();
      return;
    }

    try {
      // Check if IAP is available
      _isAvailable = await _iap.isAvailable();

      if (_isAvailable) {
        // Listen to purchase updates
        _subscription = _iap.purchaseStream.listen(
          _onPurchaseUpdate,
          onDone: () => _subscription?.cancel(),
          onError: (error) => debugPrint('Purchase stream error: $error'),
        );

        // Load products
        await _loadProducts();

        // Check existing premium status
        await checkPremiumStatus();

        // Restore previous purchases
        await _restorePurchases();
      }
    } catch (e) {
      debugPrint('PremiumProvider initialization error: $e');
      _isAvailable = false;
    }

    notifyListeners();
  }

  Future<void> _loadProducts() async {
    final ProductDetailsResponse response =
        await _iap.queryProductDetails({premiumProductId});

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    _products = response.productDetails;
    notifyListeners();
  }

  Future<void> checkPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('is_premium') ?? false;
    notifyListeners();
  }

  Future<void> _setPremiumStatus(bool status) async {
    _isPremium = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', status);
    notifyListeners();
  }

  Future<void> purchasePremium() async {
    if (_products.isEmpty) {
      debugPrint('No products available');
      return;
    }

    final ProductDetails product = _products.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Purchase error: $e');
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('Restore error: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Verify purchase (in production, verify with your backend)
        _setPremiumStatus(true);
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> restorePurchases() async {
    await _restorePurchases();
  }

  // DEBUG ONLY: Toggle premium status manually
  Future<void> togglePremiumDebug() async {
    await _setPremiumStatus(!_isPremium);
    debugPrint('PremiumProvider: Debug toggle - isPremium: $_isPremium');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
