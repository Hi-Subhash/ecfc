import 'dart:ui';
import 'package:flutter/material.dart';

/// Global animated + static glass background
class GlassBackground extends StatefulWidget {
  final Widget child;
  const GlassBackground({super.key, required this.child});

  @override
  State<GlassBackground> createState() => _GlassBackgroundState();
}

class _GlassBackgroundState extends State<GlassBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(); // shimmer loop
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1️⃣ Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // 2️⃣ Animated shimmer effect
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Positioned.fill(
              child: Opacity(
                opacity: 0.25, // shimmer visibility
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      colors: [Colors.white.withOpacity(0.4), Colors.transparent],
                      stops: [0.2, 1.0],
                      begin: Alignment(-1.0 + _controller.value * 2, -1.0),
                      end: Alignment(1.0, 1.0),
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.srcATop,
                  child: Container(color: Colors.white),
                ),
              ),
            );
          },
        ),

        // 3️⃣ Glass blur overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
        ),

        // 4️⃣ Foreground child (your page content)
        widget.child,
      ],
    );
  }
}
