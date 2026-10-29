import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/presentations/customer/home/bloc/customer_home_bloc.dart';
import 'package:kaam_fast/presentations/customer/home/bloc/customer_home_event.dart';
import 'package:kaam_fast/presentations/customer/home/bloc/customer_home_state.dart';
import 'package:kaam_fast/presentations/customer/voice/voice_recording_modal.dart';
import 'package:kaam_fast/services/storage_service.dart';
import 'package:kaam_fast/utils/constants/app_constants.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/app_vector_assets.dart';
import 'package:kaam_fast/utils/custom_widgets/interactive_map_canvas.dart';
import 'package:kaam_fast/utils/custom_widgets/status_badge.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerHomeBloc>().add(LoadCustomerHomeEvent());
  }

  Future<void> _switchToWorkerMode() async {
    await StorageService().setRole('worker');
    if (mounted) {
      context.go(AppRoutes.workerDashboard);
    }
  }

  Widget _shortcutChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: darkBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 16),
                6.sBW,
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: kWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: BlocBuilder<CustomerHomeBloc, CustomerHomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: primary,
              backgroundColor: darkSurface,
              onRefresh: () async {
                context.read<CustomerHomeBloc>().add(LoadCustomerHomeEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top App Bar: Location + Switch to Partner
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: primary,
                                  size: 16,
                                ),
                                4.sBW,
                                Text(
                                  'CURRENT LOCATION',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: fontGrey,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            4.sBH,
                            Text(
                              'Sector 62, Noida, UP',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: kWhite,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            // Notifications
                            IconButton(
                              onPressed: () =>
                                  context.push(AppRoutes.notifications),
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: fontGrey,
                                size: 22,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            // SOS
                            IconButton(
                              onPressed: () =>
                                  context.push(AppRoutes.sosEmergency),
                              icon: const Icon(
                                Icons.emergency_rounded,
                                color: kRed,
                                size: 22,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            4.sBW,
                            // Switch to Partner Mode
                            InkWell(
                              onTap: _switchToWorkerMode,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: kGreen.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.handyman_rounded,
                                      color: kGreen,
                                      size: 14,
                                    ),
                                    4.sBW,
                                    Text(
                                      'Partner',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: kGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    16.sBH,

                    // Modern Instant Search Bar
                    InkWell(
                      onTap: () => context.push(AppRoutes.customerMap),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: darkSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: darkBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              color: primary,
                              size: 20,
                            ),
                            12.sBW,
                            Expanded(
                              child: Text(
                                'Search for "Plumber", "Electrician", "AC"...',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: fontGrey,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => VoiceRecordingModal.show(context),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.mic_rounded,
                                  color: primary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    14.sBH,

                    // Quick Shortcuts Strip
                    Row(
                      children: [
                        Expanded(
                          child: _shortcutChip(
                            icon: Icons.history_rounded,
                            label: 'My Bookings',
                            color: primary,
                            onTap: () =>
                                context.push(AppRoutes.customerHistory),
                          ),
                        ),
                        8.sBW,
                        Expanded(
                          child: _shortcutChip(
                            icon: Icons.card_giftcard_rounded,
                            label: 'Refer & Earn',
                            color: Colors.purpleAccent,
                            onTap: () => context.push(AppRoutes.referEarn),
                          ),
                        ),
                        8.sBW,
                        Expanded(
                          child: _shortcutChip(
                            icon: Icons.shield_outlined,
                            label: 'Policies',
                            color: accentBlue,
                            onTap: () =>
                                context.push(AppRoutes.customerPolicies),
                          ),
                        ),
                      ],
                    ),

                    20.sBH,

                    // Hero Showcase Banner with Real Photography
                    const _HeroShowcaseBanner()
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.05, end: 0),

                    16.sBH,

                    // Voice AI Booking Banner (Highlight of KaamFast)
                    _VoiceBookingCard(
                          onTap: () => VoiceRecordingModal.show(context),
                        )
                        .animate()
                        .fadeIn(delay: 150.ms)
                        .scale(begin: const Offset(0.96, 0.96)),

                    20.sBH,

                    // Live Captains Radar Map Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.radar_rounded, color: primary, size: 20),
                            8.sBW,
                            Text(
                              'Live Captains Radar',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: kWhite,
                              ),
                            ),
                            8.sBW,
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: kGreen.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kGreen.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kGreen,
                                    ),
                                  ),
                                  4.sBW,
                                  Text(
                                    '5 Online',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: kGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => context.push(AppRoutes.customerMap),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  'Full Map',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                                4.sBW,
                                const Icon(Icons.open_in_new_rounded, color: primary, size: 14),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    12.sBH,

                    // Interactive Live Real Map Frame directly on Home Screen
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: darkSurface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: primary.withValues(alpha: 0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [
                            InteractiveMapCanvas(
                              showTechnicians: true,
                              showControls: true,
                              topControlsPadding: 10,
                              onPinSelected: () {
                                context.push(AppRoutes.customerMap);
                              },
                            ),
                            // Quick Tap to Fullscreen banner
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: InkWell(
                                onTap: () => context.push(AppRoutes.customerMap),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: darkBg.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: primary.withValues(alpha: 0.4)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.open_in_full_rounded, color: primary, size: 12),
                                      6.sBW,
                                      Text(
                                        'Tap to Expand Fullscreen',
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: kWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),

                    24.sBH,

                    // Trending Services Near You (Horizontal Panoramic Cards)
                    const _TrendingShowcaseSection()
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.05, end: 0),

                    28.sBH,

                    // Categories Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Explore Services',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: kWhite,
                              ),
                            ),
                            8.sBW,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '⚡ 60s Race',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: primaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Nearby 2-5 km',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: fontGrey,
                          ),
                        ),
                      ],
                    ),

                    16.sBH,

                    // Category Grid (2-Column Large Visual Cards)
                    if (state is CustomerHomeLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(color: primary),
                        ),
                      )
                    else if (state is CustomerHomeLoaded)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.74,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                        itemBuilder: (context, index) {
                          final cat = state.categories[index];
                          return _CategoryCard(
                                category: cat,
                                onTap: () {
                                  context.push(
                                    AppRoutes.createBooking,
                                    extra: {'category': cat},
                                  );
                                },
                              )
                              .animate()
                              .fadeIn(delay: (index * 50).ms)
                              .slideY(begin: 0.08, end: 0);
                        },
                      ),

                    28.sBH,

                    // Top Verified Captains Section
                    const _TopCaptainsSection(),

                    24.sBH,

                    // Zero Escrow Direct Pay Guarantee
                    const _ZeroEscrowTrustCard(),

                    28.sBH,

                    // Active Bookings Section
                    if (state is CustomerHomeLoaded &&
                        state.activeBookings.isNotEmpty) ...[
                      Text(
                        'Live Bookings',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kWhite,
                        ),
                      ),
                      14.sBH,
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.activeBookings.length,
                        separatorBuilder: (context, index) => 10.sBH,
                        itemBuilder: (context, index) {
                          final booking = state.activeBookings[index];
                          return InkWell(
                            onTap: () => context.push(
                              '${AppRoutes.liveTracking}/${booking.id}',
                              extra: {'booking': booking},
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: darkSurface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: darkBorder),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.handyman,
                                      color: primary,
                                      size: 22,
                                    ),
                                  ),
                                  12.sBW,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking.category?.name ??
                                              'Service Request',
                                          style: GoogleFonts.outfit(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: kWhite,
                                          ),
                                        ),
                                        4.sBH,
                                        Text(
                                          AppConstants.paiseToRupees(
                                            booking.offeredAmountPaise,
                                          ),
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StatusBadge(status: booking.status),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    80.sBH, // Space for floating button
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kRed,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '🚨 SOS Alert Triggered! Admin & Support alerted with GPS.',
              ),
              backgroundColor: kRed,
            ),
          );
        },
        icon: const Icon(Icons.shield_rounded, color: kWhite),
        label: Text(
          'SOS SAFETY',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

/// Interactive Auto-Swipeable Hero Showcase Banner Carousel with HD Photography
class _HeroShowcaseBanner extends StatefulWidget {
  const _HeroShowcaseBanner();

  @override
  State<_HeroShowcaseBanner> createState() => _HeroShowcaseBannerState();
}

class _HeroShowcaseBannerState extends State<_HeroShowcaseBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'tag': '🔥 42 CAPTAINS ACTIVE NEARBY',
      'title': 'Need Repair Today?\nCaptain in 60 Seconds',
      'subtitle': 'Verified Plumbers, Electricians & AC Pros at your door',
      'buttonText': 'Instant Book Pro',
      'image': AppVectorAssets.bannerExpressDispatch,
      'category': CategoryModel(
        id: 1,
        slug: 'plumber',
        name: 'Plumber Services',
      ),
    },
    {
      'tag': '❄️ SUMMER SPECIAL • FLAT ₹200 OFF',
      'title': 'Master AC Jet Clean\n& Gas Leak Inspection',
      'subtitle': 'Deep foam pressure wash with 30-day service warranty',
      'buttonText': 'Book AC Service',
      'image': AppVectorAssets.bannerAcSummer,
      'category': CategoryModel(
        id: 4,
        slug: 'ac_service',
        name: 'AC Service & Repair',
      ),
    },
    {
      'tag': '🛡️ 100% DIRECT PAYMENT TO CAPTAIN',
      'title': 'Pay Directly via UPI QR\nZero Hidden Commission',
      'subtitle': 'Technicians keep 100% earnings. Fair transparent rates.',
      'buttonText': 'Explore Guarantee',
      'image': AppVectorAssets.bannerZeroEscrow,
      'category': CategoryModel(
        id: 2,
        slug: 'electrician',
        name: 'Electrician Services',
      ),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.45),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: primary.withValues(alpha: 0.12),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // High-Res Background Photography
                      AppVectorAssets.networkImage(
                        url: slide['image'] as String,
                        fit: BoxFit.cover,
                      ),
                      // Multi-stop Vignette Gradient for crystal clear text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: const [0.0, 0.65, 1.0],
                            colors: [
                              const Color(0xFF0C1322).withValues(alpha: 0.96),
                              const Color(0xFF0C1322).withValues(alpha: 0.82),
                              Colors.black.withValues(alpha: 0.35),
                            ],
                          ),
                        ),
                      ),
                      // Slide Content
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: primary.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kGreen,
                                    ),
                                  ),
                                  6.sBW,
                                  Text(
                                    slide['tag'] as String,
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: primaryLight,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            8.sBH,
                            Text(
                              slide['title'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: kWhite,
                                height: 1.2,
                              ),
                            ),
                            10.sBH,
                            InkWell(
                              onTap: () {
                                context.push(
                                  AppRoutes.createBooking,
                                  extra: {'category': slide['category']},
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6.5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: amberGradient,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      slide['buttonText'] as String,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: kWhite,
                                      ),
                                    ),
                                    4.sBW,
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: kWhite,
                                      size: 14,
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
                ),
              );
            },
          ),
        ),
        8.sBH,
        // Smooth Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            final isActive = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? primary
                    : Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// Horizontal Landscape Featured Cards (Trending This Week)
class _TrendingShowcaseSection extends StatelessWidget {
  const _TrendingShowcaseSection();

  @override
  Widget build(BuildContext context) {
    final trending = [
      {
        'title': 'AC Jet Pressure Clean',
        'subtitle': 'Deep foam & cooling boost',
        'price': '₹499',
        'time': '15m match',
        'rating': '4.9 (540+)',
        'image': AppVectorAssets.imgAcService,
        'category': CategoryModel(
          id: 4,
          slug: 'ac_service',
          name: 'AC Service & Repair',
        ),
      },
      {
        'title': 'Bathroom Leakage Fix',
        'subtitle': 'Pipe, tap & valve overhaul',
        'price': '₹249',
        'time': '10m match',
        'rating': '4.9 (820+)',
        'image': AppVectorAssets.imgPlumber,
        'category': CategoryModel(
          id: 1,
          slug: 'plumber',
          name: 'Plumber Leakage Repair',
        ),
      },
      {
        'title': 'Heavy MCB & Wiring',
        'subtitle': 'Short-circuit & surge fix',
        'price': '₹199',
        'time': '12m match',
        'rating': '4.8 (390+)',
        'image': AppVectorAssets.imgElectrician,
        'category': CategoryModel(
          id: 2,
          slug: 'electrician',
          name: 'Electrician Services',
        ),
      },
      {
        'title': 'Door Lock & Hinges',
        'subtitle': 'Precision alignment & latch',
        'price': '₹299',
        'time': '18m match',
        'rating': '4.9 (210+)',
        'image': AppVectorAssets.imgCarpenter,
        'category': CategoryModel(
          id: 3,
          slug: 'carpenter',
          name: 'Carpenter Services',
        ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Popular This Week',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: kWhite,
                  ),
                ),
                8.sBW,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: kGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '🔥 Most Booked',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: kGreen,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Nearby 3km',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: fontGrey,
              ),
            ),
          ],
        ),
        14.sBH,
        SizedBox(
          height: 156,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: trending.length,
            separatorBuilder: (context, index) => 12.sBW,
            itemBuilder: (context, index) {
              final item = trending[index];
              return InkWell(
                onTap: () {
                  context.push(
                    AppRoutes.createBooking,
                    extra: {'category': item['category']},
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primary.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppVectorAssets.networkImage(
                          url: item['image'] as String,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.4, 1.0],
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.black.withValues(alpha: 0.55),
                                const Color(0xFF0F172A).withValues(alpha: 0.96),
                              ],
                            ),
                          ),
                        ),
                        // Top Badges
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.flash_on_rounded,
                                  color: primary,
                                  size: 12,
                                ),
                                2.sBW,
                                Text(
                                  item['time'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: kWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.amber.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                                3.sBW,
                                Text(
                                  item['rating'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: kWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Bottom Content
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: kWhite,
                                      ),
                                    ),
                                    2.sBH,
                                    Text(
                                      item['subtitle'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        color: fontGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              8.sBW,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4.5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: amberGradient,
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  item['price'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: kWhite,
                                  ),
                                ),
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
          ),
        ),
      ],
    );
  }
}

/// Illuminated Voice Booking Banner (Highlight of KaamFast)
class _VoiceBookingCard extends StatelessWidget {
  final VoidCallback onTap;

  const _VoiceBookingCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A1504), Color(0xFF111726)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: primary.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.22),
              blurRadius: 22,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Illuminated Mic Container with double glowing circle
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: amberGradient,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.mic_rounded, color: kWhite, size: 28),
            ),
            14.sBW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: primary.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          'AI VOICE DISPATCH • 60s RACE',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: primaryLight,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      8.sBW,
                      AppVectorAssets.svg(
                        AppVectorAssets.svgVoiceWave,
                        width: 22,
                        height: 16,
                      ),
                    ],
                  ),
                  6.sBH,
                  Text(
                    'Bol Kar Kaam Book Karein',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: kWhite,
                    ),
                  ),
                  3.sBH,
                  Text(
                    'Speak Hindi or English • Instant 60s dispatch',
                    style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: primary,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category Card with Rich HD Imagery, Glass Badges & Ambient Glowing Borders
class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  IconData _getIcon(String slug) {
    if (slug.contains('plumb')) return Icons.plumbing_rounded;
    if (slug.contains('electr')) return Icons.bolt_rounded;
    if (slug.contains('carpen')) return Icons.carpenter_rounded;
    if (slug.contains('clean') || slug.contains('maid')) {
      return Icons.cleaning_services_rounded;
    }
    if (slug.contains('paint')) return Icons.format_paint_rounded;
    if (slug.contains('mason')) return Icons.foundation_rounded;
    if (slug.contains('ac')) return Icons.ac_unit_rounded;
    if (slug.contains('labour')) return Icons.construction_rounded;
    if (slug.contains('driv')) return Icons.drive_eta_rounded;
    return Icons.handyman_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final startingPrice = category.extraHourRatePaise != null
        ? '${AppConstants.paiseToRupees(category.extraHourRatePaise)}/hr'
        : '₹199';
    final photoUrl = AppVectorAssets.getServiceImage(category.slug);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF131924),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: primary.withValues(alpha: 0.35),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rich HD Photo Header (112px tall)
              SizedBox(
                height: 112,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppVectorAssets.networkImage(
                      url: photoUrl,
                      fit: BoxFit.cover,
                    ),
                    // Multi-stop gradient shading for seamless card blend
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.45, 1.0],
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.black.withValues(alpha: 0.08),
                            const Color(0xFF131924),
                          ],
                        ),
                      ),
                    ),
                    // Top-Left Frosted Glass Badge: "⚡ 15 min"
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.70),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: primary,
                              size: 13,
                            ),
                            3.sBW,
                            Text(
                              '15 min',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: kWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Top-Right Glowing Icon Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.70),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primary.withValues(alpha: 0.6),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          _getIcon(category.slug),
                          color: primaryLight,
                          size: 14,
                        ),
                      ),
                    ),
                    // Bottom-Left Rating Tag on Photo
                    Positioned(
                      bottom: 6,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131924)
                              .withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 12,
                            ),
                            3.sBW,
                            Text(
                              '4.9 Pro',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: kWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Card Body: Title, Subtitle & Price Tag
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: kWhite,
                      ),
                    ),
                    2.sBH,
                    Text(
                      'Trained • Direct Pay',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: fontGrey,
                      ),
                    ),
                    8.sBH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: primary.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            startingPrice,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: primaryLight,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            gradient: amberGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.35),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: kWhite,
                            size: 12,
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
  }
}

/// Top Verified Captains Horizontal Carousel
class _TopCaptainsSection extends StatelessWidget {
  const _TopCaptainsSection();

  @override
  Widget build(BuildContext context) {
    final captains = [
      {
        'name': 'Ramesh Kumar',
        'trade': 'Plumber Specialist',
        'rating': '4.9',
        'jobs': '248 jobs',
        'distance': '1.1 km',
        'avatar': AppVectorAssets.avatarCaptain1,
        'category': CategoryModel(
          id: 1,
          slug: 'plumber',
          name: 'Plumber Services',
        ),
      },
      {
        'name': 'Amit Sharma',
        'trade': 'Master Electrician',
        'rating': '4.8',
        'jobs': '192 jobs',
        'distance': '2.4 km',
        'avatar': AppVectorAssets.avatarCaptain2,
        'category': CategoryModel(
          id: 2,
          slug: 'electrician',
          name: 'Electrician Services',
        ),
      },
      {
        'name': 'Vikram Singh',
        'trade': 'Split AC Pro',
        'rating': '5.0',
        'jobs': '314 jobs',
        'distance': '3.0 km',
        'avatar': AppVectorAssets.avatarCaptain3,
        'category': CategoryModel(
          id: 4,
          slug: 'ac_service',
          name: 'AC Service & Repair',
        ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Top Rated Captains',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kWhite,
                  ),
                ),
                8.sBW,
                AppVectorAssets.svg(
                  AppVectorAssets.svgShieldCheck,
                  width: 16,
                  height: 16,
                ),
              ],
            ),
            Text(
              'Live & On-Duty',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kGreen,
              ),
            ),
          ],
        ),
        14.sBH,
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: captains.length,
            separatorBuilder: (context, index) => 12.sBW,
            itemBuilder: (context, index) {
              final cap = captains[index];
              return Container(
                width: 230,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: darkBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            AppVectorAssets.networkImage(
                              url: cap['avatar'] as String,
                              width: 48,
                              height: 48,
                              borderRadius: BorderRadius.circular(14),
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
                                child: const Icon(
                                  Icons.verified_rounded,
                                  color: kGreen,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        10.sBW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cap['name'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kWhite,
                                ),
                              ),
                              2.sBH,
                              Text(
                                cap['trade'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: fontGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    10.sBH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                            4.sBW,
                            Text(
                              cap['rating'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: kWhite,
                              ),
                            ),
                            6.sBW,
                            Text(
                              '• ${cap['jobs']}',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                color: fontGrey,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: kGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cap['distance'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: kGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.sBH,
                    InkWell(
                      onTap: () {
                        context.push(
                          AppRoutes.createBooking,
                          extra: {'category': cap['category']},
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6.5),
                        decoration: BoxDecoration(
                          gradient: amberGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Request Captain',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: kWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Zero Escrow Trust Guarantee Card (Illuminated Emerald Shield Container)
class _ZeroEscrowTrustCard extends StatelessWidget {
  const _ZeroEscrowTrustCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A291E), Color(0xFF071913)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kGreen.withValues(alpha: 0.4), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: kGreen.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: AppVectorAssets.svg(
                  AppVectorAssets.svgShieldCheck,
                  width: 28,
                  height: 28,
                ),
              ),
              14.sBW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '100% Direct Payment to Captain',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: kWhite,
                      ),
                    ),
                    3.sBH,
                    Text(
                      'Pay directly via UPI QR or Cash on arrival. Zero escrow lock & zero platform cut.',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: fontGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.sBH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _trustPill('✓ No Escrow Lock'),
              _trustPill('✓ Direct UPI to Pro'),
              _trustPill('✓ 30-Day Guarantee'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trustPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: kGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGreen.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: kGreen,
        ),
      ),
    );
  }
}
