import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/interactive_map_canvas.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class CustomerLiveMapScreen extends StatefulWidget {
  const CustomerLiveMapScreen({super.key});

  @override
  State<CustomerLiveMapScreen> createState() => _CustomerLiveMapScreenState();
}

class _CustomerLiveMapScreenState extends State<CustomerLiveMapScreen> {
  String _selectedTradeFilter = 'all';
  MapTechnicianPin? _selectedCaptain;

  final List<Map<String, dynamic>> _tradeFilters = const [
    {'id': 'all', 'label': 'All Nearby', 'icon': Icons.near_me_rounded},
    {'id': 'plumber', 'label': 'Plumbers (6m)', 'icon': Icons.plumbing_rounded},
    {'id': 'electrician', 'label': 'Electricians (11m)', 'icon': Icons.bolt_rounded},
    {'id': 'ac-technician', 'label': 'AC Repair (9m)', 'icon': Icons.ac_unit_rounded},
    {'id': 'carpenter', 'label': 'Carpenters (14m)', 'icon': Icons.carpenter_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fullscreen Interactive Dark Real Map
          Positioned.fill(
            child: InteractiveMapCanvas(
              showTechnicians: true,
              showTrackingRoute: false,
              categoryFilter: _selectedTradeFilter,
              onPinChanged: (pin) {
                setState(() => _selectedCaptain = pin);
              },
            ),
          ),

          // Top Header & Filters
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location Header Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: darkBg.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: darkBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: primary, size: 20),
                            10.sBW,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RADAR SCAN ACTIVE (3.5 KM)',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: fontGrey,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                2.sBH,
                                Text(
                                  'Sector 62, Noida, UP',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: kWhite,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: kGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
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
                              6.sBW,
                              Text(
                                'Live GPS',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: kGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0),

                  10.sBH,

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tradeFilters.map((filter) {
                        final isSelected = _selectedTradeFilter == filter['id'];

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() => _selectedTradeFilter = filter['id']!),
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? primary : darkBg.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? primary : darkBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    filter['icon'] as IconData,
                                    size: 14,
                                    color: isSelected ? kBlack : primary,
                                  ),
                                  6.sBW,
                                  Text(
                                    filter['label'] as String,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected ? kBlack : kWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ).animate().fadeIn(delay: 150.ms),
                ],
              ),
            ),
          ),

          // Bottom Quick Book Overlay Card (Visible when no pin is selected)
          if (_selectedCaptain == null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: darkBg.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primary.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                            child: const Icon(Icons.flash_on_rounded, color: primary, size: 20),
                          ),
                          10.sBW,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nearest Captain: 6 Mins Away',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kWhite,
                                ),
                              ),
                              Text(
                                'Direct payment via UPI / Cash upon completion',
                                style: GoogleFonts.outfit(fontSize: 11, color: fontGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '₹450',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  14.sBH,
                  CustomButton(
                    text: 'Request Nearest Captain in 60s',
                    icon: Icons.send_rounded,
                    height: 48,
                    onPressed: () {
                      context.push(
                        AppRoutes.createBooking,
                        extra: {
                          'category': CategoryModel(id: 1, slug: 'plumber', name: 'Plumber Repair'),
                        },
                      );
                    },
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0),
          ),
        ],
      ),
    );
  }
}
