import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/utils/constants/app_constants.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/status_badge.dart';

import 'package:kaam_fast/utils/custom_widgets/safe_navigation.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class WorkerJobRecord {
  final String id;
  final String categoryName;
  final IconData categoryIcon;
  final String customerAddress;
  final int offeredAmountPaise;
  final int platformFeePaise;
  final String paymentMethod;
  final String status; // completed, cancelled
  final DateTime date;
  final double? rating;
  final String? customerReview;

  WorkerJobRecord({
    required this.id,
    required this.categoryName,
    required this.categoryIcon,
    required this.customerAddress,
    required this.offeredAmountPaise,
    this.platformFeePaise = 2500, // ₹25 platform fee
    required this.paymentMethod,
    required this.status,
    required this.date,
    this.rating,
    this.customerReview,
  });

  int get netEarningsPaise => offeredAmountPaise - platformFeePaise;
}

class WorkerJobHistoryScreen extends StatefulWidget {
  final bool isEmbedded;
  const WorkerJobHistoryScreen({super.key, this.isEmbedded = false});

  @override
  State<WorkerJobHistoryScreen> createState() => _WorkerJobHistoryScreenState();
}

class _WorkerJobHistoryScreenState extends State<WorkerJobHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  late List<WorkerJobRecord> _jobs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _jobs = [
      WorkerJobRecord(
        id: 'KF-9042',
        categoryName: 'Plumbing Repair',
        categoryIcon: Icons.plumbing_rounded,
        customerAddress: 'Flat 402, Lotus Boulevard, Sector 100',
        offeredAmountPaise: 45000,
        paymentMethod: 'Direct UPI QR',
        status: 'completed',
        date: DateTime.now().subtract(const Duration(hours: 3)),
        rating: 5.0,
        customerReview: 'Arrived very quickly and resolved the kitchen leak professionally!',
      ),
      WorkerJobRecord(
        id: 'KF-8921',
        categoryName: 'Electrical Wiring',
        categoryIcon: Icons.bolt_rounded,
        customerAddress: 'B-12, Sector 62, Noida (Near Metro)',
        offeredAmountPaise: 60000,
        paymentMethod: 'Direct Cash',
        status: 'completed',
        date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        rating: 4.8,
        customerReview: 'Polite behaviour and brought original MCB breaker with him.',
      ),
      WorkerJobRecord(
        id: 'KF-8815',
        categoryName: 'AC Filter Cleaning',
        categoryIcon: Icons.ac_unit_rounded,
        customerAddress: 'Villa 7, Jaypee Greens, Greater Noida',
        offeredAmountPaise: 80000,
        paymentMethod: 'Direct UPI QR',
        status: 'completed',
        date: DateTime.now().subtract(const Duration(days: 2)),
        rating: 5.0,
        customerReview: 'Flawless jet wash cleaning. Master pro technician.',
      ),
      WorkerJobRecord(
        id: 'KF-8730',
        categoryName: 'Appliance Repair',
        categoryIcon: Icons.home_repair_service_rounded,
        customerAddress: 'C-89, Sector 15, Noida',
        offeredAmountPaise: 35000,
        paymentMethod: 'Direct UPI QR',
        status: 'cancelled',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
    _fetchJobHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchJobHistory() async {
    setState(() => _isLoading = true);
    try {
      await DioClient().get(AppUrls.workerJobsHistory);
    } catch (_) {
      // Graceful fallback for staging
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showJobReceipt(WorkerJobRecord job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: darkBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: fontGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            20.sBH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Summary & Payout',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: kWhite),
                    ),
                    Text(
                      'ID: #${job.id}',
                      style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                    ),
                  ],
                ),
                StatusBadge(status: job.status),
              ],
            ),
            20.sBH,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: darkBorder),
              ),
              child: Column(
                children: [
                  _receiptRow('Customer Direct Payment', AppConstants.formatPaise(job.offeredAmountPaise), isPositive: true),
                  8.sBH,
                  _receiptRow('KaamFast Platform Fee', '- ${AppConstants.formatPaise(job.platformFeePaise)}', isNegative: true),
                  12.sBH,
                  const Divider(color: darkBorder),
                  12.sBH,
                  _receiptRow('Net Take-Home Earning', AppConstants.formatPaise(job.netEarningsPaise), isBold: true),
                ],
              ),
            ),
            16.sBH,
            Row(
              children: [
                const Icon(Icons.payment_rounded, color: primary, size: 18),
                8.sBW,
                Text(
                  'Paid directly by customer via ${job.paymentMethod}',
                  style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                ),
              ],
            ),
            if (job.customerReview != null) ...[
              16.sBH,
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        4.sBW,
                        Text(
                          '${job.rating} / 5.0 Customer Rating',
                          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: kWhite),
                        ),
                      ],
                    ),
                    6.sBH,
                    Text(
                      '"${job.customerReview}"',
                      style: GoogleFonts.outfit(fontSize: 12, fontStyle: FontStyle.italic, color: fontGrey),
                    ),
                  ],
                ),
              ),
            ],
            24.sBH,
            CustomButton(
              text: 'Done',
              onPressed: () => Navigator.pop(ctx),
            ),
            12.sBH,
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isPositive = false, bool isNegative = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: isBold ? kWhite : fontGrey,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isPositive
                ? kGreen
                : (isNegative ? kRed : (isBold ? primary : kWhite)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedJobs = _jobs.where((j) => j.status == 'completed').toList();
    final cancelledJobs = _jobs.where((j) => j.status == 'cancelled').toList();

    final totalEarnedPaise = completedJobs.fold<int>(0, (sum, j) => sum + j.netEarningsPaise);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              backgroundColor: darkBg,
              elevation: 0,
              leading: const AppBackButton(fallbackRoute: AppRoutes.workerDashboard),
              title: Text(
                'Completed Jobs & Earnings',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
              ),
            ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : RefreshIndicator(
              color: primary,
              backgroundColor: darkSurface,
              onRefresh: _fetchJobHistory,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Earnings Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: emeraldGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: kGreen.withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL TAKE-HOME EARNED',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: kWhite.withValues(alpha: 0.8),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                    4.sBW,
                                    Text(
                                      '4.9 Rating',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: kWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          10.sBH,
                          Text(
                            AppConstants.formatPaise(totalEarnedPaise),
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: kWhite,
                            ),
                          ),
                          16.sBH,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _statItem('Completed', '${completedJobs.length} Jobs'),
                              _statItem('Direct Payout', '100% Cash/UPI'),
                              _statItem('Platform Fee', '₹25/job'),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),

                    20.sBH,

                    // Tabs
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
                          Tab(text: 'All (${_jobs.length})'),
                          Tab(text: 'Completed (${completedJobs.length})'),
                          Tab(text: 'Cancelled (${cancelledJobs.length})'),
                        ],
                      ),
                    ),

                    16.sBH,

                    // List based on Tab
                    AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, _) {
                        List<WorkerJobRecord> currentList;
                        if (_tabController.index == 1) {
                          currentList = completedJobs;
                        } else if (_tabController.index == 2) {
                          currentList = cancelledJobs;
                        } else {
                          currentList = _jobs;
                        }

                        if (currentList.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(40),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                const Icon(Icons.inbox_rounded, color: fontGrey, size: 48),
                                12.sBH,
                                Text(
                                  'No jobs in this category yet',
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
                          separatorBuilder: (context, index) => 12.sBH,
                          itemBuilder: (context, index) {
                            final job = currentList[index];
                            return _buildJobCard(job, index);
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

  Widget _statItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 11, color: kWhite.withValues(alpha: 0.7)),
        ),
        2.sBH,
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: kWhite),
        ),
      ],
    );
  }

  Widget _buildJobCard(WorkerJobRecord job, int index) {
    final dateFormat = DateFormat('dd MMM, hh:mm a');

    return Container(
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: darkBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showJobReceipt(job),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(job.categoryIcon, color: primary, size: 20),
                        ),
                        10.sBW,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.categoryName,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: kWhite,
                              ),
                            ),
                            2.sBH,
                            Text(
                              '#${job.id} • ${dateFormat.format(job.date)}',
                              style: GoogleFonts.outfit(fontSize: 11, color: fontGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    StatusBadge(status: job.status),
                  ],
                ),
                12.sBH,
                Text(
                  job.customerAddress,
                  style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                12.sBH,
                const Divider(color: darkBorder),
                8.sBH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Net Earned: ',
                          style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                        ),
                        Text(
                          AppConstants.formatPaise(job.netEarningsPaise),
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: job.status == 'completed' ? kGreen : fontGrey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'View Details →',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (index * 60).ms).fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0);
  }
}
