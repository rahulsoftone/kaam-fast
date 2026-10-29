import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/model/worker/worker_offer_model.dart';
import 'package:kaam_fast/presentations/worker/offers/bloc/offer_timer_bloc.dart';
import 'package:kaam_fast/presentations/worker/offers/bloc/offer_timer_event.dart';
import 'package:kaam_fast/presentations/worker/offers/bloc/offer_timer_state.dart';
import 'package:kaam_fast/utils/constants/app_constants.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';

class OfferCountdownModal extends StatefulWidget {
  final WorkerOfferModel offer;

  const OfferCountdownModal({super.key, required this.offer});

  static Future<void> show(BuildContext context, WorkerOfferModel offer) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => OfferTimerBloc()..add(StartTimerEvent(totalSeconds: offer.secondsLeft)),
        child: OfferCountdownModal(offer: offer),
      ),
    );
  }

  @override
  State<OfferCountdownModal> createState() => _OfferCountdownModalState();
}

class _OfferCountdownModalState extends State<OfferCountdownModal> {
  @override
  void initState() {
    super.initState();
    _playIncomingOfferAlert();
  }

  Future<void> _playIncomingOfferAlert() async {
    for (int i = 0; i < 4; i++) {
      SystemSound.play(SystemSoundType.alert);
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 320));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OfferTimerBloc, OfferTimerState>(
      listener: (context, state) {
        if (state is OfferTimerExpired) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offer expired. You were not charged.'),
              backgroundColor: darkSurface,
            ),
          );
        } else if (state is OfferAcceptedSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🎉 Job Won! Flat ${AppConstants.paiseToRupees(state.feeChargedPaise)} fee deducted from wallet.',
              ),
              backgroundColor: kGreen,
            ),
          );
        } else if (state is OfferAcceptFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: kRed,
            ),
          );
        } else if (state is OfferRejectedState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        int secondsLeft = widget.offer.secondsLeft;
        double progress = 1.0;

        if (state is OfferTimerRunning) {
          secondsLeft = state.secondsLeft;
          progress = state.progress;
        }

        final isUrgent = secondsLeft <= 10;
        final timerColor = isUrgent ? kRed : primary;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: darkSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: timerColor.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: timerColor.withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header & Countdown Circle
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: darkBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$secondsLeft',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: timerColor,
                        ),
                      ),
                      Text(
                        'SECS',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: fontGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate(target: isUrgent ? 1 : 0).shake(duration: 400.ms),

              20.sBH,

              // Fast Opportunity Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '⚡ FAST JOB OFFER • FIRST ACCEPT WINS',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: primary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),

              18.sBH,

              // Payout & Category
              Text(
                AppConstants.paiseToRupees(widget.offer.offeredAmountPaise),
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: kWhite,
                ),
              ),
              6.sBH,
              Text(
                widget.offer.category?.name ?? 'Service Booking',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),

              16.sBH,

              // Distance & Address
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: darkBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: darkBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: primary, size: 24),
                    12.sBW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.offer.formattedDistance,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: kWhite,
                            ),
                          ),
                          4.sBH,
                          Text(
                            widget.offer.addressText ?? 'Nearby location',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              14.sBH,

              // Fee Notice
              Text(
                '₹25 fee will be charged from your prepaid wallet only if you win this job.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
              ),

              24.sBH,

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      text: 'Decline',
                      isOutlined: true,
                      borderColor: fontGrey,
                      textColor: fontGrey,
                      onPressed: () {
                        context.read<OfferTimerBloc>().add(
                              RejectOfferEvent(bookingId: widget.offer.bookingId),
                            );
                      },
                    ),
                  ),
                  12.sBW,
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'ACCEPT JOB NOW',
                      isLoading: state is OfferAccepting,
                      backgroundColor: kGreen,
                      gradient: emeraldGradient,
                      onPressed: () {
                        context.read<OfferTimerBloc>().add(
                              AcceptOfferEvent(bookingId: widget.offer.bookingId),
                            );
                      },
                    ),
                  ),
                ],
              ),

              12.sBH,
            ],
          ),
        );
      },
    );
  }
}
