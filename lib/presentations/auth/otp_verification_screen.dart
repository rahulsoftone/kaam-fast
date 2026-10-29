import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/utils/custom_widgets/custom_pin_input.dart';
import 'package:kaam_fast/presentations/auth/bloc/auth_bloc.dart';
import 'package:kaam_fast/presentations/auth/bloc/auth_event.dart';
import 'package:kaam_fast/presentations/auth/bloc/auth_state.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/safe_navigation.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final String role;

  const OtpVerificationScreen({
    super.key,
    required this.phone,
    required this.role,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _pinController = TextEditingController(text: '123456');
  int _timerSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _timerSeconds = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _verifyOtp(String otp) {
    context.read<AuthBloc>().add(
          VerifyOtpEvent(
            phone: widget.phone,
            otp: otp.isEmpty ? '123456' : otp,
            role: widget.role,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isWorker = widget.role == 'worker';
    final roleColor = isWorker ? kGreen : primary;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (widget.role == 'worker') {
            context.go(AppRoutes.workerDashboard);
          } else {
            context.go(AppRoutes.customerHome);
          }
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage, style: GoogleFonts.outfit()),
              backgroundColor: kRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: darkBg,
          appBar: AppBar(
            backgroundColor: darkBg,
            elevation: 0,
            leading: AppBackButton(
              onPressed: () => SafeNav.popOrFallback(
                context,
                fallbackRoute: AppRoutes.login,
                extra: {'role': widget.role},
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify Code',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: kWhite,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                  10.sBH,

                  RichText(
                    text: TextSpan(
                      text: 'Enter the 6-digit code sent to ',
                      style: GoogleFonts.outfit(fontSize: 14, color: fontGrey),
                      children: [
                        TextSpan(
                          text: widget.phone,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 150.ms),

                  14.sBH,

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: roleColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: roleColor, size: 16),
                        8.sBW,
                        Expanded(
                          child: Text(
                            'Testing Tip: Enter any 6 digits (e.g. 123456) to proceed.',
                            style: GoogleFonts.outfit(fontSize: 12, color: roleColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  30.sBH,

                  // Custom PIN input field
                  Center(
                    child: CustomPinInput(
                      length: 6,
                      controller: _pinController,
                      boxWidth: 46,
                      boxHeight: 52,
                      autofocus: true,
                      onCompleted: (pin) => _verifyOtp(pin),
                    ),
                  ).animate().fadeIn(delay: 250.ms).scale(begin: const Offset(0.9, 0.9)),

                  36.sBH,

                  CustomButton(
                    text: 'Verify & Enter App',
                    isLoading: isLoading,
                    backgroundColor: roleColor,
                    gradient: isWorker ? emeraldGradient : amberGradient,
                    onPressed: () => _verifyOtp(_pinController.text.trim()),
                  ).animate().fadeIn(delay: 350.ms),

                  28.sBH,

                  // Resend Code Timer
                  Center(
                    child: _timerSeconds > 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.timer_outlined, color: fontGrey, size: 16),
                              6.sBW,
                              Text(
                                'Resend code in ${_timerSeconds}s',
                                style: GoogleFonts.outfit(fontSize: 14, color: fontGrey),
                              ),
                            ],
                          )
                        : TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    RequestOtpEvent(
                                      phone: widget.phone,
                                      role: widget.role,
                                    ),
                                  );
                              _startTimer();
                            },
                            child: Text(
                              'Resend Code',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: roleColor,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
