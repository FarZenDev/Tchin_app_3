import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  bool _isSupported = true;
  
  // Test Ad Unit IDs - IMPORTANT: Replace with your real Ad Unit IDs before publishing
  static const String _androidAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String _iosAdUnitId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID
  
  static String get adUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidAdUnitId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosAdUnitId;
    }
    return _androidAdUnitId;
  }
  
  Future<void> initialize() async {
    // Google Mobile Ads is only supported on Android and iOS
    if (kIsWeb || (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS)) {
      _isSupported = false;
      debugPrint('AdService: Ads not supported on this platform');
      return;
    }
    
    try {
      await MobileAds.instance.initialize();
      loadInterstitialAd();
    } catch (e) {
      debugPrint('AdService initialization error: $e');
      _isSupported = false;
    }
  }
  
  void loadInterstitialAd() {
    if (!_isSupported) return;
    
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          
          // Set callbacks
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdLoaded = false;
              // Preload next ad
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Ad failed to show: $error');
              ad.dispose();
              _isAdLoaded = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }
  
  Future<void> showAdIfReady() async {
    if (!_isSupported) {
      debugPrint('Ads not supported on this platform');
      return;
    }
    
    if (_isAdLoaded && _interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialAd = null;
      _isAdLoaded = false;
    } else {
      debugPrint('Ad not ready yet');
    }
  }
  
  void dispose() {
    _interstitialAd?.dispose();
  }
}
