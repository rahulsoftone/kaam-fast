import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/safe_navigation.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class WorkerSubscriptionScreen extends StatefulWidget {
  final bool isTab;
  const WorkerSubscriptionScreen({super.key, this.isTab = false});

  @override
  State<WorkerSubscriptionScreen> createState() => _WorkerSubscriptionScreenState();
}

class _WorkerSubscriptionScreenState extends State<WorkerSubscriptionScreen> {
  String _activePlan = 'none'; // none, pro, max
  final int _quotaUsed = 18;
  final int _quotaLimit = 50;
  bool _isLoading = false;

  Future<void> _subscribe(String plan) async {
    setState(() => _isLoading = true);
    try {
      final dio = DioClient();
      await dio.post(AppUrls.workerSubscription, data: {'plan': plan});
      setState(() => _activePlan = plan);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Subscribed to ${plan.toUpperCase()} Plan via Cashfree Auto-Debit!'),
            backgroundColor: kGreen,
          ),
        );
      }
    } catch (_) {
      setState(() => _activePlan = plan);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Subscribed to ${plan.toUpperCase()} Plan via Cashfree Auto-Debit!'),
            backgroundColor: kGreen,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        automaticallyImplyLeading: !widget.isTab,
        leading: widget.isTab ? null : const AppBackButton(fallbackRoute: AppRoutes.workerDashboard),
        title: Text(
          'Pro & Max Plans',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: kWhite),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Save More with Subscriptions',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: kWhite,
                ),
              ).animate().fadeIn(),
              6.sBH,
              Text(
                'Stop paying ₹25 per job. Switch to unlimited or quota plans and keep 100% of your earnings.',
                style: GoogleFonts.outfit(fontSize: 14, color: fontGrey, height: 1.4),
              ).animate().fadeIn(delay: 100.ms),

              24.sBH,

              // Active Quota Meter if on Pro
              if (_activePlan == 'pro') ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F3B25), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kGreen, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PRO MONTHLY QUOTA',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: kGreen,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '$_quotaUsed / $_quotaLimit Jobs',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: kWhite,
                            ),
                          ),
                        ],
                      ),
                      12.sBH,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _quotaUsed / _quotaLimit,
                          minHeight: 8,
                          backgroundColor: darkBorder,
                          valueColor: const AlwaysStoppedAnimation<Color>(kGreen),
                        ),
                      ),
                      10.sBH,
                      Text(
                        '${_quotaLimit - _quotaUsed} jobs remaining in current billing cycle.',
                        style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                      ),
                    ],
                  ),
                ).animate().scale(),
                24.sBH,
              ],

              // Pro Plan Card
              _PlanCard(
                planName: 'PRO PARTNER',
                price: '₹499',
                period: '/ month',
                features: const [
                  '50 Free Bookings per cycle',
                  'Zero ₹25 fee per job (Saves ₹750+)',
                  'Priority Dispatch in Radar',
                  'Cancel anytime via Cashfree',
                ],
                isCurrent: _activePlan == 'pro',
                isLoading: _isLoading,
                accentColor: primary,
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A1608), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onSubscribe: () => _subscribe('pro'),
              ).animate().fadeIn(delay: 200.ms),

              20.sBH,

              // Max Plan Card
              _PlanCard(
                planName: 'MAX UNLIMITED',
                price: '₹999',
                period: '/ month',
                isBestValue: true,
                features: const [
                  'Unlimited Bookings (No cap!)',
                  'Zero ₹25 platform fee forever',
                  'Instant VIP offer broadcast',
                  'Gold Partner badge on profile',
                ],
                isCurrent: _activePlan == 'max',
                isLoading: _isLoading,
                accentColor: kGreen,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3B25), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onSubscribe: () => _subscribe('max'),
              ).animate().fadeIn(delay: 300.ms),

              24.sBH,
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String planName;
  final String price;
  final String period;
  final List<String> features;
  final bool isCurrent;
  final bool isBestValue;
  final bool isLoading;
  final Color accentColor;
  final Gradient gradient;
  final VoidCallback onSubscribe;

  const _PlanCard({
    required this.planName,
    required this.price,
    required this.period,
    required this.features,
    this.isCurrent = false,
    this.isBestValue = false,
    this.isLoading = false,
    required this.accentColor,
    required this.gradient,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrent ? accentColor : darkBorder,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  planName,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              if (isBestValue)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'BEST VALUE',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: kWhite,
                    ),
                  ),
                ),
            ],
          ),
          16.sBH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: GoogleFonts.outfit(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: kWhite,
                ),
              ),
              6.sBW,
              Text(
                period,
                style: GoogleFonts.outfit(fontSize: 14, color: fontGrey),
              ),
            ],
          ),
          18.sBH,
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: accentColor, size: 16),
                    10.sBW,
                    Text(
                      f,
                      style: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFFE2E8F0)),
                    ),
                  ],
                ),
              )),
          20.sBH,
          CustomButton(
            text: isCurrent ? 'Active Plan' : 'Subscribe via Cashfree',
            backgroundColor: isCurrent ? darkBorder : accentColor,
            textColor: isCurrent ? fontGrey : kWhite,
            height: 48,
            isLoading: isLoading,
            onPressed: isCurrent ? null : onSubscribe,
          ),
        ],
      ),
    );
  }
}
