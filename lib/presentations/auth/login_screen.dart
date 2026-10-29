import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/presentations/auth/bloc/auth_bloc.dart';
import 'package:kaam_fast/presentations/auth/bloc/auth_event.dart';
import 'package:kaam_fast/presentations/auth/bloc/auth_state.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/custom_widgets/custom_text_field.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, this.role = 'customer'});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RequestOtpEvent(
              phone: _phoneController.text.trim(),
              role: widget.role,
            ),
          );
    }
  }

  void _quickLogin() {
    context.read<AuthBloc>().add(
          QuickDemoLoginEvent(role: widget.role),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isWorker = widget.role == 'worker';
    final roleColor = isWorker ? kGreen : primary;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSentSuccess) {
          context.push(
            AppRoutes.otp,
            extra: {
              'phone': state.phone,
              'role': widget.role,
            },
          );
        } else if (state is AuthSuccess) {
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: roleColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isWorker ? Icons.handyman_rounded : Icons.person_rounded,
                            color: roleColor,
                            size: 16,
                          ),
                          6.sBW,
                          Text(
                            isWorker ? 'WORKER PARTNER LOGIN' : 'CUSTOMER LOGIN',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: roleColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideX(begin: -0.2, end: 0),

                    20.sBH,

                    Text(
                      'Enter your mobile\nnumber to continue',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kWhite,
                        height: 1.25,
                      ),
                    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2, end: 0),

                    10.sBH,

                    Text(
                      'We will send a 6-digit verification code to your phone via SMS.',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: fontGrey,
                      ),
                    ).animate().fadeIn(delay: 250.ms),

                    36.sBH,

                    // Phone input
                    CustomTextField(
                      controller: _phoneController,
                      hintText: '98765 43210',
                      labelText: 'MOBILE NUMBER',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Container(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+91',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kWhite,
                              ),
                            ),
                            8.sBW,
                            Container(width: 1, height: 22, color: darkBorder),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter mobile number';
                        }
                        if (value.trim().length < 10) {
                          return 'Enter valid 10-digit number';
                        }
                        return null;
                      },
                    ).animate().fadeIn(delay: 350.ms),

                    36.sBH,

                    CustomButton(
                      text: 'Send Verification OTP',
                      isLoading: isLoading,
                      backgroundColor: roleColor,
                      gradient: isWorker ? emeraldGradient : amberGradient,
                      onPressed: _submit,
                    ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2, end: 0),

                    18.sBH,

                    // 1-Tap Quick Demo Login Button
                    CustomButton(
                      text: isWorker ? '⚡ Quick Login as Partner (Skip OTP)' : '⚡ Quick Login as Customer (Skip OTP)',
                      isOutlined: true,
                      borderColor: roleColor.withValues(alpha: 0.6),
                      textColor: roleColor,
                      onPressed: _quickLogin,
                    ).animate().fadeIn(delay: 550.ms),

                    28.sBH,

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield_outlined, color: fontGrey.withValues(alpha: 0.7), size: 16),
                          6.sBW,
                          Text(
                            'Secured with Device Attestation & OTP',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: fontGrey.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
