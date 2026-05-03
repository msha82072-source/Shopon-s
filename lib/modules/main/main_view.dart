import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_theme.dart';
import '../../widgets/antigravity_logo.dart';
import '../home/home_view.dart';
import '../search/search_view.dart';
import '../orders/orders_view.dart';
import 'main_controller.dart';
import 'profile_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildWebLayout(context, controller);
          }
          return _buildMobileLayout(context, controller);
        },
      ),
    );
  }

  // ── Mobile Layout ─────────────────────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context, MainController controller) {
    return Column(
      children: [
        Expanded(
          child: Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                  child: child,
                ),
              );
            },
            child: _buildPage(controller.selectedIndex.value),
          )),
        ),
        _buildBottomNavBar(context, controller),
      ],
    );
  }

  Widget _buildPage(int index) {
    const pages = [HomeView(), SearchView(), OrdersView(), ProfileView()];
    return KeyedSubtree(
      key: ValueKey(index),
      child: pages[index],
    );
  }

  // ── Bottom Navigation Bar ─────────────────────────────────────────────────
  Widget _buildBottomNavBar(BuildContext context, MainController controller) {
    final screens = [
      {'icon': Icons.home_rounded,         'label': 'HOME'},
      {'icon': Icons.search_rounded,        'label': 'SEARCH'},
      {'icon': Icons.shopping_bag_rounded,  'label': 'CART'},
      {'icon': Icons.person_rounded,        'label': 'PROFILE'},
    ];

    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: AppTheme.navyBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background slow shimmer loop
          RepaintBoundary(
            child: Shimmer.fromColors(
              baseColor: Colors.transparent,
              highlightColor: AppTheme.goldAccent.withValues(alpha: 0.04),
              period: const Duration(seconds: 4),
              child: Container(color: Colors.white.withValues(alpha: 0.02)),
            ),
          ),

          // Nav items
          Obx(() => Row(
            children: List.generate(screens.length, (index) {
              final isSelected = controller.selectedIndex.value == index;
              final item = screens[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeIndex(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with bounce/breathe
                      RepaintBoundary(
                        child: _NavIcon(
                          icon: item['icon'] as IconData,
                          isSelected: isSelected,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Label fades in when selected
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isSelected
                            ? Text(
                                item['label'] as String,
                                key: ValueKey('label_$index'),
                                style: const TextStyle(
                                  color: AppTheme.goldAccent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ).animate().fadeIn(duration: const Duration(milliseconds: 200)).slideY(begin: 0.5, end: 0)
                            : const SizedBox(key: ValueKey('empty'), height: 12),
                      ),
                    ],
                  ),
                ),
              );
            }),
          )),

          // Sliding gold underline
          Obx(() => AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            bottom: 0,
            left: (MediaQuery.of(context).size.width / screens.length) *
                controller.selectedIndex.value,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / screens.length,
              height: 3,
              child: Center(
                child: RepaintBoundary(
                  child: Container(
                    width: 28,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.goldAccent,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.goldAccent.withValues(alpha: 0.6),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .shimmer(duration: const Duration(milliseconds: 1500), color: Colors.white.withValues(alpha: 0.4)),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  // ── Web Layout ────────────────────────────────────────────────────────────
  Widget _buildWebLayout(BuildContext context, MainController controller) {
    return Row(
      children: [
        // Sidebar
        RepaintBoundary(
          child: Container(
            width: 260,
            decoration: BoxDecoration(
              color: AppTheme.navyBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Slow navy shimmer loop on sidebar
                Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  highlightColor: AppTheme.goldAccent.withValues(alpha: 0.03),
                  period: const Duration(seconds: 6),
                  child: Container(color: Colors.white.withValues(alpha: 0.01)),
                ),
                Column(
                  children: [
                    const SizedBox(height: 40),
                    const AntigravityLogo(size: 100, isHero: true),
                    const SizedBox(height: 48),
                    _buildWebNavItem(controller, 0, Icons.home_rounded, 'HOME'),
                    _buildWebNavItem(controller, 1, Icons.search_rounded, 'SEARCH'),
                    _buildWebNavItem(controller, 2, Icons.history_rounded, 'ORDERS'),
                    _buildWebNavItem(controller, 3, Icons.person_rounded, 'PROFILE'),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        "SHOPON'S v1.0",
                        style: TextStyle(color: AppTheme.creamWhite.withValues(alpha: 0.2), fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Main Content Area
        Expanded(
          child: Column(
            children: [
              // Top Bar
              Container(
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: AppTheme.navyBlue,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.goldAccent.withValues(alpha: 0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'SHOP SMART, LIVE BETTER',
                      style: TextStyle(
                        color: AppTheme.creamWhite.withValues(alpha: 0.4),
                        letterSpacing: 4,
                        fontSize: 11,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .shimmer(duration: const Duration(seconds: 4), color: AppTheme.goldAccent.withValues(alpha: 0.3)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white70),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.navySurface,
                      child: Icon(Icons.person, color: Colors.white38, size: 18),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.15, end: 0),

              Expanded(
                child: Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildPage(controller.selectedIndex.value),
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWebNavItem(
      MainController controller, int index, IconData icon, String label) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () => controller.changeIndex(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.goldAccent.withValues(alpha: 0.08)
                  : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: isSelected ? AppTheme.goldAccent : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    key: ValueKey(isSelected),
                    color: isSelected ? AppTheme.goldAccent : Colors.white38,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppTheme.creamWhite : Colors.white38,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
                    letterSpacing: 2,
                    fontSize: 13,
                  ),
                ),
                if (isSelected) ...[ 
                  const Spacer(),
                  RepaintBoundary(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.goldAccent,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.5, 1.5),
                      duration: const Duration(seconds: 1),
                    )
                    .shimmer(duration: const Duration(seconds: 1), color: Colors.white30),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}

// ── Stateful nav icon with bounce (active) / breathe (inactive) ──────────────
class _NavIcon extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  const _NavIcon({required this.icon, required this.isSelected});

  @override
  State<_NavIcon> createState() => _NavIconState();
}

class _NavIconState extends State<_NavIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.isSelected ? 700 : 2000),
    )..repeat(reverse: true);

    _anim = Tween<double>(
      begin: widget.isSelected ? 0.0 : 0.9,
      end: widget.isSelected ? -6.0 : 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_NavIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      _ctrl.duration = Duration(milliseconds: widget.isSelected ? 700 : 2000);
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        if (widget.isSelected) {
          return Transform.translate(
            offset: Offset(0, _anim.value),
            child: Icon(
              widget.icon,
              color: AppTheme.goldAccent,
              size: 26,
            ),
          );
        }
        return Transform.scale(
          scale: _anim.value,
          child: Icon(
            widget.icon,
            color: Colors.white38,
            size: 24,
          ),
        );
      },
    );
  }
}
