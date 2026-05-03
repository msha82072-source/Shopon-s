import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// SHOPON'S branded logo with:
/// • Floating bob animation (forever loop)
/// • Gold glow pulse (forever loop)
/// • Hero mode = large (splash/login) vs compact (appBar)
class AntigravityLogo extends StatelessWidget {
  final double size;
  final bool isHero; // true → large; false → compact appBar version

  const AntigravityLogo({
    super.key,
    this.size = 120,
    this.isHero = true,
  });

  @override
  Widget build(BuildContext context) {
    const goldColor   = Color(0xFFC9A84C); // Brand Gold
    const navyColor   = Color(0xFF1B2A4A); // Brand Navy

    if (isHero) {
      return RepaintBoundary(
        child: _FloatingLogo(size: size, goldColor: goldColor, navyColor: navyColor),
      );
    }

    // ── Compact AppBar version ───────────────────────────────────────────
    return RepaintBoundary(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_rounded, size: 22, color: goldColor)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -2, end: 2, duration: const Duration(seconds: 2), curve: Curves.easeInOut),
          const SizedBox(width: 8),
          Text(
            "SHOPON'S",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: goldColor,
              shadows: [Shadow(color: navyColor, blurRadius: 1)],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stateful floating hero logo ──────────────────────────────────────────────
class _FloatingLogo extends StatefulWidget {
  final double size;
  final Color goldColor;
  final Color navyColor;

  const _FloatingLogo({
    required this.size,
    required this.goldColor,
    required this.navyColor,
  });

  @override
  State<_FloatingLogo> createState() => _FloatingLogoState();
}

class _FloatingLogoState extends State<_FloatingLogo>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _glowCtrl;

  late final Animation<double> _floatAnim;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    // Float: -10 px → +10 px → repeat
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    // Glow: subtle ↔ bright
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.15, end: 0.55).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.goldColor;
    final iconSize = widget.size * 0.45;
    final fontSize = widget.size * 0.18;

    return AnimatedBuilder(
      animation: Listenable.merge([_floatCtrl, _glowCtrl]),
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: g.withValues(alpha: _glowAnim.value),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_rounded, size: iconSize, color: g),
                const SizedBox(height: 10),
                Text(
                  "SHOPON'S",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: g,
                    shadows: [
                      Shadow(
                        color: g.withValues(alpha: 0.6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
