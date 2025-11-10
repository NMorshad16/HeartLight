import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/ayah_item.dart';
import 'services/ayah_repo.dart';
import 'ui/theme.dart';

void main() => runApp(const HeartLightApp());

class HeartLightApp extends StatelessWidget {
  const HeartLightApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeartLight',
      theme: AppTheme.theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = AyahRepo();
  final ctrl = TextEditingController();
  bool ready = false;
  List<AyahItem> results = [];
  String query = "";

  @override
  void initState() {
    super.initState();
    repo.init().then((_) {
      setState(() {
        ready = true;
      });
    });
  }

  void _search(String q) {
    setState(() {
      query = q;
      results = repo.searchByEmotion(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    final grad = AppTheme.gradientFor(query);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: grad),
        child: SafeArea(
          child: !ready
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                      child: Text(
                        'HeartLight',
                        style: GoogleFonts.playfairDisplay(
                          textStyle: const TextStyle(
                            fontSize: 28, color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Type how you feel. We’ll bring an āyah that speaks to your heart.',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ctrl,
                              onSubmitted: _search,
                              decoration: InputDecoration(
                                hintText: 'sad, anxious, guilty, grateful…',
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.95),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _search(ctrl.text),
                            label: const Text('Find'),
                            icon: const Icon(Icons.search),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Quick emotion chips
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: repo.allEmotionQuickChips().map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              selected: query == e,
                              label: Text(e),
                              onSelected: (_) {
                                ctrl.text = e;
                                _search(e);
                              },
                              labelStyle: const TextStyle(color: Colors.black87),
                              selectedColor: Colors.white,
                              backgroundColor: Colors.white70,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: results.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text(
                                    'Type an emotion to see Qur’anic guidance.\nTry: “sad”, “anxious”, “guilty”, “lonely”, “rizq”, “patience”…',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                                itemBuilder: (_, i) => _AyahCard(item: results[i]),
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemCount: results.length,
                              ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AyahCard extends StatelessWidget {
  const _AyahCard({required this.item});
  final AyahItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF9FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.reference,
                    style: GoogleFonts.playfairDisplay(
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 6,
                  children: item.namesOfAllah.take(2).map((n) => Chip(
                    label: Text(n),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black12),
                  )).toList(),
                )
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                item.arabic,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.notoNaskhArabic(
                  textStyle: const TextStyle(fontSize: 22, height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.transliteration,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.translation,
              style: GoogleFonts.lora(textStyle: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 12),
            Text(
              item.explanation,
              style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 15, color: Colors.black87)),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dua: ${item.duaUse}',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
