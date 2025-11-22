// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'main_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   // controllers
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   // password toggle
//   bool _isPasswordObscured = true;

//   // animation controllers for entrance & logo
//   late AnimationController _entranceController;
//   late Animation<double> _cardTiltAnim;
//   late Animation<double> _logoFloatAnim;

//   // pointer-based tilt (interactive)
//   double _tiltX = 0.0;
//   double _tiltY = 0.0;

//   @override
//   void initState() {
//     super.initState();

//     _entranceController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 0),
//     );

//     _cardTiltAnim = Tween<double>(begin: 0.45, end: 0.0).animate(
//       CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
//     );

//     _logoFloatAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _entranceController, curve: Curves.easeInOut),
//     );

//     _entranceController.forward();
//   }

//   @override
//   void dispose() {
//     _entranceController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // small helper to clamp tilt values
//   double _clampTilt(double v) => v.clamp(-0.25, 0.25);

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final cardWidth = min(w * 0.9, 520.0);

//     return Scaffold(
//       // dark neon background using gradients + subtle pattern feel
//       body: GestureDetector(
//         onPanUpdate: (details) {
//           // update interactive tilt based on pointer movement
//           setState(() {
//             _tiltY = _clampTilt(_tiltY + details.delta.dx / 1000);
//             _tiltX = _clampTilt(_tiltX - details.delta.dy / 1000);
//           });
//         },
//         onPanEnd: (_) {
//           // gently return to zero when release
//           setState(() {
//             _tiltX = 0;
//             _tiltY = 0;
//           });
//         },
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0xFF020617),
//                 const Color(0xFF081124),
//                 const Color(0xFF061022),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Stack(
//             children: [
//               // subtle moving neon vignette
//               Positioned.fill(
//                 child: IgnorePointer(
//                   child: CustomPaint(painter: _NeonVignettePainter()),
//                 ),
//               ),

//               // center content
//               Center(
//                 child: SingleChildScrollView(
//                   child: AnimatedBuilder(
//                     animation: _entranceController,
//                     builder: (context, child) {
//                       // combined tilt = entrance + interactive
//                       final double entranceTilt = _cardTiltAnim.value;
//                       final tx = entranceTilt + _tiltX;
//                       final ty = (entranceTilt / 2) + _tiltY;

//                       return Transform(
//                         alignment: Alignment.center,
//                         transform: Matrix4.identity()
//                           ..setEntry(3, 2, 0.001) // perspective
//                           ..rotateX(tx)
//                           ..rotateY(ty),
//                         child: child,
//                       );
//                     },
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Floating 3D Logo
//                         SizedBox(
//                           width: cardWidth,
//                           child: AnimatedBuilder(
//                             animation: _logoFloatAnim,
//                             builder: (context, child) {
//                               final float = sin(_logoFloatAnim.value * pi) * 6;
//                               final rotation =
//                                   sin(_logoFloatAnim.value * pi * 0.8) * 0.08;
//                               return Transform.translate(
//                                 offset: Offset(0, -12 + float),
//                                 child: Transform.rotate(
//                                   angle: rotation,
//                                   child: child,
//                                 ),
//                               );
//                             },
//                             child: _buildLogo(cardWidth),
//                           ),
//                         ),

//                         const SizedBox(height: 8),

//                         // Title with neon glow
//                         _NeonTitle(text: 'WELCOME BACK'),

//                         const SizedBox(height: 18),

//                         // Glass card with neon rim
//                         _buildGlassCard(cardWidth),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo(double maxWidth) {
//     final size = min(maxWidth * 0.28, 140.0);

//     return Center(
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: RadialGradient(
//             colors: [
//               Colors.blueAccent.withOpacity(0.95),
//               Colors.deepPurpleAccent.withOpacity(0.9),
//             ],
//             center: const Alignment(-0.3, -0.2),
//             radius: 0.9,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blueAccent.withOpacity(0.28),
//               blurRadius: 36,
//               spreadRadius: 6,
//             ),
//             BoxShadow(
//               color: Colors.deepPurpleAccent.withOpacity(0.18),
//               blurRadius: 60,
//               spreadRadius: 14,
//             ),
//           ],
//           border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(0),
//           child: ClipOval(
//             child: Image.asset(
//               'assets/icons/App_Launcher.png',
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassCard(double width) {
//     return Container(
//       width: width,
//       margin: const EdgeInsets.symmetric(horizontal: 14),
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.03),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           width: 1.0,
//           color: Colors.lightBlueAccent.withOpacity(0.08),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.45),
//             blurRadius: 30,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 6),
//               const Text(
//                 'Authorized persons only',
//                 style: TextStyle(color: Colors.white70),
//               ),
//               const SizedBox(height: 14),

//               // Email field with neon underline
//               _NeonInputField(
//                 controller: _emailController,
//                 hint: 'Email',
//                 prefix: const Icon(Icons.email_outlined, color: Colors.white70),
//                 keyboardType: TextInputType.emailAddress,
//               ),

//               const SizedBox(height: 12),

//               // Password field
//               _NeonInputField(
//                 controller: _passwordController,
//                 hint: 'Password',
//                 prefix: const Icon(Icons.lock_outline, color: Colors.white70),
//                 obscureText: _isPasswordObscured,
//                 suffix: IconButton(
//                   onPressed: () {
//                     setState(() => _isPasswordObscured = !_isPasswordObscured);
//                   },
//                   icon: Icon(
//                     _isPasswordObscured
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               // Neon Login button
//               _NeonButton(
//                 text: 'Login',
//                 onPressed: () {
//                   // TODO: add auth logic
//                 },
//               ),

//               const SizedBox(height: 14),

//               // OR divider
//               Row(
//                 children: const [
//                   Expanded(child: Divider(color: Colors.white12)),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12),
//                     child: Text('OR', style: TextStyle(color: Colors.white70)),
//                   ),
//                   Expanded(child: Divider(color: Colors.white12)),
//                 ],
//               ),

//               const SizedBox(height: 14),

//               // Google 3D round button
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const MainScreen()),
//                   );
//                 },
//                 child: Transform(
//                   transform: Matrix4.identity()
//                     ..setEntry(3, 2, 0.001)
//                     ..rotateY(-0.08)
//                     ..rotateX(0.02),
//                   child: Container(
//                     width: 68,
//                     height: 68,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.06),
//                       border: Border.all(color: Colors.white10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.blueAccent.withOpacity(0.2),
//                           blurRadius: 22,
//                           spreadRadius: 3,
//                         ),
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.5),
//                           blurRadius: 10,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.asset('assets/icons/googlebtn.png'),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ----------------- Neon Title -----------------
// class _NeonTitle extends StatelessWidget {
//   final String text;
//   const _NeonTitle({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//         color: Colors.blueAccent.shade100,
//         fontSize: 26,
//         fontWeight: FontWeight.w800,
//         letterSpacing: 2,
//         shadows: [
//           Shadow(blurRadius: 18, color: Colors.blueAccent.withOpacity(0.9)),
//           Shadow(
//             blurRadius: 30,
//             color: Colors.deepPurpleAccent.withOpacity(0.7),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ----------------- Neon Input Field -----------------
// class _NeonInputField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hint;
//   final Widget? prefix;
//   final Widget? suffix;
//   final TextInputType? keyboardType;
//   final bool obscureText;

//   const _NeonInputField({
//     required this.controller,
//     required this.hint,
//     this.prefix,
//     this.suffix,
//     this.keyboardType,
//     this.obscureText = false,
//   });

//   @override
//   State<_NeonInputField> createState() => _NeonInputFieldState();
// }

// class _NeonInputFieldState extends State<_NeonInputField> {
//   bool _focused = false;
//   final FocusNode _node = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _node.addListener(() {
//       setState(() => _focused = _node.hasFocus);
//     });
//   }

//   @override
//   void dispose() {
//     _node.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final glowColor = _focused ? Colors.blueAccent : Colors.white12;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           controller: widget.controller,
//           focusNode: _node,
//           keyboardType: widget.keyboardType,
//           obscureText: widget.obscureText,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             prefixIcon: widget.prefix,
//             suffixIcon: widget.suffix,
//             hintText: widget.hint,
//             hintStyle: TextStyle(color: Colors.white54.withOpacity(0.9)),
//             filled: true,
//             fillColor: Colors.white.withOpacity(0.02),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 14,
//               vertical: 18,
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         // neon underline
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 240),
//           height: _focused ? 3 : 2,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(6),
//             gradient: _focused
//                 ? LinearGradient(
//                     colors: [Colors.blueAccent, Colors.deepPurpleAccent],
//                   )
//                 : LinearGradient(colors: [Colors.white10, Colors.white10]),
//             boxShadow: _focused
//                 ? [
//                     BoxShadow(
//                       color: Colors.blueAccent.withOpacity(0.35),
//                       blurRadius: 12,
//                       spreadRadius: 1,
//                     ),
//                   ]
//                 : [],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ----------------- Neon Button -----------------
// class _NeonButton extends StatefulWidget {
//   final String text;
//   final VoidCallback onPressed;
//   const _NeonButton({required this.text, required this.onPressed});

//   @override
//   State<_NeonButton> createState() => _NeonButtonState();
// }

// class _NeonButtonState extends State<_NeonButton> {
//   bool _pressed = false;

//   @override
//   Widget build(BuildContext context) {
//     return Listener(
//       onPointerDown: (_) => setState(() => _pressed = true),
//       onPointerUp: (_) => setState(() => _pressed = false),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         width: double.infinity,
//         height: 54,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//             colors: _pressed
//                 ? [Colors.deepPurpleAccent.shade700, Colors.blueAccent.shade700]
//                 : [Colors.blueAccent, Colors.deepPurpleAccent],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blueAccent.withOpacity(_pressed ? 0.18 : 0.35),
//               blurRadius: _pressed ? 18 : 34,
//               spreadRadius: _pressed ? 1 : 6,
//             ),
//             BoxShadow(
//               color: Colors.black.withOpacity(0.45),
//               blurRadius: 12,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: widget.onPressed,
//             borderRadius: BorderRadius.circular(12),
//             child: Center(
//               child: Text(
//                 widget.text,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.8,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ----------------- Background Painter (neon vignette) -----------------
// class _NeonVignettePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // large soft radial gradient
//     final rect = Offset.zero & size;
//     final gradient = RadialGradient(
//       center: const Alignment(-0.6, -0.4),
//       radius: 1.2,
//       colors: [
//         Colors.transparent,
//         Colors.blueAccent.withOpacity(0.04),
//         Colors.deepPurpleAccent.withOpacity(0.03),
//         Colors.transparent,
//       ],
//       stops: const [0.0, 0.3, 0.7, 1.0],
//     );

//     final paint = Paint()..shader = gradient.createShader(rect);
//     canvas.drawRect(rect, paint);

//     // soft dark vignette
//     final v = Paint()
//       ..shader = RadialGradient(
//         center: const Alignment(0.6, 0.6),
//         radius: 1.5,
//         colors: [Colors.transparent, Colors.black.withOpacity(0.45)],
//         stops: const [0.4, 1.0],
//       ).createShader(rect);
//     canvas.drawRect(rect, v);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardWidth = w * 0.88;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E1117), Color(0xFF1A1F29)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // App Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 26,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/icons/App_Launcher.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Sign in to continue",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                // Glassmorphic Card
                Container(
                  width: cardWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Column(
                        children: [
                          const Text(
                            "Login Options",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Google Login Button
                          _GoogleButton(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Google Button Widget
class _GoogleButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.20)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Image.asset(
                  "assets/icons/googlebtn.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                "Continue with Google",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
