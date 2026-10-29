import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/services/storage_service.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(BuildContext context, String role) async {
    await StorageService().setRole(role);
    if (context.mounted) {
      context.push(AppRoutes.login, extra: {'role': role});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.sBH,
              // Top Brand
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: amberGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bolt_rounded, color: kWhite, size: 24),
                  ),
                  12.sBW,
                  Text(
                    'KaamFast',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: kWhite,
                    ),
                  ),
                ],
              ).animate().fadeIn().slideX(begin: -0.2, end: 0),

              28.sBH,

              Text(
                'How do you want to\nuse KaamFast today?',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: kWhite,
                  height: 1.25,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

              12.sBH,

              Text(
                'Select your mode to continue. You can always switch modes from your profile later.',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: fontGrey,
                  height: 1.4,
                ),
              ).animate().fadeIn(delay: 300.ms),

              40.sBH,

              // Customer Card
              _RoleCard(
                title: 'Need a Service',
                subtitle: 'Book verified plumbers, electricians, drivers & more in 60 seconds.',
                icon: Icons.person_search_rounded,
                badgeText: 'CUSTOMER MODE',
                badgeColor: primary,
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E1C0C), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderColor: primary.withValues(alpha: 0.4),
                onTap: () => _selectRole(context, 'customer'),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

              20.sBH,

              // Worker Partner Card
              _RoleCard(
                title: 'Work & Earn Fast',
                subtitle: 'Get nearby jobs within radius. 45-second accept race with instant direct pay.',
                icon: Icons.handyman_rounded,
                badgeText: 'PARTNER MODE',
                badgeColor: kGreen,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D281E), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderColor: kGreen.withValues(alpha: 0.4),
                onTap: () => _selectRole(context, 'worker'),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

              const Spacer(),

              Center(
                child: Text(
                  'By continuing, you agree to KaamFast Policies & Terms',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: fontGrey.withValues(alpha: 0.8),
                  ),
                ),
              ),
              12.sBH,
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String badgeText;
  final Color badgeColor;
  final Gradient gradient;
  final Color borderColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badgeText,
    required this.badgeColor,
    required this.gradient,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: badgeColor, size: 30),
            ),
            16.sBW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  8.sBH,
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kWhite,
                    ),
                  ),
                  6.sBH,
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: fontGrey,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, color: fontGrey, size: 16),
          ],
        ),
      ),
    );
  }
}
