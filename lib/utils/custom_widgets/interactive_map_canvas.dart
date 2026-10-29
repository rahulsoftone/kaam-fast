import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class MapTechnicianPin {
  final String id;
  final String name;
  final String trade;
  final String tradeSlug;
  final double rating;
  final int totalJobs;
  final LatLng position;
  final String eta;
  final int priceRupees;
  final IconData icon;

  const MapTechnicianPin({
    required this.id,
    required this.name,
    required this.trade,
    required this.tradeSlug,
    required this.rating,
    required this.totalJobs,
    required this.position,
    required this.eta,
    required this.priceRupees,
    required this.icon,
  });
}

class InteractiveMapCanvas extends StatefulWidget {
  final bool showTechnicians;
  final bool showTrackingRoute;
  final String? activeTechnicianName;
  final String? activeEta;
  final VoidCallback? onPinSelected;
  final ValueChanged<MapTechnicianPin?>? onPinChanged;
  final bool showControls;
  final bool showTopRadarBanner;
  final String? categoryFilter;

  const InteractiveMapCanvas({
    super.key,
    this.showTechnicians = true,
    this.showTrackingRoute = false,
    this.activeTechnicianName,
    this.activeEta,
    this.onPinSelected,
    this.onPinChanged,
    this.showControls = true,
    this.showTopRadarBanner = false,
    this.categoryFilter,
  });

  @override
  State<InteractiveMapCanvas> createState() => _InteractiveMapCanvasState();
}

class _InteractiveMapCanvasState extends State<InteractiveMapCanvas>
    with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;
  MapTechnicianPin? _selectedPin;
  bool _isDarkMap = true;

  // Customer Base Location (Sector 62, Noida)
  static const LatLng _customerLocation = LatLng(28.6280, 77.3760);

  // Live Navigation Polyline for Tracking Mode (Road route to Sector 62)
  static const List<LatLng> _routeCoordinates = [
    LatLng(28.6360, 77.3680), // Start: Captain position (near Electronic City)
    LatLng(28.6345, 77.3695),
    LatLng(28.6330, 77.3712),
    LatLng(28.6315, 77.3725),
    LatLng(28.6298, 77.3742),
    LatLng(28.6280, 77.3760), // Destination: Customer Location
  ];

  // Verified Nearby Technicians mapped to real Noida Sector 62 / 63 coordinates
  final List<MapTechnicianPin> _nearbyTechnicians = const [
    MapTechnicianPin(
      id: 't1',
      name: 'Captain Ramesh',
      trade: 'Plumber Pro',
      tradeSlug: 'plumber',
      rating: 4.9,
      totalJobs: 142,
      position: LatLng(28.6318, 77.3725),
      eta: '6 mins',
      priceRupees: 450,
      icon: Icons.plumbing_rounded,
    ),
    MapTechnicianPin(
      id: 't2',
      name: 'Captain Amit',
      trade: 'Electrician Pro',
      tradeSlug: 'electrician',
      rating: 4.8,
      totalJobs: 98,
      position: LatLng(28.6242, 77.3812),
      eta: '11 mins',
      priceRupees: 500,
      icon: Icons.electric_bolt_rounded,
    ),
    MapTechnicianPin(
      id: 't3',
      name: 'Captain Dinesh',
      trade: 'AC Specialist',
      tradeSlug: 'ac-technician',
      rating: 5.0,
      totalJobs: 215,
      position: LatLng(28.6355, 77.3692),
      eta: '9 mins',
      priceRupees: 650,
      icon: Icons.ac_unit_rounded,
    ),
    MapTechnicianPin(
      id: 't4',
      name: 'Captain Suresh',
      trade: 'Carpenter Master',
      tradeSlug: 'carpenter',
      rating: 4.7,
      totalJobs: 76,
      position: LatLng(28.6215, 77.3685),
      eta: '14 mins',
      priceRupees: 550,
      icon: Icons.carpenter_rounded,
    ),
    MapTechnicianPin(
      id: 't5',
      name: 'Captain Rajesh',
      trade: 'Painter Expert',
      tradeSlug: 'painter',
      rating: 4.9,
      totalJobs: 110,
      position: LatLng(28.6292, 77.3845),
      eta: '8 mins',
      priceRupees: 400,
      icon: Icons.format_paint_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, (currentZoom + 1).clamp(10.0, 18.0));
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, (currentZoom - 1).clamp(10.0, 18.0));
  }

  void _recenter() {
    _mapController.move(_customerLocation, 14.8);
    setState(() => _selectedPin = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📍 Map Recentered to Sector 62, Noida'),
        duration: Duration(milliseconds: 900),
        backgroundColor: primary,
      ),
    );
  }

  LatLng _calculateMovingPartnerPosition(double t) {
    if (_routeCoordinates.isEmpty) return _customerLocation;
    final totalSegments = _routeCoordinates.length - 1;
    final progress = t * totalSegments;
    final index = progress.floor().clamp(0, totalSegments - 1);
    final frac = progress - index;

    final p1 = _routeCoordinates[index];
    final p2 = _routeCoordinates[index + 1];

    return LatLng(
      p1.latitude + (p2.latitude - p1.latitude) * frac,
      p1.longitude + (p2.longitude - p1.longitude) * frac,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tileUrl = _isDarkMap
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    return Stack(
      fit: StackFit.expand,
      children: [
        // Real Interactive FlutterMap
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _customerLocation,
            initialZoom: 14.8,
            minZoom: 10.0,
            maxZoom: 18.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onTap: (tapPosition, point) {
              if (_selectedPin != null) {
                setState(() => _selectedPin = null);
                widget.onPinChanged?.call(null);
              }
            },
          ),
          children: [
            // Map Street Tiles
            TileLayer(
              urlTemplate: tileUrl,
              userAgentPackageName: 'com.example.kaam_fast',
              fallbackUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),

            // 3.5 km Radar Circle & Area Scan
            CircleLayer(
              circles: [
                CircleMarker(
                  point: _customerLocation,
                  radius: 1800, // 1.8km radius boundary
                  useRadiusInMeter: true,
                  color: primary.withValues(alpha: 0.08),
                  borderColor: primary.withValues(alpha: 0.4),
                  borderStrokeWidth: 1.5,
                ),
              ],
            ),

            // Live Navigation Polyline (for tracking route)
            if (widget.showTrackingRoute) ...[
              PolylineLayer(
                polylines: [
                  // Outer Glow
                  Polyline(
                    points: _routeCoordinates,
                    strokeWidth: 8.0,
                    color: primary.withValues(alpha: 0.3),
                  ),
                  // Inner High-Vis Line
                  Polyline(
                    points: _routeCoordinates,
                    strokeWidth: 4.0,
                    color: primary,
                  ),
                ],
              ),
            ],

            // Real Markers Layer
            MarkerLayer(
              markers: [
                // Customer Home Location Marker
                Marker(
                  point: _customerLocation,
                  width: 60,
                  height: 60,
                  child: _buildCustomerHomeMarker(),
                ),

                // Nearby Captain Markers (Only if showTechnicians is true)
                if (widget.showTechnicians) ...[
                  ..._nearbyTechnicians.where((tech) {
                    if (widget.categoryFilter == null || widget.categoryFilter == 'all') {
                      return true;
                    }
                    return tech.tradeSlug == widget.categoryFilter;
                  }).map((tech) {
                    final isSelected = _selectedPin?.id == tech.id;
                    return Marker(
                      point: tech.position,
                      width: 58,
                      height: 62,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedPin = tech);
                          widget.onPinSelected?.call();
                          widget.onPinChanged?.call(tech);
                          _mapController.move(tech.position, 15.2);
                        },
                        child: _buildTechnicianPinWidget(tech, isSelected),
                      ),
                    );
                  }),
                ],

                // Live Moving Partner Marker (when tracking active)
                if (widget.showTrackingRoute)
                  Marker(
                    point: _calculateMovingPartnerPosition(0.4),
                    width: 52,
                    height: 52,
                    child: _buildMovingPartnerMarker(),
                  ),
              ],
            ),
          ],
        ),

        // Live Radar Scanning Banner (Top-Center)
        if (widget.showTopRadarBanner)
          Positioned(
            top: 14,
            left: 16,
            right: 76,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: darkBg.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primary.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      return Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kGreen,
                          boxShadow: [
                            BoxShadow(
                              color: kGreen.withValues(
                                alpha: 0.3 + (0.7 * math.sin(_pulseController.value * math.pi)),
                              ),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  10.sBW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SECTOR 62, NOIDA • LIVE RADAR',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '${_nearbyTechnicians.length} Verified Pros Available Within 3.5 KM',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kWhite,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Floating Map Controls (Zoom, Recenter, Style Switcher)
        if (widget.showControls)
          Positioned(
            right: 16,
            top: widget.showTopRadarBanner ? 14 : 110,
            child: Column(
              children: [
                _mapActionButton(
                  icon: Icons.layers_rounded,
                  tooltip: 'Toggle Theme',
                  onTap: () {
                    setState(() => _isDarkMap = !_isDarkMap);
                  },
                  isAccent: _isDarkMap,
                ),
                8.sBH,
                _mapActionButton(
                  icon: Icons.add_rounded,
                  tooltip: 'Zoom In',
                  onTap: _zoomIn,
                ),
                8.sBH,
                _mapActionButton(
                  icon: Icons.remove_rounded,
                  tooltip: 'Zoom Out',
                  onTap: _zoomOut,
                ),
                8.sBH,
                _mapActionButton(
                  icon: Icons.my_location_rounded,
                  tooltip: 'Recenter GPS',
                  onTap: _recenter,
                  isAccent: true,
                ),
              ],
            ),
          ),

        // Selected Captain Detailed Bottom Card
        if (_selectedPin != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _buildSelectedCaptainCard(_selectedPin!),
          ),
      ],
    );
  }

  Widget _buildCustomerHomeMarker() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final scale = 1.0 + (0.25 * math.sin(_pulseController.value * 2 * math.pi));
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.2),
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: amberGradient,
                border: Border.all(color: kWhite, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.6),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.person_rounded, color: kBlack, size: 18),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTechnicianPinWidget(MapTechnicianPin tech, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ETA Badge Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: darkSurface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: isSelected ? primary : darkBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            tech.eta,
            style: GoogleFonts.outfit(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: isSelected ? primary : fontGrey,
            ),
          ),
        ),
        2.sBH,
        // Captain Avatar / Icon Circle
        Container(
          width: isSelected ? 40 : 34,
          height: isSelected ? 40 : 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isSelected ? amberGradient : emeraldGradient,
            border: Border.all(
              color: isSelected ? primary : kWhite,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? primary : kGreen).withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(tech.icon, color: isSelected ? kBlack : kWhite, size: isSelected ? 20 : 17),
        ),
      ],
    );
  }

  Widget _buildMovingPartnerMarker() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: amberGradient,
        border: Border.all(color: kWhite, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.6),
            blurRadius: 14,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.delivery_dining_rounded, color: kBlack, size: 24),
    );
  }

  Widget _buildSelectedCaptainCard(MapTechnicianPin pin) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: emeraldGradient,
                ),
                child: Icon(pin.icon, color: kWhite, size: 26),
              ),
              12.sBW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pin.name,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kWhite,
                          ),
                        ),
                        6.sBW,
                        const Icon(Icons.verified_rounded, color: kGreen, size: 16),
                      ],
                    ),
                    3.sBH,
                    Row(
                      children: [
                        Text(
                          pin.trade,
                          style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                        ),
                        8.sBW,
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        2.sBW,
                        Text(
                          '${pin.rating} (${pin.totalJobs} jobs)',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() => _selectedPin = null);
                  widget.onPinChanged?.call(null);
                },
                icon: const Icon(Icons.close_rounded, color: fontGrey, size: 20),
              ),
            ],
          ),
          12.sBH,
          const Divider(color: darkBorder),
          10.sBH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: primary, size: 16),
                  6.sBW,
                  Text(
                    'Arrives in ${pin.eta}',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ],
              ),
              Text(
                'Starting at ₹${pin.priceRupees}',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: kWhite,
                ),
              ),
            ],
          ),
          14.sBH,
          CustomButton(
            text: 'Direct Request Captain (${pin.eta})',
            icon: Icons.flash_on_rounded,
            height: 46,
            gradient: amberGradient,
            onPressed: () {
              context.push(
                AppRoutes.createBooking,
                extra: {
                  'category': CategoryModel(
                    id: 1,
                    slug: pin.tradeSlug,
                    name: pin.trade,
                  ),
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _mapActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isAccent = false,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isAccent ? primary : darkBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAccent ? primary : darkBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Icon(
            icon,
            color: isAccent ? kBlack : kWhite,
            size: 20,
          ),
        ),
      ),
    );
  }
}
