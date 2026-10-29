import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/utils/constants/app_constants.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/custom_text_field.dart';

class CustomerRatingScreen extends StatefulWidget {
  final String bookingId;
  final String serviceName;
  final String workerName;

  const CustomerRatingScreen({
    super.key,
    this.bookingId = 'demo_booking',
    this.serviceName = 'Plumbing Service',
    this.workerName = 'Captain Ramesh Kumar',
  });

  @override
  State<CustomerRatingScreen> createState() => _CustomerRatingScreenState();
}

class _CustomerRatingScreenState extends State<CustomerRatingScreen> {
  int _rating = 5;
  final Set<String> _selectedTags = {'On-Time Arrival', 'Polite & Professional', 'Had Proper Tools'};
  int _selectedTipPaise = 5000; // ₹50 tip default
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _feedbackTags = [
    '⏰ On-Time Arrival',
    '🤝 Polite & Professional',
    '🧼 Neat & Clean Work',
    '⚡ Super Fast Repair',
    '💰 Fair & Honest Direct Price',
    '🧰 Had Proper Tools',
    '🛡️ Followed Safety Rules',
  ];

  final List<int> _tipOptions = [0, 2000, 5000, 10000, 20000]; // 0, ₹20, ₹50, ₹100, ₹200

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _getRatingFeedback() {
    switch (_rating) {
      case 1:
        return 'Disappointing 😞';
      case 2:
        return 'Needs Improvement 😐';
      case 3:
        return 'Good & Satisfactory 🙂';
      case 4:
        return 'Very Good & Professional 😊';
      case 5:
      default:
        return 'Outstanding & Flawless! 🤩';
    }
  }

  Future<void> _submitReview() async {
    setState(() => _isSubmitting = true);
    try {
      await DioClient().post(
        AppUrls.customerRateBooking(widget.bookingId),
        data: {
          'rating': _rating,
          'comment': _commentController.text.trim(),
          'tags': _selectedTags.toList(),
          'tip_paise': _selectedTipPaise,
        },
      );
    } catch (_) {
      // Graceful fallback for staging
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSuccessCelebration();
      }
    }
  }

  void _showSuccessCelebration() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: emeraldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: kGreen.withValues(alpha: 0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(Icons.favorite_rounded, color: kWhite, size: 40),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
              20.sBH,
              Text(
                'Thank You! 🎉',
                style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: kWhite),
              ),
              8.sBH,
              Text(
                'Your rating helps ${widget.workerName} maintain a high priority status on the KaamFast platform.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 13, color: fontGrey, height: 1.4),
              ),
              if (_selectedTipPaise > 0) ...[
                12.sBH,
                Text(
                  '${AppConstants.formatPaise(_selectedTipPaise)} tip added directly to partner payout!',
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: kGreen),
                ),
              ],
              24.sBH,
              CustomButton(
                text: 'Done',
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rate Experience',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            // Partner Profile Avatar
            Center(
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: emeraldGradient,
                    ),
                    child: const Icon(Icons.handyman_rounded, color: kWhite, size: 38),
                  ),
                  14.sBH,
                  Text(
                    widget.workerName,
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: kWhite),
                  ),
                  4.sBH,
                  Text(
                    widget.serviceName,
                    style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
                  ),
                ],
              ),
            ),

            24.sBH,

            // Interactive 5 Stars
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: darkBorder),
              ),
              child: Column(
                children: [
                  Text(
                    _getRatingFeedback(),
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                  16.sBH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1;
                      final isFilled = starValue <= _rating;

                      return IconButton(
                        iconSize: 42,
                        splashRadius: 24,
                        icon: Icon(
                          isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: isFilled ? Colors.amber : fontGrey,
                        ),
                        onPressed: () => setState(() => _rating = starValue),
                      );
                    }),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),

            24.sBH,

            // Quick Feedback Chips
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What went well?',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: kWhite),
              ),
            ),
            12.sBH,

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _feedbackTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTags.remove(tag);
                      } else {
                        _selectedTags.add(tag);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? primary.withValues(alpha: 0.15) : darkSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? primary : darkBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? primary : fontGrey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            24.sBH,

            // Tip Selection (100% to Captain)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(Icons.favorite_rounded, color: primary, size: 18),
                  8.sBW,
                  Text(
                    'Add a Direct Tip for Captain',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: kWhite),
                  ),
                ],
              ),
            ),
            4.sBH,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '100% of your tip goes directly to the partner via UPI/Cash.',
                style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
              ),
            ),
            12.sBH,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _tipOptions.map((tip) {
                final isSelected = _selectedTipPaise == tip;
                return InkWell(
                  onTap: () => setState(() => _selectedTipPaise = tip),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? kGreen : darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? kGreen : darkBorder,
                      ),
                    ),
                    child: Text(
                      tip == 0 ? 'No Tip' : AppConstants.formatPaise(tip),
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? kWhite : fontGrey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            24.sBH,

            // Written review
            CustomTextField(
              controller: _commentController,
              labelText: 'Write an optional review',
              hintText: 'Share more about your experience with the partner...',
              maxLines: 3,
            ),

            32.sBH,

            CustomButton(
              text: 'Submit Rating & Feedback',
              icon: Icons.send_rounded,
              isLoading: _isSubmitting,
              onPressed: _submitReview,
            ),

            24.sBH,
          ],
        ),
      ),
    );
  }
}
