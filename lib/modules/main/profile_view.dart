import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/app_theme.dart';
import '../../routes/app_routes.dart';

/// Full profile page with staggered animations.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'guest@shopon.com';
    final initials = email.substring(0, 2).toUpperCase();

    final menuItems = [
      _MenuItem(Icons.shopping_bag_rounded,     'My Orders',         Routes.home),
      _MenuItem(Icons.location_on_outlined,     'Saved Addresses',   null),
      _MenuItem(Icons.credit_card_outlined,     'Payment Methods',   null),
      _MenuItem(Icons.notifications_outlined,   'Notifications',     null),
      _MenuItem(Icons.help_outline_rounded,     'Help & Support',    null),
      _MenuItem(Icons.info_outline_rounded,     'About SHOPON\'S',   null),
    ];

    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      appBar: AppBar(
        title: const Text(
          'MY PROFILE',
          style: TextStyle(
            color: AppTheme.goldAccent,
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Avatar + Info header ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
              decoration: BoxDecoration(
                color: AppTheme.navyBlue,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar slides from top
                  RepaintBoundary(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.goldAccent, Color(0xFFE8D5A3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.goldAccent.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    email,
                    style: TextStyle(
                      color: AppTheme.creamWhite.withValues(alpha: 0.7),
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.goldAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.4)),
                    ),
                    child: const Text(
                      'SHOPON\'S MEMBER',
                      style: TextStyle(
                        color: AppTheme.goldAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Menu items stagger in ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(menuItems.length, (index) {
                  final item = menuItems[index];
                  return _buildMenuItem(context, item, index);
                }),
              ),
            ),

            const SizedBox(height: 32),

            // ── Logout button with red shimmer ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _LogoutButton(),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: item.route != null
              ? () => Get.toNamed(item.route!)
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppTheme.navyBlue,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                // Gold glowing icon
                RepaintBoundary(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.goldAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: AppTheme.goldAccent, size: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: const TextStyle(
                    color: AppTheme.creamWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.creamWhite.withValues(alpha: 0.25),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? route;
  const _MenuItem(this.icon, this.label, this.route);
}

// ── Logout button with red shimmer on tap ────────────────────────────────────
class _LogoutButton extends StatefulWidget {
  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) async {
        setState(() => _pressed = false);
        await Future.delayed(const Duration(milliseconds: 300));
        await Supabase.instance.client.auth.signOut();
        Get.offAllNamed(Routes.login);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _pressed
              ? Colors.redAccent.withValues(alpha: 0.2)
              : AppTheme.navyBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed
                ? Colors.redAccent.withValues(alpha: 0.6)
                : Colors.redAccent.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                    blurRadius: 16,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            SizedBox(width: 12),
            Text(
              'SIGN OUT',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
