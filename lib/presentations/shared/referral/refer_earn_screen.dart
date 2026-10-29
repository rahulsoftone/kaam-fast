import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/safe_navigation.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({super.key});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  final String _referralCode = 'FAST50PRO';

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Referral code FAST50PRO copied to clipboard!'),
        backgroundColor: kGreen,
      ),
    );
  }

  void _shareViaWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening WhatsApp with your invite link...'),
        backgroundColor: kGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: const AppBackButton(fallbackRoute: AppRoutes.customerHome),
        title: Text(
          'Refer & Earn ₹50',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Hero Illustration & Promo Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: primary.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.1),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: amberGradient,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: kWhite, size: 40),
                  ),
                  16.sBH,
                  Text(
                    'Give ₹50, Get ₹50',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: kWhite,
                    ),
                  ),
                  8.sBH,
                  Text(
                    'Invite your friends & neighbours to KaamFast. When they complete their first service, you both get ₹50 cash in your wallet!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(fontSize: 13, color: fontGrey, height: 1.4),
                  ),
                  20.sBH,

                  // Referral Code Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: darkBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primary, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR REFERRAL CODE',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: fontGrey,
                                letterSpacing: 0.8,
                              ),
                            ),
                            4.sBH,
                            Text(
                              _referralCode,
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: primary,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: _copyCode,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.copy_rounded, color: primary, size: 16),
                                6.sBW,
                                Text(
                                  'Copy',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),

            20.sBH,

            // Share Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'WhatsApp',
                    icon: Icons.chat_rounded,
                    gradient: emeraldGradient,
                    onPressed: _shareViaWhatsApp,
                  ),
                ),
                12.sBW,
                Expanded(
                  child: CustomButton(
                    text: 'Share Link',
                    icon: Icons.share_rounded,
                    isOutlined: true,
                    borderColor: primary,
                    onPressed: _copyCode,
                  ),
                ),
              ],
            ),

            28.sBH,

            // How it works 3-step section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'How It Works',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: kWhite),
              ),
            ),
            14.sBH,

            _stepItem(
              step: '1',
              title: 'Share your invite link',
              description: 'Send your code or link to friends, neighbours, or colleagues.',
              icon: Icons.share_location_rounded,
            ),
            12.sBH,
            _stepItem(
              step: '2',
              title: 'Friend books or takes first job',
              description: 'They register and complete their first service on the app.',
              icon: Icons.handyman_rounded,
            ),
            12.sBH,
            _stepItem(
              step: '3',
              title: 'Both get ₹50 directly',
              description: 'Instant ₹50 is added to both your KaamFast wallet balances.',
              icon: Icons.account_balance_wallet_rounded,
              isLast: true,
            ),

            28.sBH,

            // Referral Earnings Overview
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: darkBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statCol('Total Earned', '₹350', kGreen),
                  Container(width: 1, height: 40, color: darkBorder),
                  _statCol('Friends Joined', '7 Users', primary),
                  Container(width: 1, height: 40, color: darkBorder),
                  _statCol('Pending', '2 Jobs', fontGrey),
                ],
              ),
            ),

            20.sBH,
          ],
        ),
      ),
    );
  }

  Widget _statCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 11, color: fontGrey)),
        4.sBH,
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: color),
        ),
      ],
    );
  }

  Widget _stepItem({
    required String step,
    required String title,
    required String description,
    required IconData icon,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primary.withValues(alpha: 0.15),
            border: Border.all(color: primary),
          ),
          child: Center(
            child: Text(
              step,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: primary,
              ),
            ),
          ),
        ),
        16.sBW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kWhite,
                ),
              ),
              4.sBH,
              Text(
                description,
                style: GoogleFonts.outfit(fontSize: 12, color: fontGrey, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
