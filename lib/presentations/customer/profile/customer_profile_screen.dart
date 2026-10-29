import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/services/storage_service.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  String _phone = '+919876543210';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final phone = await StorageService().getPhone();
    if (phone != null && phone.isNotEmpty && mounted) {
      setState(() => _phone = phone);
    }
  }

  Future<void> _logout() async {
    await StorageService().clearSession();
    if (mounted) {
      context.go(AppRoutes.roleSelect);
    }
  }

  Future<void> _switchToPartner() async {
    await StorageService().setRole('worker');
    if (mounted) {
      context.go(AppRoutes.workerDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: Text(
          'My Account & Settings',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_outlined, color: fontGrey),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // User Avatar & Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: darkBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: amberGradient,
                    ),
                    child: const Icon(Icons.person_rounded, color: kWhite, size: 32),
                  ),
                  16.sBW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KaamFast Customer',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: kWhite,
                          ),
                        ),
                        4.sBH,
                        Text(
                          _phone,
                          style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            16.sBH,

            // Refer & Earn Promo Card
            InkWell(
              onTap: () => context.push(AppRoutes.referEarn),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A1608), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.card_giftcard_rounded, color: primary, size: 24),
                    ),
                    14.sBW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Refer & Earn ₹50 Cash',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: kWhite,
                            ),
                          ),
                          2.sBH,
                          Text(
                            'Share your code and get ₹50 on friend’s 1st job.',
                            style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: primary, size: 14),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),

            20.sBH,

            // Settings Section
            _menuSectionTitle('Safety & Legal'),
            _menuItem(
              icon: Icons.emergency_rounded,
              title: 'Emergency SOS Response',
              subtitle: 'Police 112, Women 1091 & Rapid SOS',
              iconColor: kRed,
              onTap: () => context.push(AppRoutes.sosEmergency),
            ),
            _menuItem(
              icon: Icons.shield_outlined,
              title: 'Policies & Grievance Redressal',
              subtitle: 'IT Rules 2021 Officer & Zero-Escrow Policy',
              iconColor: accentBlue,
              onTap: () => context.push(AppRoutes.customerPolicies),
            ),

            16.sBH,

            _menuSectionTitle('App Preferences'),
            _menuItem(
              icon: Icons.translate_rounded,
              title: 'Language / भाषा',
              subtitle: 'English / हिंदी',
              iconColor: Colors.purpleAccent,
              onTap: () => context.push(AppRoutes.customerPolicies),
            ),
            _menuItem(
              icon: Icons.handyman_rounded,
              title: 'Switch to Partner Captain App',
              subtitle: 'Earn money by taking nearby service jobs',
              iconColor: kGreen,
              onTap: _switchToPartner,
            ),

            24.sBH,

            // Logout Button
            InkWell(
              onTap: _logout,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: darkBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded, color: kRed, size: 18),
                    8.sBW,
                    Text(
                      'Logout from Customer Mode',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            20.sBH,
          ],
        ),
      ),
    );
  }

  Widget _menuSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: fontGrey,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: darkBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                14.sBW,
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
                      2.sBH,
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(fontSize: 11, color: fontGrey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: fontGrey, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
