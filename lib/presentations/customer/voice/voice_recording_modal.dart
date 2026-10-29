import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class VoiceRecordingModal extends StatefulWidget {
  const VoiceRecordingModal({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'VoiceRecordingModal',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const VoiceRecordingModal();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<VoiceRecordingModal> createState() => _VoiceRecordingModalState();
}

class _VoiceRecordingModalState extends State<VoiceRecordingModal>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _waveController;
  Timer? _transcriptionTimer;

  int _transcriptionStep = 0;
  final List<String> _simulatedTranscriptions = [
    'Listening... Boliye aapko kya kaam karwana hai...',
    'Kitchen me tap leak ho raha hai...',
    'Kitchen me tap leak ho raha hai, Sector 62 me turant plumber bhejo!',
  ];

  @override
  void initState() {
    super.initState();
    // Expanding concentric circles animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Equalizer audio waveform animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Progressive real-time transcription simulation
    _transcriptionTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (mounted) {
        setState(() {
          if (_transcriptionStep < _simulatedTranscriptions.length - 1) {
            _transcriptionStep++;
          }
        });
      }
    });

    // Initial soft haptic on mic open
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _transcriptionTimer?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _playAlertChimeAndVibrate() async {
    for (int i = 0; i < 3; i++) {
      SystemSound.play(SystemSoundType.alert);
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 260));
    }
  }

  void _sendVoiceRequest() async {
    Navigator.pop(context); // Close voice modal

    // Play loud alert sounds & vibration
    _playAlertChimeAndVibrate();

    // Show broadcast notification banner on customer screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: darkSurface,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: primary, width: 1.5),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: amberGradient,
              ),
              child: const Icon(Icons.podcasts_rounded, color: kWhite, size: 20),
            ),
            12.sBW,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VOICE BROADCAST DISPATCHED!',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  2.sBH,
                  Text(
                    'Alert sound & job offer ringing on 4 nearby Captains in 3.5 km.',
                    style: GoogleFonts.outfit(fontSize: 11, color: kWhite),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Navigate to Live Tracking screen with voice order
    context.push(
      '${AppRoutes.liveTracking}/bk_voice_101',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: primary.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.25),
              blurRadius: 36,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Bar: Live GPS Radar Badge & Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primary.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kGreen,
                        ),
                      ),
                      6.sBW,
                      Text(
                        'AI VOICE RADAR • NOIDA 62',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: fontGrey, size: 22),
                ),
              ],
            ),

            20.sBH,

            Text(
              'Bol Kar Kaam Order Karein',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: kWhite,
              ),
            ),
            6.sBH,
            Text(
              'Just speak naturally in Hindi or English.\nNearest verified worker will be alerted instantly.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 12, color: fontGrey, height: 1.3),
            ),

            32.sBH,

            // CENTER BADA MIC WITH CONCENTRIC EXPANDING RIPPLE WAVES
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated Concentric Expanding Pulse Rings
                  ...List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        final progress = (_pulseController.value + (index * 0.33)) % 1.0;
                        final radius = 90 + (120 * progress);
                        final opacity = (1.0 - progress).clamp(0.0, 1.0);

                        return Container(
                          width: radius,
                          height: radius,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primary.withValues(alpha: opacity * 0.6),
                              width: 2.0,
                            ),
                            color: primary.withValues(alpha: opacity * 0.08),
                          ),
                        );
                      },
                    );
                  }),

                  // Center Big Glowing Mic Button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: amberGradient,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.6),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic_rounded,
                        color: kWhite,
                        size: 48,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            14.sBH,

            // Animated Equalizer Audio Waveform Visualizer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(18, (index) {
                return AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, _) {
                    final factor = math.sin((_waveController.value * math.pi) + (index * 0.4)).abs();
                    final barHeight = 8.0 + (factor * 32.0);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.2),
                      width: 3.5,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: amberGradient,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            20.sBH,

            // Live Transcription Display Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: darkBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.record_voice_over_rounded, color: primary, size: 16),
                      8.sBW,
                      Text(
                        'LIVE TRANSCRIPTION',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: fontGrey,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  8.sBH,
                  Text(
                    '"${_simulatedTranscriptions[_transcriptionStep]}"',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kWhite,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (_transcriptionStep == 2) ...[
                    8.sBH,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Detected: Plumber Repair • Direct Payment ₹450',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: kGreen,
                        ),
                      ),
                    ).animate().fadeIn(),
                  ],
                ],
              ),
            ),

            24.sBH,

            // Bottom Action: Send Voice Request Button
            CustomButton(
              text: 'Broadcast Voice Alert to Captains',
              icon: Icons.send_rounded,
              height: 52,
              gradient: amberGradient,
              onPressed: _sendVoiceRequest,
            ),
          ],
        ),
      ),
    );
  }
}
