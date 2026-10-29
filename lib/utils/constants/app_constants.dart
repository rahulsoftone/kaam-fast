import 'package:intl/intl.dart';

class AppConstants {
  static const String appName = 'KaamFast';
  static const String appTagline = 'Fast • Reliable • Hyperlocal';

  // Money converter: KaamFast backend handles integer paise (e.g. 5000 paise = ₹50)
  static String paiseToRupees(int? paise) {
    if (paise == null) return '₹0';
    final rupees = paise / 100.0;
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: rupees % 1 == 0 ? 0 : 2);
    return formatter.format(rupees);
  }

  static String formatPaise(int? paise) => paiseToRupees(paise);

  static int rupeesToPaise(num rupees) {
    return (rupees * 100).toInt();
  }

  // Duration in hours & minutes
  static String formatDurationMinutes(int? minutes) {
    if (minutes == null || minutes <= 0) return '0 min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0 && mins > 0) return '$hours hr $mins min';
    if (hours > 0) return '$hours hr';
    return '$mins min';
  }
}
