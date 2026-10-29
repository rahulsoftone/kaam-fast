class AppUrls {
  // Staging Base URL from KaamFast.staging.postman_environment.json
  static const String baseUrl = 'https://kaamfast.softonetech.in/api/v1';

  // Common Endpoints
  static const String health = '/health';
  static const String categories = '/categories';
  static const String ads = '/ads';
  static String adClick(String impressionId) => '/ads/$impressionId/click';
  static String adBanner(String bannerId) => '/ads/banners/$bannerId';
  static const String broadcastingAuth = '/broadcasting/auth';

  // Customer Auth
  static const String customerOtpRequest = '/customer/auth/otp/request';
  static const String customerOtpVerify = '/customer/auth/otp/verify';
  static const String customerLogout = '/customer/auth/logout';
  static const String customerMe = '/customer/me';
  static const String customerNotifications = '/customer/notifications';
  static const String customerNotificationsRead = '/customer/notifications/read';
  static const String customerPolicies = '/customer/policies';
  static const String customerPendingPolicies = '/customer/policies/pending';
  static String customerPolicy(String type) => '/customer/policies/$type';
  static String customerAcceptPolicy(String type) => '/customer/policies/$type/accept';

  // Customer Bookings
  static const String customerBookings = '/customer/bookings';
  static const String customerVoiceBooking = '/customer/bookings/voice';
  static String customerBooking(String bookingId) => '/customer/bookings/$bookingId';
  static String customerConfirmBooking(String bookingId) => '/customer/bookings/$bookingId/confirm';
  static String customerCancelBooking(String bookingId) => '/customer/bookings/$bookingId/cancel';
  static String customerRebook(String bookingId) => '/customer/bookings/$bookingId/rebook';
  static String customerArrivalCode(String bookingId) => '/customer/bookings/$bookingId/arrival-code';
  static String customerConfirmCompletion(String bookingId) => '/customer/bookings/$bookingId/confirm-completion';
  static String customerDispute(String bookingId) => '/customer/bookings/$bookingId/dispute';
  static String customerReportNoShow(String bookingId) => '/customer/bookings/$bookingId/report-no-show';
  static String customerRate(String bookingId) => '/customer/bookings/$bookingId/rate';
  static const String customerSos = '/customer/sos';
  static const String customerSupportTickets = '/customer/support-tickets';
  static const String customerReferral = '/customer/referral';
  static const String customerAppeal = '/customer/appeal';

  // Worker Auth & Profile
  static const String workerOtpRequest = '/worker/auth/otp/request';
  static const String workerOtpVerify = '/worker/auth/otp/verify';
  static const String workerLogout = '/worker/auth/logout';
  static const String workerMe = '/worker/me';
  static const String workerUpiVpa = '/worker/me/upi-vpa';
  static const String workerNotifications = '/worker/notifications';
  static const String workerNotificationsRead = '/worker/notifications/read';
  static const String workerKyc = '/worker/kyc';
  static const String workerDuty = '/worker/duty';
  static const String workerLocation = '/worker/location';

  // Worker Job Offers (45s window) & Execution
  static const String workerOffers = '/worker/offers';
  static String workerAcceptOffer(String bookingId) => '/worker/offers/$bookingId/accept';
  static String workerRejectOffer(String bookingId) => '/worker/offers/$bookingId/reject';
  static const String workerBookings = '/worker/bookings';
  static String workerBooking(String bookingId) => '/worker/bookings/$bookingId';
  static String workerEnRoute(String bookingId) => '/worker/bookings/$bookingId/en-route';
  static String workerArrived(String bookingId) => '/worker/bookings/$bookingId/arrived';
  static String workerVerifyArrival(String bookingId) => '/worker/bookings/$bookingId/verify-arrival';
  static String workerStartJob(String bookingId) => '/worker/bookings/$bookingId/start';
  static String workerRequestCompletion(String bookingId) => '/worker/bookings/$bookingId/request-completion';
  static String workerCancelJob(String bookingId) => '/worker/bookings/$bookingId/cancel';
  static String workerDispute(String bookingId) => '/worker/bookings/$bookingId/dispute';
  static String workerReportNoShow(String bookingId) => '/worker/bookings/$bookingId/report-no-show';

  // Worker Wallet & Subscriptions
  static const String workerWallet = '/worker/wallet';
  static const String workerWalletEntries = '/worker/wallet/entries';
  static const String workerWalletRecharges = '/worker/wallet/recharges';
  static String workerWalletRecharge(String rechargeId) => '/worker/wallet/recharges/$rechargeId';
  static const String workerInvoices = '/worker/invoices';
  static String workerInvoice(String invoiceId) => '/worker/invoices/$invoiceId';
  static const String workerSubscription = '/worker/subscription';
  static const String workerSubscriptionCancel = '/worker/subscription/cancel';

  // Worker Academy & Safety
  static const String workerCourses = '/worker/courses';
  static String workerCourse(String courseId) => '/worker/courses/$courseId';
  static String workerCourseAttempts(String courseId) => '/worker/courses/$courseId/attempts';
  static const String workerSos = '/worker/sos';
  static const String workerReferral = '/worker/referral';
  static const String workerAppeal = '/worker/appeal';

  // Aliases & Helper Endpoints
  static String customerRateBooking(String bookingId) => customerRate(bookingId);
  static const String notifications = '/notifications';
  static const String workerJobsHistory = '/worker/bookings/history';
  static const String workerMeUpiVpa = workerUpiVpa;
}
