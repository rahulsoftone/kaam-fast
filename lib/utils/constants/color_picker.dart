import 'package:flutter/material.dart';

// Brand Primary & Accents (KaamFast Modern Lite Warm Orange Palette)
const Color primary = Color(0xFFFF7A1A); // Modern Lite Warm Orange (Figma Style)
const Color primaryDark = Color(0xFFEA580C); // Deep Sunset Orange
const Color primaryLight = Color(0xFFFF9E59); // Soft Peach Glow
const Color secondary = Color(0xFF0D9488); // Teal
const Color accentBlue = Color(0xFF2563EB); // Navigation Blue

// Dark Theme Surfaces
const Color darkBg = Color(0xFF0F172A); // Slate 900
const Color darkSurface = Color(0xFF1E293B); // Slate 800
const Color darkCard = Color(0xFF1E293B);
const Color darkBorder = Color(0xFF334155);

// Light Theme Surfaces
const Color lightBg = Color(0xFFF8FAFC);
const Color lightSurface = Colors.white;
const Color lightBorder = Color(0xFFE2E8F0);

// Status Colors
const Color kGreen = Color(0xFF10B981); // Emerald (Online, Success, Paid)
const Color kRed = Color(0xFFEF4444); // SOS Emergency, Expired
const Color kYellow = Color(0xFFF59E0B); // Pending, Warning
const Color kBlue = Color(0xFF3B82F6); // Info, En-route

// Common
const Color kWhite = Colors.white;
const Color kBlack = Colors.black;
const Color kTransparent = Colors.transparent;
const Color fontGrey = Color(0xFF94A3B8);
const Color fontDark = Color(0xFF0F172A);
const Color dividerColor = Color(0xFF334155);

// Gradients
const LinearGradient amberGradient = LinearGradient(
  colors: [Color(0xFFFF7A1A), Color(0xFFFF5200)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient darkCardGradient = LinearGradient(
  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient emeraldGradient = LinearGradient(
  colors: [Color(0xFF10B981), Color(0xFF059669)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient blueGradient = LinearGradient(
  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
