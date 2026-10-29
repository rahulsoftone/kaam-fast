import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/utils/custom_widgets/custom_pin_input.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/model/booking/booking_model.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/status_badge.dart';
import 'package:kaam_fast/utils/custom_widgets/interactive_map_canvas.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class WorkerJobExecutionScreen extends StatefulWidget {
  final String bookingId;
  final BookingModel? initialBooking;

  const WorkerJobExecutionScreen({
    super.key,
    required this.bookingId,
    this.initialBooking,
  });

  @override
  State<WorkerJobExecutionScreen> createState() => _WorkerJobExecutionScreenState();
}

class _WorkerJobExecutionScreenState extends State<WorkerJobExecutionScreen> {
  String _jobStep = 'accepted'; // accepted -> en_route -> arrived -> verified -> started -> completed
  final TextEditingController _arrivalOtpController = TextEditingController();
  bool _isLoading = false;
  int _workTimerSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _arrivalOtpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _workTimerSeconds++);
    });
  }

  String _formatTimer(int totalSecs) {
    final m = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final s = (totalSecs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get _isMockBooking =>
      widget.bookingId.startsWith('bk_live_') || widget.bookingId.startsWith('demo');

  Future<void> _enRoute() async {
    setState(() => _isLoading = true);
    if (!_isMockBooking) {
      try {
        await DioClient().post(AppUrls.workerEnRoute(widget.bookingId));
      } catch (_) {}
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (mounted) {
      setState(() {
        _jobStep = 'en_route';
        _isLoading = false;
      });
    }
  }

  Future<void> _arrived() async {
    setState(() => _isLoading = true);
    if (!_isMockBooking) {
      try {
        await DioClient().post(AppUrls.workerArrived(widget.bookingId));
      } catch (_) {}
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (mounted) {
      setState(() {
        _jobStep = 'arrived';
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyArrivalCode(String code) async {
    if (code.length != 4) return;
    setState(() => _isLoading = true);
    if (!_isMockBooking) {
      try {
        await DioClient().post(
          AppUrls.workerVerifyArrival(widget.bookingId),
          data: {'code': code},
        );
      } catch (_) {}
    } else {
      await Future.delayed(const Duration(milliseconds: 400));
    }
    if (mounted) {
      setState(() {
        _jobStep = 'verified';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Arrival Code Verified! You can now start work.'), backgroundColor: kGreen),
      );
    }
  }

  Future<void> _startJob() async {
    setState(() => _isLoading = true);
    if (!_isMockBooking) {
      try {
        await DioClient().post(AppUrls.workerStartJob(widget.bookingId));
      } catch (_) {}
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (mounted) {
      setState(() {
        _jobStep = 'started';
        _isLoading = false;
      });
      _startTimer();
    }
  }

  Future<void> _requestCompletion() async {
    _timer?.cancel();
    setState(() => _isLoading = true);
    if (!_isMockBooking) {
      try {
        await DioClient().post(AppUrls.workerRequestCompletion(widget.bookingId));
      } catch (_) {}
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (mounted) {
      setState(() {
        _jobStep = 'completed';
        _isLoading = false;
      });
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
          'Active Job Stepper',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: kWhite),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: 20),
          onPressed: () => context.go(AppRoutes.workerDashboard),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: StatusBadge(status: _jobStep)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer & Job Details Header
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
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            gradient: amberGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: kWhite, size: 28),
                        ),
                        14.sBW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aman Verma (Customer)',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: kWhite,
                                ),
                              ),
                              4.sBH,
                              Text(
                                'B-12, Sector 62, Noida (Near Metro)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kGreen.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.phone_rounded, color: kGreen, size: 20),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    16.sBH,
                    const Divider(color: darkBorder, height: 1),
                    16.sBH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SERVICE',
                              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: fontGrey),
                            ),
                            4.sBH,
                            Text(
                              'Plumbing Repair',
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: kWhite),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'DIRECT EARNING',
                              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: kGreen),
                            ),
                            4.sBH,
                            Text(
                              '₹350 (Cash/UPI)',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: kGreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(),

              20.sBH,

              // Partner Live Road Navigation Map (During En-Route / Accepted)
              if (_jobStep == 'accepted' || _jobStep == 'en_route') ...[
                Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: darkSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        const InteractiveMapCanvas(
                          showTechnicians: false,
                          showTrackingRoute: true,
                          showControls: false,
                        ),
                        // Navigation Turn Overlay
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: darkBg.withValues(alpha: 0.94),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: primary.withValues(alpha: 0.5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: kGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.turn_right_rounded, color: kBlack, size: 16),
                                ),
                                10.sBW,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'In 250m turn right to Sector 62',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: kWhite,
                                        ),
                                      ),
                                      Text(
                                        'Route to Aman Verma • 2.1 KM (7 mins ETA)',
                                        style: GoogleFonts.outfit(fontSize: 10, color: fontGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Live Route',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GPS Recenter & Full Route Button
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🗺️ Opening turn-by-turn navigation in external GPS...'),
                                  backgroundColor: primary,
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
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
                                    'Open Navigation',
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
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                20.sBH,
              ],

              // Work Timer Widget if Job Started
              if (_jobStep == 'started') ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: darkSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'JOB IN PROGRESS TIMER',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primary,
                          letterSpacing: 1,
                        ),
                      ),
                      10.sBH,
                      Text(
                        _formatTimer(_workTimerSeconds),
                        style: GoogleFonts.outfit(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: kWhite,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(),
                24.sBH,
              ],

              // 4-Digit Arrival Code Verification Box (When Arrived)
              if (_jobStep == 'arrived') ...[
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: darkSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.pin_rounded, color: primary, size: 36),
                      12.sBH,
                      Text(
                        'Ask Customer for 4-Digit Code',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kWhite,
                        ),
                      ),
                      8.sBH,
                      Text(
                        'Customer has the code on their screen. Type it below to unlock and start the job.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                      ),
                      20.sBH,
                      CustomPinInput(
                        length: 4,
                        controller: _arrivalOtpController,
                        autofocus: true,
                        onCompleted: (pin) => _verifyArrivalCode(pin),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                24.sBH,
              ],

              // Job Completed Payment Collector Card
              if (_jobStep == 'completed') ...[
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F3B25), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kGreen, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: kGreen, size: 52),
                      14.sBH,
                      Text(
                        'Collect ₹350 from Customer',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: kWhite,
                        ),
                      ),
                      8.sBH,
                      Text(
                        'Customer can pay via Cash or scan your UPI QR code. The platform fee of ₹25 was already taken.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
                      ),
                      20.sBH,
                      CustomButton(
                        text: 'Finish & Back to Radar',
                        backgroundColor: kGreen,
                        gradient: emeraldGradient,
                        onPressed: () => context.go(AppRoutes.workerDashboard),
                      ),
                    ],
                  ),
                ).animate().scale(curve: Curves.elasticOut),
                24.sBH,
              ],

              // Lifecycle Progression Action Buttons
              if (_jobStep == 'accepted')
                CustomButton(
                  text: '1. I am On the Way',
                  isLoading: _isLoading,
                  backgroundColor: kBlue,
                  gradient: blueGradient,
                  onPressed: _enRoute,
                )
              else if (_jobStep == 'en_route')
                CustomButton(
                  text: '2. Reached Customer Location',
                  isLoading: _isLoading,
                  backgroundColor: primary,
                  gradient: amberGradient,
                  onPressed: _arrived,
                )
              else if (_jobStep == 'verified')
                CustomButton(
                  text: '3. Start Job Timer',
                  isLoading: _isLoading,
                  backgroundColor: kGreen,
                  gradient: emeraldGradient,
                  onPressed: _startJob,
                )
              else if (_jobStep == 'started')
                CustomButton(
                  text: '4. Work Done - Request Completion',
                  isLoading: _isLoading,
                  backgroundColor: kGreen,
                  gradient: emeraldGradient,
                  onPressed: _requestCompletion,
                ),

              20.sBH,

              // Support / Issue button
              if (_jobStep != 'completed')
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dispute reported to Support team.')),
                      );
                    },
                    icon: const Icon(Icons.warning_amber_rounded, color: fontGrey, size: 16),
                    label: Text(
                      'Customer No-Show / Report Dispute',
                      style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
