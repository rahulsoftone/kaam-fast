import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status.toLowerCase()) {
      case 'searching':
        bg = kYellow.withValues(alpha: 0.15);
        fg = kYellow;
        label = 'Searching';
        break;
      case 'accepted':
      case 'en_route':
        bg = kBlue.withValues(alpha: 0.15);
        fg = kBlue;
        label = status == 'en_route' ? 'En Route' : 'Accepted';
        break;
      case 'arrived':
        bg = primary.withValues(alpha: 0.15);
        fg = primary;
        label = 'Arrived';
        break;
      case 'started':
        bg = secondary.withValues(alpha: 0.15);
        fg = secondary;
        label = 'In Progress';
        break;
      case 'completed':
      case 'paid':
        bg = kGreen.withValues(alpha: 0.15);
        fg = kGreen;
        label = 'Completed';
        break;
      case 'cancelled':
      case 'failed':
        bg = kRed.withValues(alpha: 0.15);
        fg = kRed;
        label = 'Cancelled';
        break;
      case 'on_duty':
        bg = kGreen.withValues(alpha: 0.15);
        fg = kGreen;
        label = 'ONLINE';
        break;
      case 'off_duty':
        bg = fontGrey.withValues(alpha: 0.15);
        fg = fontGrey;
        label = 'OFFLINE';
        break;
      default:
        bg = fontGrey.withValues(alpha: 0.15);
        fg = fontGrey;
        label = status.toUpperCase();
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fg,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
