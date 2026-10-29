import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/presentations/customer/history/customer_bookings_history_screen.dart';
import 'package:kaam_fast/presentations/customer/home/customer_home_screen.dart';
import 'package:kaam_fast/presentations/customer/map/customer_live_map_screen.dart';
import 'package:kaam_fast/presentations/customer/profile/customer_profile_screen.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

class CustomerMainShell extends StatefulWidget {
  final int initialIndex;

  const CustomerMainShell({super.key, this.initialIndex = 0});

  @override
  State<CustomerMainShell> createState() => _CustomerMainShellState();
}

class _CustomerMainShellState extends State<CustomerMainShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    CustomerHomeScreen(),
    CustomerLiveMapScreen(),
    CustomerBookingsHistoryScreen(isTab: true),
    CustomerProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && mounted) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
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
                _navItem(0, Icons.home_rounded, 'Explore'),
                _navItem(1, Icons.map_rounded, 'Live Map'),
                _navItem(2, Icons.assignment_rounded, 'Bookings'),
                _navItem(3, Icons.person_rounded, 'Account'),
              ],
            ),
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
          color: isSelected ? primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primary : fontGrey,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
