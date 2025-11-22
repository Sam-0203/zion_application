import 'dart:ui';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tiltAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tiltAnimation = Tween<double>(
      begin: 0, // static — no animation effect
      end: 0,
    ).animate(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        child: Stack(
          children: [
            /// 🔹 Gradient Background (NO ANIMATION TIME)
            AnimatedContainer(
              duration: Duration.zero,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0A0A0F),
                    Color(0xFF1B1B2F),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            /// 🔹 3D Card (Static – No animation)
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_tiltAnimation.value),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 12),
                        blurRadius: 30,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: deviceHeight * 0.05),

                        Text(
                          "Today's Word for You",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          '“For I know the plans I have for you,” declares the Lord, '
                          '“plans to prosper you and not to harm you, plans to give you hope and a future.”',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.justify,
                        ),

                        const SizedBox(height: 18),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '— Jeremiah 29:11',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
