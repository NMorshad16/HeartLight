class AyahItem {
  final String id;
  final List<String> emotionTags;
  final String reference; // e.g., "Ad-Duḥā 93:1–11"
  final String arabic;
  final String transliteration;
  final String translation;
  final String explanation;
  final String duaUse;
  final List<String> namesOfAllah; // optional pairings

  AyahItem({
    required this.id,
    required this.emotionTags,
    required this.reference,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.explanation,
    required this.duaUse,
    required this.namesOfAllah,
  });

  factory AyahItem.fromJson(Map<String, dynamic> j) => AyahItem(
        id: j["id"],
        emotionTags: List<String>.from(j["emotion_tags"]),
        reference: j["reference"],
        arabic: j["arabic"],
        transliteration: j["transliteration"],
        translation: j["translation"],
        explanation: j["explanation"],
        duaUse: j["dua_use"],
        namesOfAllah: List<String>.from(j["names_of_allah"] ?? const []),
      );
}
