import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../providers/premium_provider.dart';
import '../services/ad_service.dart';

class AdBannerSlot extends StatefulWidget {
  final EdgeInsetsGeometry margin;

  const AdBannerSlot({
    super.key,
    this.margin = const EdgeInsets.only(top: 12),
  });

  @override
  State<AdBannerSlot> createState() => _AdBannerSlotState();
}

class _AdBannerSlotState extends State<AdBannerSlot> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final premium = Provider.of<PremiumProvider>(context);
    final adService = Provider.of<AdService>(context, listen: false);

    if (premium.isPremium ||
        AdService.supportsDesktopAdPreview ||
        !adService.canRequestAds) {
      _disposeBanner();
      return;
    }

    _loadBannerIfNeeded();
  }

  void _loadBannerIfNeeded() {
    if (_bannerAd != null || _isLoading) return;

    _isLoading = true;
    final banner = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || ad != _bannerAd) {
            ad.dispose();
            return;
          }

          setState(() {
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();

          if (!mounted || ad != _bannerAd) return;
          setState(() {
            _bannerAd = null;
            _isLoaded = false;
            _isLoading = false;
          });
        },
      ),
    );

    _bannerAd = banner;
    banner.load();
  }

  void _disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoaded = false;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context);
    final adService = Provider.of<AdService>(context, listen: false);
    final banner = _bannerAd;

    if (premium.isPremium) {
      return const SizedBox.shrink();
    }

    if (AdService.supportsDesktopAdPreview) {
      return Container(
        margin: widget.margin,
        alignment: Alignment.center,
        child: const _DesktopAdPreviewBanner(),
      );
    }

    if (!adService.canRequestAds) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || banner == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: widget.margin,
      alignment: Alignment.center,
      child: SizedBox(
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      ),
    );
  }

  @override
  void dispose() {
    _disposeBanner();
    super.dispose();
  }
}

class _DesktopAdPreviewBanner extends StatelessWidget {
  const _DesktopAdPreviewBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF262C3F), Color(0xFF463B23)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFFC857).withValues(alpha: 0.72),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_rounded, color: Color(0xFFFFC857), size: 18),
          SizedBox(width: 8),
          Text(
            'PUBLICITE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          SizedBox(width: 10),
          Text('Tchin sponsor', style: TextStyle(color: Color(0xFFD8DCE8))),
        ],
      ),
    );
  }
}
