import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/model/booking/booking_model.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/utils/constants/app_constants.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/app_vector_assets.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/status_badge.dart';
import 'package:kaam_fast/utils/custom_widgets/safe_navigation.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class CustomerBookingsHistoryScreen extends StatefulWidget {
  final bool isTab;
  const CustomerBookingsHistoryScreen({super.key, this.isTab = false});

  @override
  State<CustomerBookingsHistoryScreen> createState() => _CustomerBookingsHistoryScreenState();
}

class _CustomerBookingsHistoryScreenState extends State<CustomerBookingsHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  late List<BookingModel> _bookings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _bookings = [
      BookingModel(
        id: 'bk_act_01',
        status: 'accepted',
        category: CategoryModel(id: 1, slug: 'plumber', name: 'Plumber Leakage Repair'),
        offeredAmountPaise: 45000,
        durationMinutes: 60,
        addressText: 'Flat 402, Lotus Boulevard, Sector 100, Noida',
        worker: AssignedWorkerModel(
          id: 'w_01',
          name: 'Ramesh Kumar',
          phone: '+919876543210',
          ratingAverage: 4.9,
          isTrained: true,
        ),
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      BookingModel(
        id: 'bk_past_02',
        status: 'completed',
        category: CategoryModel(id: 4, slug: 'ac_service', name: 'Split AC Deep Clean'),
        offeredAmountPaise: 79900,
        durationMinutes: 90,
        addressText: 'Flat 402, Lotus Boulevard, Sector 100, Noida',
        worker: AssignedWorkerModel(
          id: 'w_02',
          name: 'Amit Sharma',
          phone: '+919812345678',
          ratingAverage: 4.8,
          isTrained: true,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        completedAt: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      ),
      BookingModel(
        id: 'bk_past_03',
        status: 'completed',
        category: CategoryModel(id: 2, slug: 'electrician', name: 'Switchboard & MCB Repair'),
        offeredAmountPaise: 35000,
        durationMinutes: 45,
        addressText: 'Flat 402, Lotus Boulevard, Sector 100, Noida',
        worker: AssignedWorkerModel(
          id: 'w_03',
          name: 'Dinesh Yadav',
          phone: '+919988776655',
          ratingAverage: 5.0,
          isTrained: true,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        completedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      BookingModel(
        id: 'bk_canc_04',
        status: 'cancelled',
        category: CategoryModel(id: 3, slug: 'carpenter', name: 'Door Hinge Repair'),
        offeredAmountPaise: 40000,
        durationMinutes: 60,
        addressText: 'Flat 402, Lotus Boulevard, Sector 100, Noida',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
    _fetchBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchBookings() async {
    setState(() => _isLoading = true);
    try {
      await DioClient().get(AppUrls.customerBookings);
    } catch (_) {
      // Graceful fallback for staging
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _rebook(BookingModel booking) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚡ Rebooking ${booking.category?.name ?? 'Service'}...'),
        backgroundColor: primary,
      ),
    );
    try {
      await DioClient().post(AppUrls.customerRebook(booking.id));
    } catch (_) {}

    if (mounted) {
      context.push(
        AppRoutes.createBooking,
        extra: {'category': booking.category},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeBookings = _bookings
        .where((b) => ['draft', 'matching', 'offered', 'accepted', 'en_route', 'arrived', 'in_progress'].contains(b.status))
        .toList();
    final completedBookings = _bookings.where((b) => b.status == 'completed').toList();
    final cancelledBookings = _bookings.where((b) => b.status == 'cancelled').toList();

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        automaticallyImplyLeading: !widget.isTab,
        leading: widget.isTab ? null : const AppBackButton(fallbackRoute: AppRoutes.customerHome),
        title: Text(
          'My Bookings',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : RefreshIndicator(
              color: primary,
              backgroundColor: darkSurface,
              onRefresh: _fetchBookings,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
                      decoration: BoxDecoration(
                        color: darkSurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelColor: kBlack,
                        unselectedLabelColor: fontGrey,
                        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13),
                        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(text: 'Active (${activeBookings.length})'),
                          Tab(text: 'Past (${completedBookings.length})'),
                          Tab(text: 'Cancelled (${cancelledBookings.length})'),
                        ],
                      ),
                    ),

                    16.sBH,

                    AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, _) {
                        List<BookingModel> currentList;
                        if (_tabController.index == 0) {
                          currentList = activeBookings;
                        } else if (_tabController.index == 1) {
                          currentList = completedBookings;
                        } else {
                          currentList = cancelledBookings;
                        }

                        if (currentList.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(50),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                const Icon(Icons.event_note_rounded, color: fontGrey, size: 48),
                                12.sBH,
                                Text(
                                  'No bookings found',
                                  style: GoogleFonts.outfit(fontSize: 14, color: fontGrey),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: currentList.length,
                          separatorBuilder: (context, index) => 14.sBH,
                          itemBuilder: (context, index) {
                            final booking = currentList[index];
                            return _buildBookingCard(booking, index);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBookingCard(BookingModel booking, int index) {
    final dateFormat = DateFormat('dd MMM, hh:mm a');
    final isActive = ['matching', 'offered', 'accepted', 'en_route', 'arrived', 'in_progress'].contains(booking.status);
    final isCompleted = booking.status == 'completed';

    final photoUrl = AppVectorAssets.getServiceImage(booking.category?.slug ?? 'plumber');

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141A26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? primary.withValues(alpha: 0.6) : darkBorder,
          width: isActive ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          if (isActive)
            BoxShadow(
              color: primary.withValues(alpha: 0.12),
              blurRadius: 16,
            ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Photo & Title Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppVectorAssets.networkImage(
                url: photoUrl,
                width: 54,
                height: 54,
                borderRadius: BorderRadius.circular(14),
              ),
              12.sBW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            booking.category?.name ?? 'Home Service',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: kWhite,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        8.sBW,
                        StatusBadge(status: booking.status),
                      ],
                    ),
                    4.sBH,
                    Text(
                      booking.createdAt != null ? dateFormat.format(booking.createdAt!) : '',
                      style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.sBH,
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: fontGrey, size: 16),
              6.sBW,
              Expanded(
                child: Text(
                  booking.addressText ?? 'Noida, UP',
                  style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (booking.worker != null) ...[
            12.sBH,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      AppVectorAssets.networkImage(
                        url: AppVectorAssets.avatarCaptain1,
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1.5),
                          decoration: const BoxDecoration(
                            color: kBlack,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_rounded, color: kGreen, size: 12),
                        ),
                      ),
                    ],
                  ),
                  12.sBW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.worker!.name ?? 'Assigned Partner',
                          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: kWhite),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                            4.sBW,
                            Text(
                              '${booking.worker!.ratingAverage ?? 4.9} Verified Pro',
                              style: GoogleFonts.outfit(fontSize: 11, color: fontGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppConstants.formatPaise(booking.offeredAmountPaise),
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            10.sBH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quoted Price:', style: GoogleFonts.outfit(fontSize: 12, color: fontGrey)),
                Text(
                  AppConstants.formatPaise(booking.offeredAmountPaise),
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: primary),
                ),
              ],
            ),
          ],
          16.sBH,
          const Divider(color: darkBorder),
          8.sBH,
          Row(
            children: [
              if (isActive)
                Expanded(
                  child: CustomButton(
                    text: 'Live Track Partner',
                    icon: Icons.radar_rounded,
                    height: 42,
                    gradient: amberGradient,
                    onPressed: () => context.push('${AppRoutes.liveTracking}/${booking.id}', extra: {'booking': booking}),
                  ),
                )
              else if (isCompleted) ...[
                Expanded(
                  child: CustomButton(
                    text: 'Rate Captain',
                    icon: Icons.star_border_rounded,
                    height: 42,
                    isOutlined: true,
                    borderColor: primary,
                    onPressed: () => context.push(
                      '${AppRoutes.customerRating}?bookingId=${booking.id}&category=${Uri.encodeComponent(booking.category?.name ?? 'Service')}&worker=${Uri.encodeComponent(booking.worker?.name ?? 'Captain')}',
                    ),
                  ),
                ),
                12.sBW,
                Expanded(
                  child: CustomButton(
                    text: '1-Tap Rebook',
                    icon: Icons.replay_rounded,
                    height: 42,
                    gradient: emeraldGradient,
                    onPressed: () => _rebook(booking),
                  ),
                ),
              ] else
                Expanded(
                  child: CustomButton(
                    text: 'Rebook Service',
                    icon: Icons.replay_rounded,
                    height: 42,
                    gradient: amberGradient,
                    onPressed: () => _rebook(booking),
                  ),
                ),
            ],
          ),
        ],
      ),
    ).animate(delay: (index * 70).ms).fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0);
  }
}
