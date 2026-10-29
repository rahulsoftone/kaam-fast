import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/presentations/splash_screen/bloc/splash_bloc.dart';
import 'package:kaam_fast/presentations/splash_screen/bloc/splash_event.dart';
import 'package:kaam_fast/presentations/splash_screen/bloc/splash_state.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(SplashInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          if (state.role == 'worker') {
            context.go(AppRoutes.workerDashboard);
          } else {
            context.go(AppRoutes.customerHome);
          }
        } else if (state is SplashNavigateToAuth) {
          context.go(AppRoutes.roleSelect);
        }
      },
      child: Scaffold(
        backgroundColor: darkBg,
        body: Stack(
          children: [
            // Ambient glowing gradient circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.15),
                ),
              ).animate().scale(duration: 2.seconds, curve: Curves.easeInOut),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondary.withValues(alpha: 0.15),
                ),
              ).animate().scale(duration: 2.seconds, curve: Curves.easeInOut),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon Container with Shimmer & Glow
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: amberGradient,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.45),
                          blurRadius: 35,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: kWhite,
                      size: 68,
                    ),
                  )
                      .animate()
                      .scale(duration: 800.ms, curve: Curves.elasticOut)
                      .shimmer(duration: 1200.ms, color: kWhite.withValues(alpha: 0.3)),

                  const SizedBox(height: 28),

                  // Brand Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kaam',
                        style: GoogleFonts.outfit(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: kWhite,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'Fast',
                        style: GoogleFonts.outfit(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: primary,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    'HYPERLOCAL • INSTANT • RELIABLE',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: fontGrey,
                      letterSpacing: 2.5,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 400.ms),

                  const SizedBox(height: 60),

                  // Circular Progress Indicator
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
