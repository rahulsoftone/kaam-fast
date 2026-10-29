import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/button/custom_button.dart';

class CourseItem {
  final String id;
  final String title;
  final String category;
  final String duration;
  final int totalLessons;
  final int completedLessons;
  final bool isCertified;
  final String description;
  final List<String> keyPoints;

  CourseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.totalLessons,
    required this.completedLessons,
    required this.isCertified,
    required this.description,
    required this.keyPoints,
  });

  double get progress => totalLessons > 0 ? completedLessons / totalLessons : 0.0;
  bool get isCompleted => completedLessons >= totalLessons;
}

class WorkerCoursesScreen extends StatefulWidget {
  const WorkerCoursesScreen({super.key});

  @override
  State<WorkerCoursesScreen> createState() => _WorkerCoursesScreenState();
}

class _WorkerCoursesScreenState extends State<WorkerCoursesScreen> {
  bool _isLoading = false;
  late List<CourseItem> _courses;

  @override
  void initState() {
    super.initState();
    _courses = [
      CourseItem(
        id: 'c1',
        title: 'Customer Etiquette & 5-Star Service',
        category: 'Customer Delight',
        duration: '18 mins',
        totalLessons: 4,
        completedLessons: 4,
        isCertified: true,
        description: 'Master first impressions, professional communication, and earning top tips.',
        keyPoints: [
          'Greet with Namaste & confirm job description politely.',
          'Never enter private rooms without explicit customer permission.',
          'Clean up debris and leftover parts after finishing the job.',
        ],
      ),
      CourseItem(
        id: 'c2',
        title: 'Electrical Safety & Domestic Appliance Protocol',
        category: 'Technical Safety',
        duration: '25 mins',
        totalLessons: 5,
        completedLessons: 3,
        isCertified: false,
        description: 'Standard operating procedures for repairing high-voltage domestic appliances.',
        keyPoints: [
          'Always turn off the main MCB breaker before touching live terminals.',
          'Use ISI-certified insulated screwdrivers and testing pens.',
          'Verify earthing continuity with a multimeter.',
        ],
      ),
      CourseItem(
        id: 'c3',
        title: 'Rapid Response & 4-Digit Arrival Code',
        category: 'Platform Protocol',
        duration: '12 mins',
        totalLessons: 3,
        completedLessons: 3,
        isCertified: true,
        description: 'Understand zero-cancellation rules and seamless verification via 4-digit code.',
        keyPoints: [
          'Reach customer doorstep within 15-20 minutes of accepting.',
          'Ask the customer for their 4-digit code to start the timer.',
          'Direct UPI payment: Show your QR immediately after job completion.',
        ],
      ),
      CourseItem(
        id: 'c4',
        title: 'Smart Direct UPI & Instant Cash Handling',
        category: 'Finance & Payments',
        duration: '15 mins',
        totalLessons: 3,
        completedLessons: 0,
        isCertified: false,
        description: 'Collect 100% direct payment from customers with zero middleman deductions.',
        keyPoints: [
          'Customer pays you directly via UPI or Cash.',
          'KaamFast only charges ₹25 platform fee from your balance.',
          'Never ask customer for extra payment above the quoted amount.',
        ],
      ),
    ];
    _fetchCoursesFromApi();
  }

  Future<void> _fetchCoursesFromApi() async {
    setState(() => _isLoading = true);
    try {
      await DioClient().get(AppUrls.workerCourses);
    } catch (_) {
      // Graceful fallback to verified staged curriculum
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openCoursePlayer(CourseItem course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CourseDetailModal(
        course: course,
        onStartQuiz: () {
          Navigator.pop(ctx);
          _openQuizModal(course);
        },
      ),
    );
  }

  void _openQuizModal(CourseItem course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _QuizModal(
        course: course,
        onPassed: () {
          setState(() {
            final idx = _courses.indexWhere((c) => c.id == course.id);
            if (idx != -1) {
              _courses[idx] = CourseItem(
                id: course.id,
                title: course.title,
                category: course.category,
                duration: course.duration,
                totalLessons: course.totalLessons,
                completedLessons: course.totalLessons,
                isCertified: true,
                description: course.description,
                keyPoints: course.keyPoints,
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _courses.where((c) => c.isCompleted).length;
    final totalCount = _courses.length;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Learn & Earn Academy',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: kGreen, size: 14),
                4.sBW,
                Text(
                  'Verified Pro',
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: kGreen),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Certificate Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: primary.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.school_rounded, color: primary, size: 28),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: amberGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$completedCount / $totalCount Completed',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: kWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                        16.sBH,
                        Text(
                          'Certified Partner Badge',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: kWhite,
                          ),
                        ),
                        6.sBH,
                        Text(
                          'Trained partners receive 2x more job offers and are prioritized on customer search radars.',
                          style: GoogleFonts.outfit(fontSize: 13, color: fontGrey, height: 1.4),
                        ),
                        16.sBH,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: completedCount / totalCount,
                            minHeight: 8,
                            backgroundColor: darkBorder,
                            valueColor: const AlwaysStoppedAnimation<Color>(kGreen),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                  28.sBH,

                  Text(
                    'Available Training Modules',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: kWhite),
                  ),
                  4.sBH,
                  Text(
                    'Watch video guides, pass 3-question quiz & unlock your certification.',
                    style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                  ),

                  16.sBH,

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _courses.length,
                    separatorBuilder: (context, index) => 14.sBH,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return _buildCourseCard(course, index);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCourseCard(CourseItem course, int index) {
    return Container(
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: course.isCertified ? kGreen.withValues(alpha: 0.3) : darkBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openCoursePlayer(course),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        course.category.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primary,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          course.isCompleted ? Icons.check_circle_rounded : Icons.schedule_rounded,
                          size: 16,
                          color: course.isCompleted ? kGreen : fontGrey,
                        ),
                        6.sBW,
                        Text(
                          course.duration,
                          style: GoogleFonts.outfit(fontSize: 12, color: fontGrey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                12.sBH,
                Text(
                  course.title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kWhite,
                  ),
                ),
                6.sBH,
                Text(
                  course.description,
                  style: GoogleFonts.outfit(fontSize: 12, color: fontGrey, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                16.sBH,
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: course.progress,
                          minHeight: 6,
                          backgroundColor: darkBorder,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            course.isCompleted ? kGreen : primary,
                          ),
                        ),
                      ),
                    ),
                    12.sBW,
                    Text(
                      '${(course.progress * 100).toInt()}%',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: course.isCompleted ? kGreen : primary,
                      ),
                    ),
                  ],
                ),
                14.sBH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (course.isCertified)
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded, color: kGreen, size: 16),
                          6.sBW,
                          Text(
                            'Certificate Earned',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kGreen,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        '${course.completedLessons}/${course.totalLessons} Lessons Watched',
                        style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            course.isCompleted ? 'Review' : 'Continue',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: primary,
                            ),
                          ),
                          4.sBW,
                          const Icon(Icons.arrow_forward_rounded, color: primary, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (index * 80).ms).fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0);
  }
}

class _CourseDetailModal extends StatelessWidget {
  final CourseItem course;
  final VoidCallback onStartQuiz;

  const _CourseDetailModal({
    required this.course,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: fontGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Player Simulation Frame
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: darkBorder),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                primary.withValues(alpha: 0.3),
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary.withValues(alpha: 0.9),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: kWhite, size: 36),
                            ),
                            12.sBH,
                            Text(
                              'Watch Video Module (HD 1080p)',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: kWhite,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 12,
                          left: 16,
                          right: 16,
                          child: Row(
                            children: [
                              Text('04:20', style: GoogleFonts.outfit(fontSize: 11, color: kWhite)),
                              8.sBW,
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: const LinearProgressIndicator(
                                    value: 0.45,
                                    minHeight: 4,
                                    backgroundColor: Colors.white24,
                                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                                  ),
                                ),
                              ),
                              8.sBW,
                              Text(course.duration, style: GoogleFonts.outfit(fontSize: 11, color: kWhite)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  20.sBH,

                  Text(
                    course.title,
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: kWhite),
                  ),
                  8.sBH,
                  Text(
                    course.description,
                    style: GoogleFonts.outfit(fontSize: 13, color: fontGrey, height: 1.4),
                  ),

                  20.sBH,
                  const Divider(color: darkBorder),
                  16.sBH,

                  Text(
                    'Key Training Takeaways',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: kWhite),
                  ),
                  12.sBH,

                  ...course.keyPoints.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: kGreen, size: 18),
                          10.sBW,
                          Expanded(
                            child: Text(
                              point,
                              style: GoogleFonts.outfit(fontSize: 13, color: kWhite, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  24.sBH,
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: darkSurface,
              border: Border(top: BorderSide(color: darkBorder)),
            ),
            child: CustomButton(
              text: course.isCertified ? 'Re-take Certification Quiz' : 'Take 3-Question Quiz & Certify',
              icon: Icons.quiz_rounded,
              gradient: emeraldGradient,
              onPressed: onStartQuiz,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizModal extends StatefulWidget {
  final CourseItem course;
  final VoidCallback onPassed;

  const _QuizModal({
    required this.course,
    required this.onPassed,
  });

  @override
  State<_QuizModal> createState() => _QuizModalState();
}

class _QuizModalState extends State<_QuizModal> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _submitted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'When you arrive at the customer doorstep, what is your first step?',
      'options': [
        'Ask for payment immediately',
        'Politely ask for the 4-digit code and verify before starting',
        'Begin work without asking anything',
        'Ask customer for a cold drink',
      ],
      'correct': 1,
    },
    {
      'question': 'How does the customer pay for the job upon completion?',
      'options': [
        'Online to KaamFast escrow only',
        'They do not have to pay anything',
        'Directly to you via Cash or your UPI QR Code',
        'Through an international credit card only',
      ],
      'correct': 2,
    },
    {
      'question': 'What platform fee is charged per successfully accepted job?',
      'options': [
        '25% of the total amount',
        '₹25 flat deducted from your wallet',
        '₹100 fixed fee',
        'Zero fee forever',
      ],
      'correct': 1,
    },
  ];

  void _nextOrSubmit() {
    if (_selectedAnswer == null) return;

    if (_selectedAnswer == _questions[_currentQuestionIndex]['correct']) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      setState(() => _submitted = true);
      if (_score >= 2) {
        widget.onPassed();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPassed = _score >= 2;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: darkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: _submitted
          ? _buildResultView(isPassed)
          : Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: fontGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                      Text(
                        widget.course.title,
                        style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                      ),
                    ],
                  ),
                ),
                12.sBH,
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _questions[_currentQuestionIndex]['question'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kWhite,
                            height: 1.3,
                          ),
                        ),
                        24.sBH,
                        ...List.generate(
                          (_questions[_currentQuestionIndex]['options'] as List).length,
                          (idx) {
                            final isSelected = _selectedAnswer == idx;
                            final optionText = _questions[_currentQuestionIndex]['options'][idx] as String;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? primary.withValues(alpha: 0.15) : darkSurface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? primary : darkBorder,
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => setState(() => _selectedAnswer = idx),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected ? primary : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected ? primary : fontGrey,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? const Icon(Icons.check, color: kWhite, size: 16)
                                              : Center(
                                                  child: Text(
                                                    String.fromCharCode(65 + idx),
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: fontGrey,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        16.sBW,
                                        Expanded(
                                          child: Text(
                                            optionText,
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              color: isSelected ? kWhite : fontGrey,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: darkSurface,
                    border: Border(top: BorderSide(color: darkBorder)),
                  ),
                  child: CustomButton(
                    text: _currentQuestionIndex == _questions.length - 1 ? 'Submit Answers' : 'Next Question',
                    onPressed: _selectedAnswer != null ? _nextOrSubmit : null,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildResultView(bool isPassed) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isPassed ? kGreen : kRed).withValues(alpha: 0.15),
              border: Border.all(color: isPassed ? kGreen : kRed, width: 2),
            ),
            child: Icon(
              isPassed ? Icons.verified_rounded : Icons.replay_rounded,
              color: isPassed ? kGreen : kRed,
              size: 44,
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
          20.sBH,
          Text(
            isPassed ? 'Congratulations! 🎉' : 'Keep Trying!',
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: kWhite),
          ),
          8.sBH,
          Text(
            isPassed
                ? 'You scored $_score / ${_questions.length} and earned your "Verified Trained Partner" certification badge!'
                : 'You scored $_score / ${_questions.length}. You need at least 2 correct answers to unlock the badge.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 13, color: fontGrey, height: 1.4),
          ),
          28.sBH,
          CustomButton(
            text: isPassed ? 'Done & Claim Badge' : 'Retry Quiz',
            gradient: isPassed ? emeraldGradient : null,
            backgroundColor: isPassed ? null : darkSurface,
            onPressed: () {
              if (isPassed) {
                Navigator.pop(context);
              } else {
                setState(() {
                  _currentQuestionIndex = 0;
                  _selectedAnswer = null;
                  _score = 0;
                  _submitted = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
