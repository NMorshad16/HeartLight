import 'package:flutter/material.dart';

Color _hex(String h) => Color(int.parse('FF${h.replaceAll('#','')}', radix: 16));

class AppTheme {
  static ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _hex('#5C7AEA')),
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
  );

  static LinearGradient gradientFor(String q) {
    q = q.toLowerCase();
    if (q.contains('sad') || q.contains('lonely') || q.contains('grief')) {
      return const LinearGradient(colors: [Color(0xFF1E3C72), Color(0xFF2A5298)]);
    }
    if (q.contains('anxious') || q.contains('fear')) {
      return const LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF2C5364)]);
    }
    if (q.contains('depress')) {
      return const LinearGradient(colors: [Color(0xFF232526), Color(0xFF414345)]);
    }
    if (q.contains('stressed') || q.contains('overwhelm')) {
      return const LinearGradient(colors: [Color(0xFF4568DC), Color(0xFFB06AB3)]);
    }
    if (q.contains('guilty') || q.contains('shame')) {
      return const LinearGradient(colors: [Color(0xFF20002c), Color(0xFFcbb4d4)]);
    }
    if (q.contains('angry') || q.contains('hurt')) {
      return const LinearGradient(colors: [Color(0xFFEB5757), Color(0xFFF2994A)]);
    }
    if (q.contains('grateful') || q.contains('happy') || q.contains('content')) {
      return const LinearGradient(colors: [Color(0xFFF6D365), Color(0xFFFDA085)]);
    }
    if (q.contains('rizq') || q.contains('money') || q.contains('job')) {
      return const LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)]);
    }
    if (q.contains('strength') || q.contains('courage')) {
      return const LinearGradient(colors: [Color(0xFF0f2027), Color(0xFF203A43), Color(0xFF2C5364)]);
    }
    if (q.contains('patience') || q.contains('sabr') || q.contains('hope')) {
      return const LinearGradient(colors: [Color(0xFF3a7bd5), Color(0xFF00d2ff)]);
    }
    // default serene sky
    return const LinearGradient(colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)]);
  }
}
