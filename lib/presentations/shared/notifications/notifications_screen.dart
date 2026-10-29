import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // job, wallet, promo, system
  final DateTime time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<NotificationModel> _notifications;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _notifications = [
      NotificationModel(
        id: 'n1',
        title: 'Partner Arrived at Doorstep!',
        message: 'Captain Ramesh Kumar has reached your location. Share your 4-digit code to start.',
        type: 'job',
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationModel(
        id: 'n2',
        title: '₹25 Wallet Deduction',
        message: 'Platform fee for accepted plumbing job #KF-9042 successfully deducted.',
        type: 'wallet',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      NotificationModel(
        id: 'n3',
        title: '🎉 ₹50 Referral Bonus Credited!',
        message: 'Your friend Rahul completed his first AC cleaning job. Enjoy ₹50 bonus in your balance.',
        type: 'promo',
        time: DateTime.now().subtract(const Duration(hours: 18)),
        isRead: true,
      ),
      NotificationModel(
        id: 'n4',
        title: 'Pro Certification Unlocked 🛡️',
        message: 'Congratulations! You completed all academy modules and earned the "Verified Pro" badge.',
        type: 'system',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: 'n5',
        title: '⚡ Weekend Peak Demand Alert',
        message: 'High demand in Sector 62 & Indirapuram. Turn duty ON to receive consecutive jobs.',
        type: 'job',
        time: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
    _fetchNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);
    try {
      await DioClient().get(AppUrls.notifications);
    } catch (_) {
      // Graceful fallback for staging
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: kGreen,
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'job':
        return Icons.handyman_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'promo':
        return Icons.card_giftcard_rounded;
      case 'system':
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'job':
        return primary;
      case 'wallet':
        return kGreen;
      case 'promo':
        return Colors.purpleAccent;
      case 'system':
      default:
        return accentBlue;
    }
  }

  String _formatRelativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

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
          'Notifications',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark All Read',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : Column(
              children: [
                // Tabs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                    labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 12),
                    unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 12),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Jobs'),
                      Tab(text: 'Wallet'),
                      Tab(text: 'System'),
                    ],
                  ),
                ),

                Expanded(
                  child: AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, _) {
                      List<NotificationModel> filtered;
                      if (_tabController.index == 1) {
                        filtered = _notifications.where((n) => n.type == 'job').toList();
                      } else if (_tabController.index == 2) {
                        filtered = _notifications.where((n) => n.type == 'wallet' || n.type == 'promo').toList();
                      } else if (_tabController.index == 3) {
                        filtered = _notifications.where((n) => n.type == 'system').toList();
                      } else {
                        filtered = _notifications;
                      }

                      if (filtered.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.notifications_off_outlined, color: fontGrey, size: 48),
                              12.sBH,
                              Text(
                                'No notifications here',
                                style: GoogleFonts.outfit(fontSize: 14, color: fontGrey),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: primary,
                        backgroundColor: darkSurface,
                        onRefresh: _fetchNotifications,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => 10.sBH,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            final color = _getTypeColor(item.type);
                            final icon = _getTypeIcon(item.type);

                            return Dismissible(
                              key: Key(item.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: kRed.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(Icons.delete_rounded, color: kWhite),
                              ),
                              onDismissed: (_) {
                                setState(() => _notifications.removeWhere((n) => n.id == item.id));
                              },
                              child: InkWell(
                                onTap: () => setState(() => item.isRead = true),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: item.isRead ? darkSurface : darkSurface.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: item.isRead ? darkBorder : color.withValues(alpha: 0.4),
                                      width: item.isRead ? 1.0 : 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(icon, color: color, size: 20),
                                      ),
                                      14.sBW,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.title,
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 14,
                                                      fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                                                      color: kWhite,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  _formatRelativeTime(item.time),
                                                  style: GoogleFonts.outfit(fontSize: 11, color: fontGrey),
                                                ),
                                              ],
                                            ),
                                            6.sBH,
                                            Text(
                                              item.message,
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                color: fontGrey,
                                                height: 1.35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!item.isRead) ...[
                                        10.sBW,
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ).animate(delay: (index * 50).ms).fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
