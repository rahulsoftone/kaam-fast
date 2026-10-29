import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/constants/size_box_extention.dart';
import 'package:kaam_fast/utils/custom_widgets/safe_navigation.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

class CustomerPoliciesScreen extends StatefulWidget {
  const CustomerPoliciesScreen({super.key});

  @override
  State<CustomerPoliciesScreen> createState() => _CustomerPoliciesScreenState();
}

class _CustomerPoliciesScreenState extends State<CustomerPoliciesScreen> {
  String _selectedLanguage = 'en'; // en, hi

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $label to clipboard!'),
        backgroundColor: primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = _selectedLanguage == 'hi';

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: const AppBackButton(fallbackRoute: AppRoutes.customerHome),
        title: Text(
          isHindi ? 'नीतियां और शिकायत निवारण' : 'Policies & Grievance',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: kWhite),
        ),
        actions: [
          // Language Switcher
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: darkSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: darkBorder),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _selectedLanguage = 'en'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: !isHindi ? primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'EN',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: !isHindi ? kBlack : fontGrey,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _selectedLanguage = 'hi'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isHindi ? primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'HI',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isHindi ? kBlack : fontGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grievance Officer Card (Mandatory as per Indian IT Rules)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primary.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.shield_rounded, color: primary, size: 24),
                      ),
                      12.sBW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isHindi ? 'शिकायत निवारण अधिकारी' : 'Grievance Officer (IT Rules)',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: kWhite,
                              ),
                            ),
                            2.sBH,
                            Text(
                              isHindi ? 'सूचना प्रौद्योगिकी नियम, 2021 के तहत' : 'Rule 3(2) Information Technology Rules 2021',
                              style: GoogleFonts.outfit(fontSize: 11, color: fontGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.sBH,
                  _officerDetailRow(
                    isHindi ? 'अधिकारी का नाम' : 'Officer Name',
                    'Mr. Rohan Mehta',
                  ),
                  8.sBH,
                  _officerDetailRow(
                    isHindi ? 'पद' : 'Designation',
                    'Head of Trust, Safety & Redressal',
                  ),
                  8.sBH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isHindi ? 'ईमेल' : 'Email',
                        style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
                      ),
                      InkWell(
                        onTap: () => _copyToClipboard('grievance@kaamfast.in', 'Grievance Email'),
                        child: Row(
                          children: [
                            Text(
                              'grievance@kaamfast.in',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: primary,
                              ),
                            ),
                            6.sBW,
                            const Icon(Icons.copy_rounded, color: primary, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  8.sBH,
                  _officerDetailRow(
                    isHindi ? 'प्रतिक्रिया समय (SLA)' : 'Response SLA',
                    isHindi ? '24 से 48 घंटे' : '24 to 48 Business Hours',
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            24.sBH,

            Text(
              isHindi ? 'प्लेटफॉर्म नीतियां व सुरक्षा' : 'Platform Policies & Safety',
              style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w700, color: kWhite),
            ),
            12.sBH,

            // Policy Accordions
            _policyAccordion(
              title: isHindi ? 'शून्य-एस्क्रो प्रत्यक्ष भुगतान नीति' : 'Zero-Escrow & Direct Payment Policy',
              icon: Icons.account_balance_wallet_rounded,
              content: isHindi
                  ? 'KaamFast ग्राहकों के पैसों को एस्क्रो में नहीं रखता। काम पूरा होने पर ग्राहक सीधे पार्टनर को UPI QR या नकद भुगतान करता है। KaamFast केवल ₹25 प्लेटफ़ॉर्म शुल्क लेता है।'
                  : 'KaamFast operates on a zero-escrow architecture. Customers pay service partners directly via UPI or Cash upon job completion. KaamFast never holds your service funds; the platform only levies a flat ₹25 fee from the partner.',
            ),
            12.sBH,

            _policyAccordion(
              title: isHindi ? 'बिना-आधार व डेटा गोपनीयता नीति' : 'No-Aadhaar & Data Privacy Policy',
              icon: Icons.lock_outline_rounded,
              content: isHindi
                  ? 'हम कभी भी आपका बायोमेट्रिक या पूर्ण आधार नंबर स्टोर नहीं करते। KYC केवल पैन कार्ड, वोटर आईडी या ड्राइविंग लाइसेंस द्वारा सुरक्षित रूप से सत्यापित किया जाता है।'
                  : 'We strictly follow Indian privacy guidelines. We do NOT store biometric or 12-digit Aadhaar numbers. Partner verification is performed via PAN, Driving Licence, or Voter ID with immediate redaction.',
            ),
            12.sBH,

            _policyAccordion(
              title: isHindi ? '45 सेकंड मैचिंग व कैंसलेशन नियम' : '45-Second Matching & Cancellation Rules',
              icon: Icons.timer_outlined,
              content: isHindi
                  ? 'जब ग्राहक बुकिंग बनाता है, तो निकटतम पार्टनर को 45 सेकंड का ऑफर भेजा जाता है। पार्टनर आने से पहले ग्राहक निःशुल्क कैंसिल कर सकता है।'
                  : 'Broadcast offers are issued to nearby verified partners with a 45-second timer. Customers can cancel free of charge prior to worker doorstep arrival.',
            ),
            12.sBH,

            _policyAccordion(
              title: isHindi ? 'आपातकालीन एसओएस सुरक्षा तंत्र' : 'Emergency SOS Rapid Response Protocol',
              icon: Icons.emergency_rounded,
              iconColor: kRed,
              content: isHindi
                  ? 'किसी भी अप्रत्याशित घटना या सुरक्षा संबंधी परेशानी होने पर तुरंत एसओएस दबाएं। यह तुरंत पुलिस (112) और KaamFast 24x7 रैपिड सपोर्ट टीम को अलर्ट करता है।'
                  : 'In case of any emergency or security risk during a service job, the SOS feature immediately coordinates with local authorities (Dial 112) and triggers real-time GPS telemetry to the KaamFast safety team.',
            ),

            28.sBH,

            // Version info footer
            Center(
              child: Column(
                children: [
                  Text(
                    'KaamFast Mobile v1.0.0 (Build 42)',
                    style: GoogleFonts.outfit(fontSize: 12, color: fontGrey),
                  ),
                  4.sBH,
                  Text(
                    'SoftOne Technologies Pvt. Ltd. • All Rights Reserved',
                    style: GoogleFonts.outfit(fontSize: 11, color: fontGrey.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),

            20.sBH,
          ],
        ),
      ),
    );
  }

  Widget _officerDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 13, color: fontGrey),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: kWhite),
        ),
      ],
    );
  }

  Widget _policyAccordion({
    required String title,
    required IconData icon,
    required String content,
    Color iconColor = primary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: darkBorder),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: kWhite,
            ),
          ),
          iconColor: primary,
          collapsedIconColor: fontGrey,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 18),
              child: Text(
                content,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: fontGrey,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
