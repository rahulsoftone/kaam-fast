import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color textColor;
  final double height;
  final double? width;
  final double borderRadius;
  final IconData? icon;
  final bool isOutlined;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.gradient,
    this.textColor = kWhite,
    this.height = 54,
    this.width,
    this.borderRadius = 14,
    this.icon,
    this.isOutlined = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = isOutlined
        ? null
        : (gradient ?? (backgroundColor == null ? amberGradient : null));

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: effectiveGradient,
          color: isOutlined
              ? Colors.transparent
              : (effectiveGradient == null ? (backgroundColor ?? primary) : null),
          borderRadius: BorderRadius.circular(borderRadius),
          border: isOutlined
              ? Border.all(color: borderColor ?? primary, width: 1.5)
              : null,
          boxShadow: isOutlined || onPressed == null
              ? []
              : [
                  BoxShadow(
                    color: (backgroundColor ?? primary).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(kWhite),
                  ),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: isOutlined ? (borderColor ?? primary) : textColor, size: 17),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        text,
                        maxLines: 1,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isOutlined ? (borderColor ?? primary) : textColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
