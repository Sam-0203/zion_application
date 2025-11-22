// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:zion/pages/profile/my_account.dart';
// import 'package:zion/pages/songs/songs_list_view.dart';
// import 'pages/bible/bible_view.dart';
// import 'pages/chats/user_chat.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
//   int myCurrentIndex = 0;

//   final List<Widget> _pages = const [
//     Chats(),
//     BibleView(),
//     SongsListView(),
//     MyAccount(),
//   ];

//   late final List<AnimationController> _controllers;
//   late final List<Animation<double>> _scales;

//   @override
//   void initState() {
//     super.initState();

//     _controllers = List.generate(
//       4,
//       (_) => AnimationController(
//         vsync: this,
//         duration: const Duration(milliseconds: 300),
//       ),
//     );

//     _scales = _controllers
//         .map(
//           (c) => Tween<double>(
//             begin: 1.0,
//             end: 1.25,
//           ).animate(CurvedAnimation(parent: c, curve: Curves.elasticOut)),
//         )
//         .toList();
//   }

//   @override
//   void dispose() {
//     for (var c in _controllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   void _onTap(int index) {
//     setState(() => myCurrentIndex = index);
//     _controllers[index].forward().then((_) => _controllers[index].reverse());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomPadding = MediaQuery.of(context).padding.bottom;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       extendBody: true,

//       body: Stack(
//         children: [
//           // BACKGROUND GRADIENT
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xFF0A0E21),
//                   Color(0xFF131A38),
//                   Color(0xFF020617),
//                 ],
//               ),
//             ),
//           ),

//           // NEON GLOW OVERLAY
//           IgnorePointer(child: CustomPaint(painter: _LiquidNeonPainter())),

//           SafeArea(
//             child: Column(
//               children: [
//                 _buildGlassAppBar(),
//                 Expanded(child: _pages[myCurrentIndex]),
//               ],
//             ),
//           ),
//         ],
//       ),

//       // BOTTOM NAVIGATION BAR
//       bottomNavigationBar: navigationbar(context, bottomPadding),
//     );
//   }

//   MediaQuery navigationbar(BuildContext context, double bottomPadding) {
//     return MediaQuery.removePadding(
//       context: context,
//       removeBottom: true,
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           bottom: 16 + bottomPadding,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(24), // MATCH APPBAR
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // MATCH APPBAR
//             child: Container(
//               height: 84,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.08), // MATCH APPBAR
//                 borderRadius: BorderRadius.circular(24), // MATCH APPBAR
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.12), // MATCH APPBAR
//                 ),
//               ),

//               child: Stack(
//                 children: [
//                   // NAV ITEMS
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: List.generate(4, (i) {
//                       final isActive = i == myCurrentIndex;
//                       return Expanded(
//                         child: GestureDetector(
//                           onTap: () => _onTap(i),
//                           child: AnimatedBuilder(
//                             animation: _controllers[i],
//                             builder: (context, child) {
//                               return Transform.scale(
//                                 scale: isActive ? _scales[i].value : 1.0,
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const SizedBox(height: 16),
//                                     Icon(
//                                       _navIcons[i],
//                                       color: isActive
//                                           ? Colors.white
//                                           : Colors.white60,
//                                       size: isActive ? 32 : 28,
//                                     ),
//                                     const SizedBox(height: 6),
//                                     if (isActive)
//                                       Text(
//                                         _navLabels[i],
//                                         style: TextStyle(
//                                           color: isActive
//                                               ? Colors.white
//                                               : Colors.white60,
//                                           fontSize: isActive ? 12 : 11,
//                                           fontWeight: isActive
//                                               ? FontWeight.w800
//                                               : FontWeight.w500,
//                                           letterSpacing: 0.5,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // -------------------------
//   // GLASS APP BAR
//   // -------------------------
//   Widget _buildGlassAppBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(color: Colors.white.withOpacity(0.12)),
//             ),
//             child: Row(
//               children: [
//                 Text(
//                   'Zion App',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                     fontWeight: FontWeight.w900,
//                     letterSpacing: 1,
//                     shadows: [
//                       Shadow(
//                         color: Colors.black54,
//                         blurRadius: 10,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const Spacer(),

//                 GestureDetector(
//                   onTap: () {
//                     // TODO: Add your edit action
//                   },
//                   child: _iconButton(Icons.edit_note_rounded),
//                 ),

//                 const SizedBox(width: 12),

//                 GestureDetector(
//                   onTap: showNotificationDialog,
//                   child: _iconButton(Icons.notifications_rounded),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // APPBAR ICON STYLE
//   Widget _iconButton(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white.withOpacity(0.2)),
//       ),
//       child: Icon(icon, color: Colors.white70, size: 24),
//     );
//   }

//   // -------------------------
//   // NOTIFICATION BOTTOM SHEET
//   // -------------------------
//   void showNotificationDialog() {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: false, // No tap-to-close
//       enableDrag: false, // No swipe-to-close
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) {
//         return ClipRRect(
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.40,
//               padding: const EdgeInsets.all(16),

//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.15),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(25),
//                 ),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.25),
//                   width: 1.2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 20,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 🔻 Top: Title + Close button
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Notifications (2)',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),

//                       // ❌ Glass Close Button
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           height: 42,
//                           width: 42,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white.withOpacity(0.12),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.25),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 12,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: const Center(
//                             child: Icon(
//                               Icons.close,
//                               color: Colors.white,
//                               size: 22,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // 🔔 Notification Cells
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         _buildNotificationCell(
//                           icon: Icons.notifications_active,
//                           title: "New message from John",
//                         ),
//                         const SizedBox(height: 12),
//                         _buildNotificationCell(
//                           icon: Icons.notifications_active,
//                           title: "Your order has been shipped",
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // -------------------------------------------------------
//   // ⭐ GLASS NOTIFICATION CELL WIDGET
//   // -------------------------------------------------------
//   Widget _buildNotificationCell({
//     required IconData icon,
//     required String title,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         color: Colors.white.withOpacity(0.10),
//         border: Border.all(color: Colors.white.withOpacity(0.20)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 12,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Icon bubble
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white.withOpacity(0.12),
//               border: Border.all(color: Colors.white.withOpacity(0.25)),
//             ),
//             child: Icon(icon, size: 22, color: Colors.white),
//           ),

//           const SizedBox(width: 16),

//           // Message text
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// final List<IconData> _navIcons = [
//   Icons.chat_bubble_outline_outlined,
//   Icons.menu_book_rounded,
//   Icons.music_note_rounded,
//   Icons.person_rounded,
// ];

// final List<String> _navLabels = ['Chats', 'Bible', 'Songs', 'Me'];

// // -----------------------------------------
// // NEON BACKGROUND PAINTER
// // -----------------------------------------
// class _LiquidNeonPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Offset.zero & size;

//     final paint1 = Paint()
//       ..shader = const RadialGradient(
//         center: Alignment(-0.8, -0.8),
//         radius: 1.2,
//         colors: [Color(0xFF6E5BFF), Colors.transparent],
//         stops: [0.0, 0.7],
//       ).createShader(rect);

//     final paint2 = Paint()
//       ..shader = const RadialGradient(
//         center: Alignment(1.0, 1.2),
//         radius: 1.4,
//         colors: [Color(0xFF00E0FF), Colors.transparent],
//         stops: [0.0, 0.6],
//       ).createShader(rect);

//     canvas.drawRect(rect, paint1);
//     canvas.drawRect(rect, paint2);
//   }

//   @override
//   bool shouldRepaint(_) => false;
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zion_final/pages/profile/my_account.dart';
import 'package:zion_final/pages/songs/songs_list_view.dart';
import 'pages/bible/bible_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int myCurrentIndex = 0;

  // ❌ Chats Removed
  final List<Widget> _pages = const [BibleView(), SongsListView(), MyAccount()];

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();

    // ❌ Only 3 controllers now
    _controllers = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _scales = _controllers
        .map(
          (c) => Tween<double>(
            begin: 1.0,
            end: 1.25,
          ).animate(CurvedAnimation(parent: c, curve: Curves.elasticOut)),
        )
        .toList();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    setState(() => myCurrentIndex = index);
    _controllers[index].forward().then((_) => _controllers[index].reverse());
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,

      body: Stack(
        children: [
          // BACKGROUND GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF131A38),
                  Color(0xFF020617),
                ],
              ),
            ),
          ),

          // NEON GLOW OVERLAY
          IgnorePointer(child: CustomPaint(painter: _LiquidNeonPainter())),

          SafeArea(
            child: Column(
              children: [
                _buildGlassAppBar(),
                Expanded(child: _pages[myCurrentIndex]),
              ],
            ),
          ),
        ],
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: navigationbar(context, bottomPadding),
    );
  }

  MediaQuery navigationbar(BuildContext context, double bottomPadding) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 16 + bottomPadding,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(3, (i) {
                  final isActive = i == myCurrentIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onTap(i),
                      child: AnimatedBuilder(
                        animation: _controllers[i],
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isActive ? _scales[i].value : 1.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 16),
                                Icon(
                                  _navIcons[i],
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white60,
                                  size: isActive ? 32 : 28,
                                ),
                                const SizedBox(height: 6),
                                if (isActive)
                                  Text(
                                    _navLabels[i],
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.white
                                          : Colors.white60,
                                      fontSize: isActive ? 12 : 11,
                                      fontWeight: isActive
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------
  // GLASS APP BAR
  // -------------------------
  Widget _buildGlassAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                Text(
                  'Zion App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),

                const Spacer(),

                _iconButton(Icons.edit_note_rounded),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => showNotificationDialog(),
                  child: _iconButton(Icons.notifications_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------
  // NOTIFICATION BOTTOM SHEET
  // -------------------------
  void showNotificationDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.40,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 25,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔻 Header: Title + Close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications (2)',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),

                      // ❌ Close Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ✨ Neon Divider
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(0.45),
                          Colors.purpleAccent.withOpacity(0.45),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔔 Notification List
                  Expanded(
                    child: ListView(
                      children: [
                        _buildNotificationCell(
                          icon: Icons.notifications_active_rounded,
                          title: "New message from John",
                          subtitle: "Tap to view the full message",
                        ),
                        const SizedBox(height: 14),
                        _buildNotificationCell(
                          icon: Icons.local_shipping_rounded,
                          title: "Your order has been shipped",
                          subtitle: "Expected delivery: Tomorrow",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------
// ⭐ Enhanced Notification Cell Widget
// -------------------------------------------------------
Widget _buildNotificationCell({
  required IconData icon,
  required String title,
  String? subtitle,
}) {
  return TweenAnimationBuilder(
    duration: const Duration(milliseconds: 450),
    tween: Tween<double>(begin: 0, end: 1),
    builder: (context, value, child) {
      return Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: child,
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.10),
        border: Border.all(color: Colors.white.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon bubble
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Icon(icon, size: 22, color: Colors.white),
          ),

          const SizedBox(width: 14),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.70),
                        fontSize: 13,
                      ),
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

Widget _iconButton(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Icon(icon, color: Colors.white70, size: 24),
  );
}

// -----------------------------
// UPDATED NAV BOTTOM ITEMS
// -----------------------------
final List<IconData> _navIcons = [
  Icons.menu_book_rounded,
  Icons.music_note_rounded,
  Icons.person_rounded,
];

final List<String> _navLabels = ['Bible', 'Songs', 'Me'];

// -----------------------------
// NEON BACKGROUND PAINTER
// -----------------------------
class _LiquidNeonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint1 = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.8, -0.8),
        radius: 1.2,
        colors: [Color(0xFF6E5BFF), Colors.transparent],
      ).createShader(rect);

    final paint2 = Paint()
      ..shader = const RadialGradient(
        center: Alignment(1.0, 1.2),
        radius: 1.4,
        colors: [Color(0xFF00E0FF), Colors.transparent],
      ).createShader(rect);

    canvas.drawRect(rect, paint1);
    canvas.drawRect(rect, paint2);
  }

  @override
  bool shouldRepaint(_) => false;
}
