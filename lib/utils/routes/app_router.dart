import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaam_fast/model/booking/booking_model.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/presentations/auth/login_screen.dart';
import 'package:kaam_fast/presentations/auth/otp_verification_screen.dart';
import 'package:kaam_fast/presentations/customer/booking/create_booking_screen.dart';
import 'package:kaam_fast/presentations/customer/policies/customer_policies_screen.dart';
import 'package:kaam_fast/presentations/customer/rating/customer_rating_screen.dart';
import 'package:kaam_fast/presentations/customer/shell/customer_main_shell.dart';
import 'package:kaam_fast/presentations/customer/tracking/live_tracking_screen.dart';
import 'package:kaam_fast/presentations/role_selection/role_selection_screen.dart';
import 'package:kaam_fast/presentations/shared/notifications/notifications_screen.dart';
import 'package:kaam_fast/presentations/shared/referral/refer_earn_screen.dart';
import 'package:kaam_fast/presentations/shared/sos/sos_emergency_screen.dart';
import 'package:kaam_fast/presentations/splash_screen/splash_screen.dart';
import 'package:kaam_fast/presentations/worker/courses/worker_courses_screen.dart';
import 'package:kaam_fast/presentations/worker/execution/worker_job_execution_screen.dart';
import 'package:kaam_fast/presentations/worker/history/worker_job_history_screen.dart';
import 'package:kaam_fast/presentations/worker/kyc/worker_kyc_screen.dart';
import 'package:kaam_fast/presentations/worker/profile/categories/worker_category_selection_screen.dart';
import 'package:kaam_fast/presentations/worker/shell/worker_main_shell.dart';
import 'package:kaam_fast/presentations/worker/subscription/worker_subscription_screen.dart';
import 'package:kaam_fast/presentations/worker/wallet/worker_wallet_screen.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelect,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RoleSelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final role = extra?['role']?.toString() ?? 'customer';
          return CustomTransitionPage(
            key: state.pageKey,
            child: LoginScreen(role: role),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(position: animation.drive(tween), child: child);
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.otp,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final phone = extra?['phone']?.toString() ?? '';
          final role = extra?['role']?.toString() ?? 'customer';
          return CustomTransitionPage(
            key: state.pageKey,
            child: OtpVerificationScreen(phone: phone, role: role),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              return SlideTransition(position: animation.drive(tween), child: child);
            },
          );
        },
      ),

      // Customer Dedicated Shell & Tabs
      GoRoute(
        path: AppRoutes.customerHome,
        builder: (context, state) => const CustomerMainShell(initialIndex: 0),
      ),
      GoRoute(
        path: AppRoutes.customerMap,
        builder: (context, state) => const CustomerMainShell(initialIndex: 1),
      ),
      GoRoute(
        path: AppRoutes.customerHistory,
        builder: (context, state) => const CustomerMainShell(initialIndex: 2),
      ),
      GoRoute(
        path: AppRoutes.customerProfile,
        builder: (context, state) => const CustomerMainShell(initialIndex: 3),
      ),

      // Customer Sub-flows
      GoRoute(
        path: AppRoutes.createBooking,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final cat = extra?['category'] as CategoryModel?;
          final isVoice = extra?['isVoice'] == true;
          return CustomTransitionPage(
            key: state.pageKey,
            child: CreateBookingScreen(initialCategory: cat, isVoice: isVoice),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              return SlideTransition(position: animation.drive(tween), child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.liveTracking}/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'demo_id';
          final extra = state.extra as Map<String, dynamic>?;
          final booking = extra?['booking'] as BookingModel?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: LiveTrackingScreen(bookingId: id, initialBooking: booking),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.customerRating,
        pageBuilder: (context, state) {
          final id = state.uri.queryParameters['bookingId'] ?? 'demo_booking';
          final service = state.uri.queryParameters['category'] ?? 'Home Service';
          final worker = state.uri.queryParameters['worker'] ?? 'Captain Ramesh Kumar';
          return CustomTransitionPage(
            key: state.pageKey,
            child: CustomerRatingScreen(bookingId: id, serviceName: service, workerName: worker),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.customerPolicies,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CustomerPoliciesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),

      // Worker Dedicated Shell & Tabs
      GoRoute(
        path: AppRoutes.workerDashboard,
        builder: (context, state) => const WorkerMainShell(initialIndex: 0),
      ),
      GoRoute(
        path: AppRoutes.workerJobs,
        builder: (context, state) => const WorkerMainShell(initialIndex: 1),
      ),
      GoRoute(
        path: AppRoutes.workerWalletPlans,
        builder: (context, state) => const WorkerMainShell(initialIndex: 2),
      ),
      GoRoute(
        path: AppRoutes.workerAcademy,
        builder: (context, state) => const WorkerMainShell(initialIndex: 3),
      ),

      // Worker Sub-flows & Standalone Screens
      GoRoute(
        path: AppRoutes.workerWallet,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WorkerWalletScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.workerKyc,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WorkerKycScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),
      GoRoute(
        path: '${AppRoutes.workerJobExecution}/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'demo_job';
          final extra = state.extra as Map<String, dynamic>?;
          final booking = extra?['booking'] as BookingModel?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: WorkerJobExecutionScreen(bookingId: id, initialBooking: booking),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.workerSubscription,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WorkerSubscriptionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.workerCourses,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WorkerCoursesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.workerCategories,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WorkerCategorySelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.workerHistory,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WorkerJobHistoryScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),

      // Shared Routes
      GoRoute(
        path: AppRoutes.sosEmergency,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final bookingId = extra?['bookingId']?.toString();
          final isWorker = extra?['isWorker'] == true;
          return CustomTransitionPage(
            key: state.pageKey,
            child: SosEmergencyScreen(bookingId: bookingId, isWorker: isWorker),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.referEarn,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ReferEarnScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end)), child: child);
          },
        ),
      ),
    ],
  );
}
