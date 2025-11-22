import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:zion_final/models/songs_model.dart';
import 'package:zion_final/services/API_services.dart';

class SongsListView extends StatefulWidget {
  const SongsListView({super.key});

  @override
  State<SongsListView> createState() => _SongsListViewState();
}

class _SongsListViewState extends State<SongsListView>
    with TickerProviderStateMixin {
  LanguageList? languageList;
  bool isLoaded = false;
  bool apiError = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final fetchedData = await FetchingLanguagesServices().getLaguages();
      setState(() {
        languageList = fetchedData;
        isLoaded = true;
        apiError = fetchedData == null;
      });
    } catch (e) {
      setState(() {
        isLoaded = true;
        apiError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // dark canvas for neon
      backgroundColor: const Color(0xFF070812),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildHeader(context),
            const SizedBox(height: 8),
            Expanded(
              child: isLoaded == false
                  ? _buildGlassSkeletonGrid() // loading skeleton
                  : apiError
                      ? _buildGlassSkeletonGrid() // skeleton on error
                      : (languageList == null || languageList!.data.isEmpty)
                          ? const Center(
                              child: Text(
                                'No languages available',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : _buildDataGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            'Languages',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Colors.purpleAccent.withOpacity(0.25),
                  blurRadius: 14,
                )
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () async {
              setState(() {
                isLoaded = false;
                apiError = false;
              });
              await getData();
            },
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          )
        ],
      ),
    );
  }

  /// ---------------------- GLASSMORPHIC SKELETON ----------------------
  Widget _buildGlassSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        return _GlassSkeletonCard();
      },
    );
  }

  /// ------------------------- DATA GRID ------------------------------
  Widget _buildDataGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: languageList!.data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final lang = languageList!.data[index];
        return Neon3DCard(
          heroTag: 'lang_$index',
          title: lang.languages,
          subtitle: lang.languageCode,
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 420),
                reverseTransitionDuration: const Duration(milliseconds: 380),
                pageBuilder: (context, a1, a2) => FadeTransition(
                  opacity: a1,
                  child: SongDetailPage(
                    itemIndex: index,
                    languageCode: lang.languageCode,
                    language: lang.languages,
                    heroTag: 'lang_$index',
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// ===============================================================
/// Glass skeleton card: blur + frosted panel + shimmer
/// ===============================================================
class _GlassSkeletonCard extends StatelessWidget {
  const _GlassSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          // blurred background piece
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.04)),
              ),
            ),
          ),

          // shimmer layer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade900,
            highlightColor: Colors.grey.shade700,
            child: Container(
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),

          // soft inner card shape to emulate content
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 86,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 16,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.025),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// Neon3DCard: gradient neon, tilt, bounce on tap, glow, reflection
/// ===============================================================
class Neon3DCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String heroTag;

  const Neon3DCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.heroTag,
    super.key,
  });

  @override
  State<Neon3DCard> createState() => _Neon3DCardState();
}

class _Neon3DCardState extends State<Neon3DCard>
    with SingleTickerProviderStateMixin {
  double tiltX = 0;
  double tiltY = 0;
  double pointerX = 0;
  double pointerY = 0;
  bool pressed = false;

  late final AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onPointerMove(Offset localPos, Size size) {
    final dx = (localPos.dx - size.width / 2) / (size.width / 2);
    final dy = (localPos.dy - size.height / 2) / (size.height / 2);
    setState(() {
      tiltY = -dx * 0.12; // smaller tilt amounts
      tiltX = dy * 0.12;
      pointerX = dx;
      pointerY = dy;
    });
  }

  void _resetTilt() {
    setState(() {
      tiltX = 0;
      tiltY = 0;
      pointerX = 0;
      pointerY = 0;
    });
  }

  void _onTapDown(_) {
    setState(() {
      pressed = true;
    });
    _pressController.forward();
  }

  void _onTapUp(_) {
    _pressController.reverse().then((_) {
      if (mounted) setState(() => pressed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // neon gradient colors (Purple -> Blue)
    final Gradient neonGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF8A2BE2).withOpacity(0.95),
        const Color(0xFF6A5ACD).withOpacity(0.95),
        const Color(0xFF00BFFF).withOpacity(0.95),
      ],
      stops: const [0.0, 0.45, 1.0],
    );

    return LayoutBuilder(builder: (context, constraints) {
      final cardSize = Size(constraints.maxWidth, constraints.maxHeight);
      return Listener(
        onPointerMove: (e) {
          _onPointerMove(e.localPosition, cardSize);
        },
        onPointerHover: (e) {
          // for desktop hover
          _onPointerMove(e.localPosition, cardSize);
        },
        onPointerUp: (_) => _resetTilt(),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: (d) {
            _onTapUp(d);
            widget.onTap();
          },
          onTapCancel: () {
            _pressController.reverse();
            setState(() => pressed = false);
          },
          child: AnimatedBuilder(
            animation: _pressController,
            builder: (context, child) {
              final scale = 1 - _pressController.value;
              final elevationTranslate = 12 * (1 - _pressController.value);

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015)
                  ..rotateX(tiltX)
                  ..rotateY(tiltY)
                  ..scale(scale),
                child: Stack(
                  children: [
                    // Glow shadow behind the card
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(pointerX * 8, pointerY * 8),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.14),
                                blurRadius: 36,
                                spreadRadius: 6,
                                offset: Offset(pointerX * 6, pointerY * 6),
                              ),
                              BoxShadow(
                                color: Colors.lightBlueAccent.withOpacity(0.08),
                                blurRadius: 60,
                                spreadRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // The "card"
                    Center(
                      child: Hero(
                        tag: widget.heroTag,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: neonGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.45),
                                  blurRadius: 24,
                                  offset: Offset(0, elevationTranslate),
                                ),
                                BoxShadow(
                                  color: Colors.purpleAccent.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: Offset(-6, -6),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // subtle moving reflection
                                Positioned(
                                  left: -60 + pointerX * 30,
                                  top: -40 + pointerY * 20,
                                  child: Transform.rotate(
                                    angle: -pi / 6,
                                    child: Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.06),
                                            Colors.white.withOpacity(0.02),
                                            Colors.transparent
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                    ),
                                  ),
                                ),

                                // frosted glass strip for title contrast
                                Positioned(
                                  left: 12,
                                  right: 12,
                                  bottom: 12,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 8, sigmaY: 8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // small circular neon icon
                                            Container(
                                              width: 44,
                                              height: 44,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white
                                                        .withOpacity(0.12),
                                                    Colors.white
                                                        .withOpacity(0.04),
                                                  ],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  )
                                                ],
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.music_note_rounded,
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    widget.title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 1.05,
                                                      shadows: [
                                                        Shadow(
                                                          color: Colors.black45,
                                                          blurRadius: 4,
                                                          offset: Offset(0, 1),
                                                        )
                                                      ],
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    widget.subtitle
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.78),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // chevron
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white
                                                    .withOpacity(0.04),
                                              ),
                                              child: const Icon(
                                                  Icons.chevron_right_rounded,
                                                  color: Colors.white70),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

/// ===============================================================
/// Song detail page with matching Hero for polished transition
/// ===============================================================

class SongDetailPage extends StatefulWidget {
  final int itemIndex;
  final String languageCode;
  final String language;
  final String heroTag;

  const SongDetailPage({
    super.key,
    required this.itemIndex,
    required this.languageCode,
    required this.language,
    required this.heroTag,
  });

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  // Sample song list (replace with your actual data later)
  final List<Map<String, String>> allSongs = List.generate(
      50,
      (index) => {
            'number': '${index + 1}',
            'title': 'Song Title Here ${index + 1}',
          });

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

// ← Keep everything the same at the top (imports, class declaration, etc.)

  @override
  Widget build(BuildContext context) {
    final Gradient detailGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF8A2BE2).withOpacity(0.98),
        const Color(0xFF00BFFF).withOpacity(0.98),
      ],
    );

    // Filter logic stays the same
    final filteredSongs = allSongs.where((song) {
      final title = song['title']!.toLowerCase();
      final number = song['number']!;
      return title.contains(searchQuery.toLowerCase()) ||
          number.contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF070812),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              const SizedBox(width: 25),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Beautiful Gradient Header (now full height + overlaps correctly)
          Hero(
            tag: widget.heroTag,
            child: Container(
              height: 280, // ← Increased height so search bar sits inside it
              decoration: BoxDecoration(
                gradient: detailGradient,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(color: Colors.white.withOpacity(0.05)),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    bottom: 80, // ← Pushed title up a bit
                    child: Text(
                      '${widget.language} Songs',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Main content (search bar + list) — starts from safe area top
          SafeArea(
            child: Column(
              children: [
                const SizedBox(
                    height:
                        100), // ← This pushes search bar down into the gradient

                // SEARCH BAR — now sits beautifully inside the gradient header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.11),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.white70),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Search songs...",
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) =>
                                    setState(() => searchQuery = value),
                              ),
                            ),
                            if (searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() => searchQuery = "");
                                },
                                child: const Icon(Icons.clear,
                                    color: Colors.white60),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Song List (same as before)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0B0D11),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: filteredSongs.isEmpty
                        ? const Center(
                            child: Text("No songs found",
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 18)))
                        : ListView.builder(
                            itemCount: filteredSongs.length,
                            itemBuilder: (context, i) {
                              final song = filteredSongs[i];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 18, sigmaY: 18),
                                    child: Container(
                                      height: 72,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.white.withOpacity(0.09),
                                          Colors.white.withOpacity(0.03),
                                        ]),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.12),
                                            width: 1.5),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 56,
                                            height: 56,
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.15)),
                                              color: Colors.white
                                                  .withOpacity(0.08),
                                            ),
                                            child: const Icon(Icons.music_note,
                                                color: Colors.white70),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Song no: ${song['number']}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16)),
                                                const SizedBox(height: 4),
                                                Text(song['title']!,
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.7))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
