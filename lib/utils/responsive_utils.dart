import 'package:flutter/material.dart';

class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  // Screen dimensions
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  // Device type checks
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktop => screenWidth >= 900;

  // Aspect ratio checks
  double get aspectRatio => screenHeight / screenWidth;
  bool get isTallScreen => aspectRatio > 2.0; // 18:9 or taller (e.g., 20:9)
  bool get isStandardScreen => aspectRatio >= 1.6 && aspectRatio <= 2.0; // 16:9 to 18:9

  // Responsive sizing
  double wp(double percentage) => screenWidth * percentage / 100;
  double hp(double percentage) => screenHeight * percentage / 100;

  // Text scaling
  double sp(double size) {
    final scaleFactor = screenWidth / 411; // 411 is base width (Android standard)
    return size * scaleFactor;
  }

  // Padding/margin helpers
  EdgeInsets get defaultPadding => EdgeInsets.all(wp(2.5));
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: wp(4));
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: hp(2));

  // Grid columns based on screen size
  int get gridColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }

  // Auto-calculated card aspect ratio based on screen dimensions
  // This ensures cards look good on any screen without hardcoding
  double get cardAspectRatio {
    // Calculate based on available space and aspect ratio
    // Taller screens get slightly taller cards for better proportions
    if (aspectRatio >= 2.22) return 1.3;  // Very tall screens (20:9) - 1080x2400
    if (aspectRatio >= 2.15) return 1.35; // Tall screens (19.5:9) - 1080x2340
    if (aspectRatio >= 1.9) return 1.4;   // Tall screens (19:9)
    return 1.5;                            // Standard screens (16:9, 18:9)
  }

  // Spacing
  double get smallSpacing => wp(2);
  double get mediumSpacing => wp(4);
  double get largeSpacing => wp(6);
}
