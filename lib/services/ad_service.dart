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
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFF171923),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFFFC857), width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topRight,
                          radius: 1.05,
                          colors: [
                            Color(0xFF73522A),
                            Color(0xFF282D43),
                            Color(0xFF11131B),
                          ],
                          stops: [0, 0.52, 1],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.14),
                                ),
                              ),
                              child: const Text(
                                'Annonce',
                                style: TextStyle(
                                  color: Color(0xFFD8DCE8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Fermer',
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              icon: const Icon(Icons.close_rounded, size: 20),
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    Colors.black.withValues(alpha: 0.28),
                                foregroundColor: Colors.white,
                                fixedSize: const Size(38, 38),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 230,
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.13),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -26,
                                top: -22,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFFFFC857,
                                    ).withValues(alpha: 0.16),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: 0,
                                child: Transform.rotate(
                                  angle: -0.08,
                                  child: Container(
                                    width: 116,
                                    height: 156,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFFF3C4),
                                          Color(0xFFFFC857),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.28,
                                          ),
                                          blurRadius: 22,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_bar_rounded,
                                          size: 38,
                                          color: Color(0xFF161820),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'AD',
                                          style: TextStyle(
                                            color: Color(0xFF161820),
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.asset(
                                      'assets/app_icon.png',
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'Soiree en mode Tchin',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const SizedBox(
                                    width: 300,
                                    child: Text(
                                      'Exemple de publicite interstitielle plein ecran pour tester le rendu sur PC.',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFFD8DCE8),
                                        fontSize: 14,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Row(
                          children: [
                            Icon(
                              Icons.desktop_windows_rounded,
                              color: Color(0xFFFFC857),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Preview locale Windows - les vraies pubs AdMob restent sur Android/iOS.',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFFC9CDD8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.22),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Ignorer',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFC857),
                                  foregroundColor: const Color(0xFF161820),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Continuer',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
