import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

/// Central Vector & Modern Asset Registry for KaamFast
/// Provides crisp vector SVGs and curated high-resolution service imagery.
class AppVectorAssets {
  // --- Curated High-Definition Professional Service Photography ---
  static const String imgPlumber =
      'https://images.unsplash.com/photo-1581244277943-fe4a9c777189?w=600&auto=format&fit=crop&q=80';
  static const String imgElectrician =
      'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600&auto=format&fit=crop&q=80';
  static const String imgCarpenter =
      'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600&auto=format&fit=crop&q=80';
  static const String imgAcService =
      'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?w=600&auto=format&fit=crop&q=80';
  static const String imgCleaning =
      'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=600&auto=format&fit=crop&q=80';
  static const String imgPainter =
      'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=600&auto=format&fit=crop&q=80';
  static const String imgAppliance =
      'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600&auto=format&fit=crop&q=80';
  static const String imgMason =
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&auto=format&fit=crop&q=80';
  static const String imgGardener =
      'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=600&auto=format&fit=crop&q=80';
  static const String imgDriver =
      'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=600&auto=format&fit=crop&q=80';

  // --- Real Captain / Technician Avatars ---
  static const String avatarCaptain1 =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80'; // Ramesh Kumar
  static const String avatarCaptain2 =
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80'; // Amit Sharma
  static const String avatarCaptain3 =
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&auto=format&fit=crop&q=80'; // Vikram Singh

  // --- Hero Promo Banners ---
  static const String bannerExpressDispatch =
      'https://images.unsplash.com/photo-1616401784845-180882ba9ba8?w=900&auto=format&fit=crop&q=80';
  static const String bannerZeroEscrow =
      'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=900&auto=format&fit=crop&q=80';
  static const String bannerAcSummer =
      'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=900&auto=format&fit=crop&q=80';
  static const String bannerCarpentry =
      'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=900&auto=format&fit=crop&q=80';

  /// Get service photo by slug
  static String getServiceImage(String slug) {
    if (slug.contains('plumb')) return imgPlumber;
    if (slug.contains('electr')) return imgElectrician;
    if (slug.contains('carpen')) return imgCarpenter;
    if (slug.contains('clean') || slug.contains('maid')) return imgCleaning;
    if (slug.contains('paint')) return imgPainter;
    if (slug.contains('ac')) return imgAcService;
    if (slug.contains('appliance')) return imgAppliance;
    if (slug.contains('mason')) return imgMason;
    if (slug.contains('garden')) return imgGardener;
    if (slug.contains('driv')) return imgDriver;
    return imgPlumber;
  }

  // --- Modern Clean SVG Vector Icons (Direct Vector Code) ---
  static const String svgBolt = '''
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M13 2L3 14H12L11 22L21 10H12L13 2Z" fill="url(#bolt_grad)" stroke="#FF7A1A" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  <defs>
    <linearGradient id="bolt_grad" x1="3" y1="2" x2="21" y2="22" gradientUnits="userSpaceOnUse">
      <stop stop-color="#FF9E59"/>
      <stop offset="1" stop-color="#FF7A1A"/>
    </linearGradient>
  </defs>
</svg>
''';

  static const String svgShieldCheck = '''
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 22C12 22 20 18 20 12V5L12 2L4 5V12C4 18 12 22 12 22Z" fill="#10B981" fill-opacity="0.15" stroke="#10B981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12L11 14L15 10" stroke="#10B981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  static const String svgVoiceWave = '''
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="10" width="3" height="4" rx="1.5" fill="#FF7A1A"/>
  <rect x="7" y="6" width="3" height="12" rx="1.5" fill="#FF7A1A"/>
  <rect x="12" y="3" width="3" height="18" rx="1.5" fill="#FF9E59"/>
  <rect x="17" y="7" width="3" height="10" rx="1.5" fill="#FF7A1A"/>
  <rect x="22" y="10" width="3" height="4" rx="1.5" fill="#FF7A1A"/>
</svg>
''';

  static const String svgRadar = '''
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="10" stroke="#10B981" stroke-width="1.8" stroke-dasharray="2 2" stroke-opacity="0.6"/>
  <circle cx="12" cy="12" r="6" stroke="#10B981" stroke-width="1.8" stroke-opacity="0.8"/>
  <circle cx="12" cy="12" r="2.5" fill="#10B981"/>
  <path d="M12 12L19 5" stroke="#10B981" stroke-width="2" stroke-linecap="round"/>
</svg>
''';

  static const String svgGiftReferral = '''
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="8" width="18" height="4" rx="1" fill="#FF7A1A" fill-opacity="0.2" stroke="#FF7A1A" stroke-width="1.5"/>
  <path d="M12 8V21M3 12H21M5 12V20C5 20.5523 5.44772 21 6 21H18C18.5523 21 19 20.5523 19 20V12" stroke="#FF7A1A" stroke-width="1.5" stroke-linecap="round"/>
  <path d="M8 8C6.5 8 5 6.5 6.5 4.5C8 2.5 12 7 12 8C12 7 16 2.5 17.5 4.5C19 6.5 17.5 8 16 8" stroke="#FF9E59" stroke-width="1.5" stroke-linecap="round"/>
</svg>
''';

  static const String svgZeroCommission = '''
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="10" stroke="#10B981" stroke-width="1.5"/>
  <path d="M9 9L15 15M15 9L9 15" stroke="#10B981" stroke-width="2" stroke-linecap="round"/>
</svg>
''';

  /// Helper to render SVG string widget safely
  static Widget svg(String rawSvg, {double? width, double? height, Color? color}) {
    return SvgPicture.string(
      rawSvg,
      width: width,
      height: height,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  /// Helper to render cached network image with sleek dark shimmer placeholder & error fallback
  static Widget networkImage({
    required String url,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? fallbackIcon,
  }) {
    final imageWidget = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, _) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: darkSurface,
          borderRadius: borderRadius,
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: primaryLight),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: darkSurface,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: fallbackIcon ?? const Icon(Icons.handyman_rounded, color: primary, size: 24),
        ),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }
    return imageWidget;
  }
}
