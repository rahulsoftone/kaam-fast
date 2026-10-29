import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/presentations/worker/subscription/worker_subscription_screen.dart';
import 'package:kaam_fast/presentations/worker/wallet/worker_wallet_screen.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

class WorkerWalletPlansTabScreen extends StatefulWidget {
  const WorkerWalletPlansTabScreen({super.key});

  @override
  State<WorkerWalletPlansTabScreen> createState() => _WorkerWalletPlansTabScreenState();
}

class _WorkerWalletPlansTabScreenState extends State<WorkerWalletPlansTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: Text(
          'Wallet & Subscriptions',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: darkSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: kBlack,
              unselectedLabelColor: fontGrey,
              labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Prepaid Wallet (₹25 Fee)'),
                Tab(text: 'Pro / Max Plans'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WorkerWalletScreen(isTab: true),
          WorkerSubscriptionScreen(isTab: true),
        ],
      ),
    );
  }
}
