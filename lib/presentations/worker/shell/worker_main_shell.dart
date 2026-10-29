import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/presentations/worker/academy/worker_academy_tab_screen.dart';
import 'package:kaam_fast/presentations/worker/dashboard/worker_dashboard_screen.dart';
import 'package:kaam_fast/presentations/worker/jobs/worker_jobs_tab_screen.dart';
import 'package:kaam_fast/presentations/worker/wallet/worker_wallet_plans_tab_screen.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

class WorkerMainShell extends StatefulWidget {
  final int initialIndex;

  const WorkerMainShell({super.key, this.initialIndex = 0});

  @override
  State<WorkerMainShell> createState() => _WorkerMainShellState();
}

class _WorkerMainShellState extends State<WorkerMainShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    WorkerDashboardScreen(),
    WorkerJobsTabScreen(),
    WorkerWalletPlansTabScreen(),
    WorkerAcademyTabScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: darkSurface,
          border: const Border(top: BorderSide(color: darkBorder, width: 1.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.radar_rounded, 'Duty Radar'),
                _navItem(1, Icons.handyman_rounded, 'My Jobs'),
                _navItem(2, Icons.account_balance_wallet_rounded, 'Wallet'),
                _navItem(3, Icons.school_rounded, 'Academy'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kGreen.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? kGreen : fontGrey,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: kGreen,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
