import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/presentations/worker/courses/worker_courses_screen.dart';
import 'package:kaam_fast/presentations/worker/profile/categories/worker_category_selection_screen.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

class WorkerAcademyTabScreen extends StatefulWidget {
  const WorkerAcademyTabScreen({super.key});

  @override
  State<WorkerAcademyTabScreen> createState() => _WorkerAcademyTabScreenState();
}

class _WorkerAcademyTabScreenState extends State<WorkerAcademyTabScreen>
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
          'Academy & Skills Setup',
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
                color: kGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: kWhite,
              unselectedLabelColor: fontGrey,
              labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Learn & Earn Academy'),
                Tab(text: 'Skills & Direct UPI'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WorkerCoursesScreen(isTab: true),
          WorkerCategorySelectionScreen(isTab: true),
        ],
      ),
    );
  }
}
