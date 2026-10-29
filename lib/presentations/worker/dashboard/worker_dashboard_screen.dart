import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/model/worker/worker_offer_model.dart';
import 'package:kaam_fast/presentations/worker/dashboard/bloc/worker_dashboard_bloc.dart';
import 'package:kaam_fast/presentations/worker/dashboard/bloc/worker_dashboard_event.dart';
import 'package:kaam_fast/presentations/worker/dashboard/bloc/worker_dashboard_state.dart';
import 'package:kaam_fast/presentations/worker/offers/offer_countdown_modal.dart';
import 'package:kaam_fast/services/storage_service.dart';
import 'package:kaam_fast/utils/constants/app_constants.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/animated_radar.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/status_badge.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkerDashboardBloc>().add(LoadWorkerDashboardEvent());
  }

  Future<void> _switchToCustomerMode() async {
    await StorageService().setRole('customer');
    if (mounted) {
      context.go(AppRoutes.customerHome);
    }
  }

  void _triggerSimulatedOffer() {
    OfferCountdownModal.show(
      context,
      WorkerOfferModel(
        bookingId: 'bk_live_99',
        category: CategoryModel(id: 1, slug: 'plumber', name: 'Plumbing Repair'),
        offeredAmountPaise: 45000, // ₹450
        durationMinutes: 90,
        addressText: 'A-42, Sector 62, Noida (Near Metro)',
        distanceMeters: 1200, // 1.2 km
        secondsLeft: 45,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: BlocBuilder<WorkerDashboardBloc, WorkerDashboardState>(
          builder: (context, state) {
            final isOnDuty = state is WorkerDashboardLoaded ? state.onDuty : false;
            final wallet = state is WorkerDashboardLoaded ? state.wallet : null;

            return RefreshIndicator(
              color: kGreen,
              backgroundColor: darkSurface,
              onRefresh: () async {
                context.read<WorkerDashboardBloc>().add(LoadWorkerDashboardEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top App Bar: Profile & Mode Switch & Quick Action Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: emeraldGradient,
                              ),
                              child: const Icon(Icons.handyman_rounded, color: kWhite, size: 24),
                            ),
                            10.sBW,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Partner Captain',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: kWhite,
                                  ),
                                ),
                                2.sBH,
                                const StatusBadge(status: 'verified'),
                              ],
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
                              onPressed: () => context.push(AppRoutes.sosEmergency, extra: {'isWorker': true}),
                              icon: const Icon(Icons.emergency_rounded, color: kRed, size: 22),
                              visualDensity: VisualDensity.compact,
                            ),
                            4.sBW,
                            // Switch to Customer Mode
                            InkWell(
                              onTap: _switchToCustomerMode,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: primary.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person_rounded, color: primary, size: 14),
                                    4.sBW,
                                    Text(
                                      'Customer',
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
                      ],
                    ),

                    20.sBH,

                    // Duty Toggle Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: darkSurface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isOnDuty ? kGreen.withValues(alpha: 0.5) : darkBorder,
                          width: 1.5,
                        ),
                        boxShadow: isOnDuty
                            ? [
                                BoxShadow(
                                  color: kGreen.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (isOnDuty ? kGreen : fontGrey).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.power_settings_new_rounded,
                              color: isOnDuty ? kGreen : fontGrey,
                              size: 28,
                            ),
                          ),
                          16.sBW,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isOnDuty ? 'YOU ARE ONLINE' : 'YOU ARE OFFLINE',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isOnDuty ? kGreen : fontGrey,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                4.sBH,
                                Text(
                                  isOnDuty
                                      ? 'Broadcasting GPS. Ready for 45s job offers!'
                                      : 'Turn duty ON to start receiving nearby jobs.',
                                  style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isOnDuty,
                            activeThumbColor: kGreen,
                            activeTrackColor: kGreen.withValues(alpha: 0.3),
                            onChanged: (val) {
                              context.read<WorkerDashboardBloc>().add(ToggleDutyEvent(onDuty: val));
                            },
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                    20.sBH,

                    // Radar Simulation when on duty
                    if (isOnDuty) ...[
                      Center(
                        child: Column(
                          children: [
                            const AnimatedRadarWidget(
                              size: 170,
                              color: kGreen,
                              centerChild: Icon(Icons.handyman, color: kWhite, size: 28),
                            ),
                            12.sBH,
                            Text(
                              'Radar Active • Scanning within 3.5 km radius',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: kGreen,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(),
                      20.sBH,
                    ],

                    // Wallet & Earnings Card
                    InkWell(
                      onTap: () => context.push(AppRoutes.workerWallet),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F2B1F), Color(0xFF1E293B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: kGreen.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.account_balance_wallet_rounded,
                                        color: kGreen, size: 20),
                                    8.sBW,
                                    Text(
                                      'PREPAID WALLET',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: kGreen,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded,
                                    color: fontGrey, size: 14),
                              ],
                            ),
                            14.sBH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppConstants.paiseToRupees(wallet?.balancePaise ?? 45000),
                                      style: GoogleFonts.outfit(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: kWhite,
                                      ),
                                    ),
                                    4.sBH,
                                    Text(
                                      'Flat ₹25 deducted per accepted job',
                                      style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: kGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Recharge',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: kWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    24.sBH,

                    // Partner Management Quick Services Grid
                    Text(
                      'Partner Tools & Services',
                      style: GoogleFonts.outfit(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: kWhite,
                      ),
                    ),
                    12.sBH,

                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.95,
                      children: [
                        _partnerGridTile(
                          icon: Icons.verified_user_rounded,
                          title: 'KYC & ID',
                          subtitle: 'Verified',
                          color: kGreen,
                          onTap: () => context.push(AppRoutes.workerKyc),
                        ),
                        _partnerGridTile(
                          icon: Icons.school_rounded,
                          title: 'Academy',
                          subtitle: 'Learn & Earn',
                          color: primary,
                          onTap: () => context.push(AppRoutes.workerCourses),
                        ),
                        _partnerGridTile(
                          icon: Icons.tune_rounded,
                          title: 'Skills & UPI',
                          subtitle: 'Trade Setup',
                          color: accentBlue,
                          onTap: () => context.push(AppRoutes.workerCategories),
                        ),
                        _partnerGridTile(
                          icon: Icons.history_rounded,
                          title: 'Job History',
                          subtitle: '38 Jobs Done',
                          color: Colors.orangeAccent,
                          onTap: () => context.push(AppRoutes.workerHistory),
                        ),
                        _partnerGridTile(
                          icon: Icons.workspace_premium_rounded,
                          title: 'Pro Plans',
                          subtitle: 'Unlimited Job',
                          color: Colors.purpleAccent,
                          onTap: () => context.push(AppRoutes.workerSubscription),
                        ),
                        _partnerGridTile(
                          icon: Icons.play_circle_fill_rounded,
                          title: 'Job Flow',
                          subtitle: 'Live Demo',
                          color: kGreen,
                          onTap: () => context.push('${AppRoutes.workerJobExecution}/bk_live_99'),
                        ),
                      ],
                    ),

                    24.sBH,

                    // Referral Promo Banner
                    InkWell(
                      onTap: () => context.push(AppRoutes.referEarn),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: darkSurface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primary.withValues(alpha: 0.3)),
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
                                    'Refer Fellow Technician & Earn ₹50',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: kWhite,
                                    ),
                                  ),
                                  2.sBH,
                                  Text(
                                    'Both get ₹50 added directly to wallet on 1st job.',
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

                    24.sBH,

                    // Interactive Test Trigger for the 45-Second Offer Screen
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: darkSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timer_rounded, color: primary, size: 22),
                              8.sBW,
                              Text(
                                'Test Realtime Offer Screen',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: kWhite,
                                ),
                              ),
                            ],
                          ),
                          8.sBH,
                          Text(
                            'Tap below to simulate an incoming job offer and test the 45-second animated acceptance countdown race.',
                            style: GoogleFonts.outfit(fontSize: 13, color: fontGrey, height: 1.3),
                          ),
                          16.sBH,
                          CustomButton(
                            text: 'Simulate 45s Job Offer',
                            backgroundColor: primary,
                            gradient: amberGradient,
                            height: 48,
                            onPressed: _triggerSimulatedOffer,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    24.sBH,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _partnerGridTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
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
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                8.sBH,
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: kWhite,
                  ),
                ),
                2.sBH,
                Text(
                  subtitle,
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
        ),
      ),
    );
  }
}
