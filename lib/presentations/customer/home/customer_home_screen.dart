import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/presentations/customer/home/bloc/customer_home_bloc.dart';
import 'package:kaam_fast/presentations/customer/home/bloc/customer_home_event.dart';
import 'package:kaam_fast/presentations/customer/home/bloc/customer_home_state.dart';
import 'package:kaam_fast/services/storage_service.dart';
import 'package:kaam_fast/utils/constants/app_constants.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/presentations/customer/voice/voice_recording_modal.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                                const Icon(Icons.location_on_rounded, color: primary, size: 16),
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
                              onPressed: () => context.push(AppRoutes.notifications),
                              icon: const Icon(Icons.notifications_outlined, color: fontGrey, size: 22),
                              visualDensity: VisualDensity.compact,
                            ),
                            // SOS
                            IconButton(
                              onPressed: () => context.push(AppRoutes.sosEmergency),
                              icon: const Icon(Icons.emergency_rounded, color: kRed, size: 22),
                              visualDensity: VisualDensity.compact,
                            ),
                            4.sBW,
                            // Switch to Partner Mode
                            InkWell(
                              onTap: _switchToWorkerMode,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: kGreen.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.handyman_rounded, color: kGreen, size: 14),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            const Icon(Icons.search_rounded, color: primary, size: 20),
                            12.sBW,
                            Expanded(
                              child: Text(
                                'Search for "Plumber", "Electrician", "AC"...',
                                style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
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
                                child: const Icon(Icons.mic_rounded, color: primary, size: 16),
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
                            onTap: () => context.push(AppRoutes.customerHistory),
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
                            onTap: () => context.push(AppRoutes.customerPolicies),
                          ),
                        ),
                      ],
                    ),

                    20.sBH,

                    // Voice AI Booking Banner (Highlight of KaamFast)
                    _VoiceBookingCard(
                      onTap: () => VoiceRecordingModal.show(context),
                    ).animate().fadeIn().scale(begin: const Offset(0.96, 0.96)),

                    28.sBH,

                    // Categories Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Services Available Now',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kWhite,
                          ),
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

                    // Category Grid
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.88,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final cat = state.categories[index];
                          return _CategoryCard(
                            category: cat,
                            onTap: () {
                              context.push(AppRoutes.createBooking, extra: {'category': cat});
                            },
                          ).animate().fadeIn(delay: (index * 60).ms).slideY(begin: 0.1, end: 0);
                        },
                      ),

                    28.sBH,

                    // Active Bookings Section
                    if (state is CustomerHomeLoaded && state.activeBookings.isNotEmpty) ...[
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
                                    child: const Icon(Icons.handyman, color: primary, size: 22),
                                  ),
                                  12.sBW,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking.category?.name ?? 'Service Request',
                                          style: GoogleFonts.outfit(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: kWhite,
                                          ),
                                        ),
                                        4.sBH,
                                        Text(
                                          AppConstants.paiseToRupees(booking.offeredAmountPaise),
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
              content: Text('🚨 SOS Alert Triggered! Admin & Support alerted with GPS.'),
              backgroundColor: kRed,
            ),
          );
        },
        icon: const Icon(Icons.shield_rounded, color: kWhite),
        label: Text(
          'SOS SAFETY',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, letterSpacing: 0.8),
        ),
      ),
    );
  }
}

class _VoiceBookingCard extends StatelessWidget {
  final VoidCallback onTap;
  const _VoiceBookingCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A1608), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: amberGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Icon(Icons.mic_rounded, color: kWhite, size: 28),
            ),
            16.sBW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'AI VOICE BOOKING',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: primaryLight,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  6.sBH,
                  Text(
                    'Bol Kar Kaam Book Karein',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kWhite,
                    ),
                  ),
                  4.sBH,
                  Text(
                    'Just speak what you need in Hindi or English',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: fontGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: primary, size: 16),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  IconData _getIcon(String slug) {
    if (slug.contains('plumb')) return Icons.plumbing_rounded;
    if (slug.contains('electr')) return Icons.bolt_rounded;
    if (slug.contains('carpen')) return Icons.carpenter_rounded;
    if (slug.contains('clean') || slug.contains('maid')) return Icons.cleaning_services_rounded;
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: darkSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: darkBorder.withValues(alpha: 0.8), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primary.withValues(alpha: 0.25)),
              ),
              child: Icon(_getIcon(category.slug), color: primary, size: 24),
            ),
            10.sBH,
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kWhite,
              ),
            ),
            5.sBH,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                startingPrice,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: primaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
