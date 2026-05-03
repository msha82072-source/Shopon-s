import 'package:flutter/material.dart';
import 'dart:async';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'NEW ARRIVALS',
      'subTitle': 'Fresh styles just dropped',
      'buttonText': 'Shop Now',
      'gradient': [const Color(0xFF000000), const Color(0xFF1A1A1A)],
      'accent': const Color(0xFFFFB800),
      'animationType': 'slide',
    },
    {
      'title': 'FEATURED COLLECTION',
      'subTitle': 'Handpicked styles for you',
      'buttonText': 'Explore Now',
      'gradient': [const Color(0xFF2D2D2D), const Color(0xFF1A1A1A)],
      'accent': const Color(0xFFFFB800),
      'animationType': 'fade',
    },
    {
      'title': 'BIG SALE',
      'subTitle': 'Up to 50% off on top brands',
      'buttonText': 'Grab the Deal',
      'gradient': [const Color(0xFFFFB800), const Color(0xFFFFC107)],
      'accent': const Color(0xFF1A1A1A),
      'animationType': 'pulse',
      'isSale': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              return _buildBannerItem(_banners[index], index);
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildIndicators(),
      ],
    );
  }

  Widget _buildBannerItem(Map<String, dynamic> banner, int index) {
    final bool isDark = banner['accent'] == const Color(0xFFFFB800);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: banner['gradient'],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (banner['isSale'] ?? false)
                  const _PulsingBadge(),
                const SizedBox(height: 8),
                _AnimatedBannerText(
                  text: banner['title'],
                  type: banner['animationType'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  banner['subTitle'],
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: banner['accent'],
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(banner['buttonText']),
                ),
              ],
            ),
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.shopping_bag,
                size: 150,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_banners.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? const Color(0xFFFFB800) : Colors.grey[400],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _AnimatedBannerText extends StatefulWidget {
  final String text;
  final String type;
  final TextStyle style;

  const _AnimatedBannerText({
    required this.text,
    required this.type,
    required this.style,
  });

  @override
  State<_AnimatedBannerText> createState() => _AnimatedBannerTextState();
}

class _AnimatedBannerTextState extends State<_AnimatedBannerText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (widget.type == 'slide') {
      _animation = Tween<double>(begin: -100, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
      );
    } else {
      _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (widget.type == 'slide') {
          return Transform.translate(
            offset: Offset(_animation.value, 0),
            child: Text(widget.text, style: widget.style),
          );
        }
        return Opacity(
          opacity: _animation.value,
          child: Text(widget.text, style: widget.style),
        );
      },
    );
  }
}

class _PulsingBadge extends StatefulWidget {
  const _PulsingBadge();

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.1).animate(_controller),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'LIMITED TIME',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
