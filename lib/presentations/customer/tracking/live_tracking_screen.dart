import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/model/booking/booking_model.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/animated_radar.dart';
import 'package:kaam_fast/utils/custom_widgets/app_vector_assets.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/interactive_map_canvas.dart';
import 'package:kaam_fast/utils/custom_widgets/status_badge.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class LiveTrackingScreen extends StatefulWidget {
  final String bookingId;
  final BookingModel? initialBooking;

  const LiveTrackingScreen({
    super.key,
    required this.bookingId,
    this.initialBooking,
  });

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  String _status = 'searching'; // searching -> accepted -> en_route -> arrived -> started -> completed
  String? _arrivalCode;
  bool _isLoadingCode = false;

  @override
  void initState() {
    super.initState();
    // Simulate real-time dispatch transition for demo
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _status = 'en_route');
    });
  }

  Future<void> _fetchArrivalCode() async {
    setState(() => _isLoadingCode = true);
    try {
      final res = await DioClient().post(AppUrls.customerArrivalCode(widget.bookingId));
      if (res['data']?['code'] != null) {
        setState(() => _arrivalCode = res['data']['code'].toString());
      } else {
        setState(() => _arrivalCode = '4829'); // Fallback demo code
      }
    } catch (_) {
      setState(() => _arrivalCode = '4829');
    } finally {
      if (mounted) setState(() => _isLoadingCode = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _status == 'searching';

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: Text(
          'Live Tracking',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: kWhite),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: 20),
          onPressed: () => context.go(AppRoutes.customerHome),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: StatusBadge(status: _status)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              if (isSearching) ...[
                60.sBH,
                const AnimatedRadarWidget(
                  size: 240,
                  color: primary,
                  centerChild: Icon(Icons.search_rounded, color: kWhite, size: 36),
                ),
                36.sBH,
                Text(
                  'Matching with Nearby Workers...',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kWhite,
                  ),
                ).animate().fadeIn(),
                10.sBH,
                Text(
                  'Broadcasting job offer to active workers within 3 km.\nFirst worker to accept will be dispatched.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontSize: 14, color: fontGrey, height: 1.4),
                ).animate().fadeIn(delay: 200.ms),
                40.sBH,
                CustomButton(
                  text: 'Cancel Request',
                  isOutlined: true,
                  borderColor: kRed,
                  textColor: kRed,
                  onPressed: () => context.pop(),
                ),
              ] else ...[
                // Live Vector Map Tracking Frame
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: primary.withValues(alpha: 0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        const InteractiveMapCanvas(
                          showTechnicians: false,
                          showTrackingRoute: true,
                          showControls: false,
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: darkBg.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primary),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.navigation_rounded, color: primary, size: 14),
                                6.sBW,
                                Text(
                                  'En-Route • Arriving in 11 mins',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
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
                ).animate().fadeIn(duration: 400.ms),

                16.sBH,

                // Worker Matched Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141A26),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: primary.withValues(alpha: 0.4), width: 1.3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: primary.withValues(alpha: 0.1),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          AppVectorAssets.networkImage(
                            url: AppVectorAssets.avatarCaptain1,
                            width: 60,
                            height: 60,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: kBlack,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.verified_rounded, color: kGreen, size: 16),
                            ),
                          ),
                        ],
                      ),
                      16.sBW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Ramesh Kumar',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: kWhite,
                                  ),
                                ),
                                6.sBW,
                                const Icon(Icons.verified_rounded, color: kGreen, size: 18),
                              ],
                            ),
                            4.sBH,
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: primary, size: 16),
                                4.sBW,
                                Text(
                                  '4.9 (124 jobs)',
                                  style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Call button
                      Container(
                        decoration: BoxDecoration(
                          color: kGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.phone_rounded, color: kGreen, size: 22),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                24.sBH,

                // 4-Digit Arrival Code Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.pin_rounded, color: primary, size: 20),
                          8.sBW,
                          Text(
                            'ARRIVAL VERIFICATION CODE',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: primary,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      12.sBH,
                      Text(
                        'Read out this code to the worker when they arrive to verify their identity and start the job.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
                      ),
                      20.sBH,
                      if (_arrivalCode != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: primary, width: 2),
                          ),
                          child: Text(
                            _arrivalCode!,
                            style: GoogleFonts.outfit(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: primary,
                              letterSpacing: 10,
                            ),
                          ),
                        ).animate().scale(curve: Curves.elasticOut)
                      else
                        CustomButton(
                          text: 'Generate Arrival OTP',
                          isLoading: _isLoadingCode,
                          height: 46,
                          onPressed: _fetchArrivalCode,
                        ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),

                24.sBH,

                // Direct Worker Payment QR Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: darkSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: darkBorder),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.qr_code_scanner_rounded, color: kGreen, size: 22),
                          10.sBW,
                          Text(
                            'Direct Payment to Worker',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: kWhite,
                            ),
                          ),
                        ],
                      ),
                      10.sBH,
                      Text(
                        'KaamFast never holds money. Pay worker directly in cash or via Scan-to-Pay UPI QR once the work is completed.',
                        style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
