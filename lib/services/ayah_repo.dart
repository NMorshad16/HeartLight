import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/ayah_item.dart';

class AyahRepo {
  List<AyahItem> _all = [];

  Future<void> init() async {
    final raw = await rootBundle.loadString('assets/quran_emotion_map.json');
    final list = json.decode(raw) as List;
    _all = list.map((e) => AyahItem.fromJson(e)).toList();
  }

  List<AyahItem> searchByEmotion(String input) {
    final q = input.toLowerCase().trim();
    if (q.isEmpty) return [];
    bool match(AyahItem a) {
      // fuzzy contains + any-word overlap
      if (a.emotionTags.any((t) => t.contains(q) || q.contains(t))) return true;
      final parts = q.split(RegExp(r'[\s,;]+'));
      return a.emotionTags.any((t) => parts.any((p) => p.isNotEmpty && t.startsWith(p)));
    }
    final res = _all.where(match).toList();
    // Basic prioritization: shorter tag hits first
    res.sort((a, b) => a.emotionTags.length.compareTo(b.emotionTags.length));
    return res;
  }

  List<String> allEmotionQuickChips() {
    final set = <String>{};
    for (final a in _all) {
      if (a.emotionTags.isNotEmpty) set.add(a.emotionTags.first);
    }
    // Curated quick list to ensure coverage
    final curated = [
      "sad", "anxious", "depressed", "lonely",
      "stressed", "guilty", "angry", "confused",
      "grateful", "happy", "strength", "rizq",
      "patience", "hope"
    ];
    set.addAll(curated);
    final list = set.toList();
    list.sort();
    return list;
  }
}
