import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/presentations/worker/history/worker_job_history_screen.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class WorkerJobsTabScreen extends StatefulWidget {
  const WorkerJobsTabScreen({super.key});

  @override
  State<WorkerJobsTabScreen> createState() => _WorkerJobsTabScreenState();
}

class _WorkerJobsTabScreenState extends State<WorkerJobsTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: Text(
          'Active Orders & History',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Ongoing Job Banner (Live Execution Card)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F2B1F), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kGreen.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: kGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ACTIVE ONGOING JOB',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: kGreen,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      Text(
                        '#BK-9921',
                        style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                      ),
                    ],
                  ),
                  14.sBH,
                  Text(
                    'Plumbing Leakage Repair',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: kWhite),
                  ),
                  4.sBH,
                  Text(
                    'Flat 402, Lotus Boulevard, Sector 100, Noida',
                    style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                  ),
                  16.sBH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Direct Payment', style: GoogleFonts.outfit(fontSize: 11, color: fontGrey)),
                          2.sBH,
                          Text(
                            '₹450 (Cash/UPI)',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: kGreen,
                            ),
                          ),
                        ],
                      ),
                      12.sBW,
                      Flexible(
                        child: CustomButton(
                          text: 'Execution Flow',
                          icon: Icons.play_arrow_rounded,
                          height: 40,
                          gradient: emeraldGradient,
                          onPressed: () => context.push('${AppRoutes.workerJobExecution}/bk_live_99'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            24.sBH,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Job History & Past Earnings',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: kWhite),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.workerHistory),
                  child: Text(
                    'Full Ledger →',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
            8.sBH,

            // Embed Job History List
            const SizedBox(
              height: 480,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: WorkerJobHistoryScreen(),
              ),
            ),

            20.sBH,
          ],
        ),
      ),
    );
  }
}
