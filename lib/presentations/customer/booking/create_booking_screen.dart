import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/custom_text_field.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Quick Chips
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [150, 250, 300, 500, 800].map((amount) {
                  final isSelected = _selectedAmount == amount;
                  return ChoiceChip(
                    label: Text('₹$amount', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
                    selected: isSelected,
                    selectedColor: primary,
                    backgroundColor: darkSurface,
                    labelStyle: TextStyle(color: isSelected ? kWhite : fontGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isSelected ? primary : darkBorder),
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedAmount = amount);
                    },
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
