import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  bool _isInitialized = false;
  bool _isSupported = supportsAdsPlatform;
  DateTime? _lastInterstitialShownAt;

  static const Duration _minimumInterstitialInterval = Duration(minutes: 2);

  // Production AdMob IDs configured for Android and iOS.
  static const String _androidBannerAdUnitId =
      'ca-app-pub-5050258385752502/4285930219';
  static const String _iosBannerAdUnitId =
      'ca-app-pub-5050258385752502/4533342221';
  static const String _androidInterstitialAdUnitId =
      'ca-app-pub-5050258385752502/5184764678';
  static const String _iosInterstitialAdUnitId =
      'ca-app-pub-5050258385752502/1437091359';

  static bool get supportsAdsPlatform {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  static bool get supportsDesktopAdPreview {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux);
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

  Future<bool> showInterstitialIfReady({
    bool isPremium = false,
    BuildContext? context,
  }) async {
    if (isPremium) return false;
    if (supportsDesktopAdPreview) {
      return _showDesktopInterstitialPreview(context);
    }

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

  Future<bool> _showDesktopInterstitialPreview(BuildContext? context) async {
    if (context == null) return false;

    final lastShownAt = _lastInterstitialShownAt;
    if (lastShownAt != null &&
        DateTime.now().difference(lastShownAt) < _minimumInterstitialInterval) {
      return false;
    }

    _lastInterstitialShownAt = DateTime.now();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF171923),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFFC857), width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2A2F45), Color(0xFF473C24)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('TCHIN', style: TextStyle(fontSize: 28)),
                        SizedBox(height: 8),
                        Text(
                          'PUBLICITE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Emplacement interstitiel PC',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Apercu local pour tester le timing des pubs sur Windows.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFC9CDD8), fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC857),
                        foregroundColor: const Color(0xFF1B1B1F),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Continuer',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return true;
  }

  Future<void> showAdIfReady({bool isPremium = false}) async {
    await showInterstitialIfReady(isPremium: isPremium);
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
