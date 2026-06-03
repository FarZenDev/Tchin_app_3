import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  bool _isInitialized = false;
  bool _isSupported = supportsAdsPlatform;
  DateTime? _lastInterstitialShownAt;

  static const Duration _minimumInterstitialInterval = Duration(minutes: 2);

  // Production banner IDs are configured. Interstitial IDs stay on Google test
  // IDs until the Android and iOS interstitial ad units are created in AdMob.
  static const String _androidBannerAdUnitId =
      'ca-app-pub-5050258385752502/4285930219';
  static const String _iosBannerAdUnitId =
      'ca-app-pub-5050258385752502/4533342221';
  static const String _androidInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/4411468910';

  static bool get supportsAdsPlatform {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  bool get isSupported => _isSupported;
  bool get isInitialized => _isInitialized;
  bool get canRequestAds => _isSupported && _isInitialized;

  static String get bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidBannerAdUnitId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosBannerAdUnitId;
    }
    return _androidBannerAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidInterstitialAdUnitId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosInterstitialAdUnitId;
    }
    return _androidInterstitialAdUnitId;
  }

  Future<void> initialize() async {
    if (!supportsAdsPlatform) {
      _isSupported = false;
      debugPrint('AdService: Ads not supported on this platform');
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      loadInterstitialAd();
    } catch (e) {
      debugPrint('AdService initialization error: $e');
      _isSupported = false;
    }
  }

  void loadInterstitialAd() {
    if (!canRequestAds || _isInterstitialLoading || _interstitialAd != null) {
      return;
    }

    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  Future<bool> showInterstitialIfReady({bool isPremium = false}) async {
    if (isPremium) return false;

    if (!canRequestAds) {
      debugPrint('Ads not supported on this platform');
      return false;
    }

    final lastShownAt = _lastInterstitialShownAt;
    if (lastShownAt != null &&
        DateTime.now().difference(lastShownAt) < _minimumInterstitialInterval) {
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      debugPrint('Ad not ready yet');
      loadInterstitialAd();
      return false;
    }

    _interstitialAd = null;
    _lastInterstitialShownAt = DateTime.now();

    final dismissedCompleter = Completer<void>();
    void completeOnce() {
      if (!dismissedCompleter.isCompleted) {
        dismissedCompleter.complete();
      }
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
        completeOnce();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('InterstitialAd failed to show: $error');
        ad.dispose();
        loadInterstitialAd();
        completeOnce();
      },
    );

    try {
      await ad.show();
      await dismissedCompleter.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () {},
      );
      return true;
    } catch (e) {
      debugPrint('InterstitialAd show error: $e');
      ad.dispose();
      loadInterstitialAd();
      return false;
    }
  }

  Future<void> showAdIfReady({bool isPremium = false}) async {
    await showInterstitialIfReady(isPremium: isPremium);
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
