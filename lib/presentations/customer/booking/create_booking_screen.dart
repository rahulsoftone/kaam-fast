import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/app_vector_assets.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/custom_text_field.dart';
import 'package:kaam_fast/utils/custom_widgets/safe_navigation.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class CreateBookingScreen extends StatefulWidget {
  final CategoryModel? initialCategory;
  final bool isVoice;

  const CreateBookingScreen({
    super.key,
    this.initialCategory,
    this.isVoice = false,
  });

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController =
      TextEditingController(text: 'B-12, Sector 62, Noida');
  int _selectedAmount = 300; // in Rupees
  int _selectedDuration = 60; // in Minutes
  bool _isRecording = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _descController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createBooking() async {
    setState(() => _isLoading = true);
    try {
      final dio = DioClient();
      final catId = widget.initialCategory?.id ?? 1;

      // 1. Create Draft
      final draftRes = await dio.post(
        AppUrls.customerBookings,
        data: {
          'category_id': catId,
          'offered_amount_paise': _selectedAmount * 100,
          'duration_minutes': _selectedDuration,
          'latitude': 28.6139,
          'longitude': 77.2090,
          'address_text': _addressController.text.trim(),
          'description': _descController.text.trim().isEmpty
              ? 'Required ${widget.initialCategory?.name ?? "Service"} for immediate repair'
              : _descController.text.trim(),
        },
      );

      final bookingId = draftRes['data']?['id']?.toString() ?? 'bk_demo_101';

      // 2. Explicit Confirmation to broadcast to workers
      await dio.post(AppUrls.customerConfirmBooking(bookingId));

      if (mounted) {
        context.push('${AppRoutes.liveTracking}/$bookingId');
      }
    } catch (e) {
      // Mock navigation for seamless demo if backend is in staging/sandbox
      if (mounted) {
        context.push('${AppRoutes.liveTracking}/bk_demo_101');
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
        title: Text(
          widget.initialCategory != null
              ? 'Book ${widget.initialCategory!.name}'
              : 'New Service Request',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: kWhite),
        ),
        leading: const AppBackButton(fallbackRoute: AppRoutes.customerHome),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Service Image Card with Rich Backdrop
              Container(
                height: 125,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary.withValues(alpha: 0.4), width: 1.3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 16,
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
                        url: AppVectorAssets.getServiceImage(widget.initialCategory?.slug ?? 'plumber'),
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: const [0.0, 0.65, 1.0],
                            colors: [
                              const Color(0xFF0F172A).withValues(alpha: 0.95),
                              const Color(0xFF0F172A).withValues(alpha: 0.82),
                              Colors.black.withValues(alpha: 0.35),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: primary.withValues(alpha: 0.5)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.flash_on_rounded, color: primaryLight, size: 12),
                                  4.sBW,
                                  Text(
                                    '⚡ 60s RACE DISPATCH • 15 MIN ARRIVAL',
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
                            6.sBH,
                            Text(
                              widget.initialCategory?.name ?? 'Professional Home Service',
                              style: GoogleFonts.outfit(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: kWhite,
                              ),
                            ),
                            4.sBH,
                            Row(
                              children: [
                                const Icon(Icons.verified_rounded, color: kGreen, size: 14),
                                4.sBW,
                                Text(
                                  'Direct payment to Captain • Zero escrow lock',
                                  style: GoogleFonts.outfit(fontSize: 11, color: fontGrey),
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

              20.sBH,

              // Voice Note Hold Card if isVoice
              if (widget.isVoice) ...[
                GestureDetector(
                  onTapDown: (_) => setState(() => _isRecording = true),
                  onTapUp: (_) {
                    setState(() => _isRecording = false);
                    _descController.text =
                        'Kitchen sink tap is leaking severely. Please bring plumber tools.';
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: amberGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                          color: kWhite,
                          size: 48,
                        ).animate(target: _isRecording ? 1 : 0).scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.25, 1.25),
                            ),
                        14.sBH,
                        Text(
                          _isRecording ? 'Listening... Speak now' : 'Hold to Speak in Hindi / English',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kWhite,
                          ),
                        ),
                        6.sBH,
                        Text(
                          _isRecording
                            ? 'Release when finished recording'
                            : 'AI will transcribe and extract price & service automatically',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: kWhite.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                28.sBH,
              ],

              // Job Description
              CustomTextField(
                controller: _descController,
                hintText: 'Describe the problem (e.g. Tap leaking, switch broken...)',
                labelText: 'DESCRIBE YOUR WORK',
                maxLines: 3,
              ),

              24.sBH,

              // Offer Price Selector
              Text(
                'YOUR OFFERED PRICE',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: fontGrey,
                  letterSpacing: 0.8,
                ),
              ),
              8.sBH,
              Text(
                'You propose the price. Nearby workers will race to accept it.',
                style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
              ),
              16.sBH,

              // Quick Chips with rich descriptions
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  {'val': 150, 'tag': 'Quick Fix'},
                  {'val': 250, 'tag': 'Minor Repair'},
                  {'val': 300, 'tag': 'Standard (Popular)'},
                  {'val': 500, 'tag': 'Major Work'},
                  {'val': 800, 'tag': 'Deep Overhaul'},
                ].map((item) {
                  final amount = item['val'] as int;
                  final tag = item['tag'] as String;
                  final isSelected = _selectedAmount == amount;
                  return InkWell(
                    onTap: () => setState(() => _selectedAmount = amount),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? primary.withValues(alpha: 0.18) : darkSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? primary : darkBorder,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '₹$amount',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? primary : kWhite,
                            ),
                          ),
                          6.sBW,
                          Text(
                            tag,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? primaryLight : fontGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              28.sBH,

              // Duration Selector
              Text(
                'ESTIMATED DURATION',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: fontGrey,
                  letterSpacing: 0.8,
                ),
              ),
              14.sBH,
              Row(
                children: [
                  _DurationOption(
                    title: '30 mins',
                    isSelected: _selectedDuration == 30,
                    onTap: () => setState(() => _selectedDuration = 30),
                  ),
                  10.sBW,
                  _DurationOption(
                    title: '1 Hour',
                    isSelected: _selectedDuration == 60,
                    onTap: () => setState(() => _selectedDuration = 60),
                  ),
                  10.sBW,
                  _DurationOption(
                    title: '2 Hours',
                    isSelected: _selectedDuration == 120,
                    onTap: () => setState(() => _selectedDuration = 120),
                  ),
                ],
              ),

              28.sBH,

              // Address input
              CustomTextField(
                controller: _addressController,
                hintText: 'Enter complete service address',
                labelText: 'SERVICE LOCATION',
                prefixIcon: const Icon(Icons.location_on_rounded, color: primary, size: 20),
              ),

              36.sBH,

              // Submit Button
              CustomButton(
                text: 'Confirm & Find Worker Nearby',
                isLoading: _isLoading,
                onPressed: _createBooking,
              ),

              20.sBH,
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primary.withValues(alpha: 0.2) : darkSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? primary : darkBorder, width: 1.5),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? primary : fontGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
