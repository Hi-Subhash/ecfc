// =============================
// lib/screens/home_page.dart
// =============================

import 'dart:math' as math;
import 'dart:ui';
import 'package:ecfc/screens/cart_page.dart';
import 'package:ecfc/screens/shop_page.dart';
import 'package:ecfc/services/auth_service.dart';
import 'package:ecfc/widgets/bottom_nav.dart';
import 'package:ecfc/screens/wishlist_page.dart';
import 'package:flutter/material.dart';

// These three files should live in the same folder: lib/screens/
import 'design_page.dart';
import 'order_history_screen.dart';
import 'profile_page.dart';
import 'notifications_page.dart';
import 'category_page.dart';

/// CFC Home Page with a "liquid glass" aesthetic —
/// animated blobs + glass (frosted) cards. No 3rd-party packages needed.
class CfcHomePage extends StatefulWidget {
  const CfcHomePage({super.key});

  @override
  State<CfcHomePage> createState() => _CfcHomePageState();
}

class _CfcHomePageState extends State<CfcHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("🏠 Home", style: TextStyle(fontSize: 22))),
    const ShopPage(),
    const DesignPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openMenu() {
    // Optional: show a simple sheet for now
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF151522),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 8,
              children: [
                ListTile(
                  leading: const Icon(Icons.home_rounded),
                  title: const Text('Home'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_none_rounded),
                  title: const Text('Notifications'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history_outlined),
                  title: const Text('Order History'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart_rounded),
                  title: const Text('Cart'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context); // Close the modal bottom sheet first
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Logout'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: const Text('Logout'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); // Close the dialog
                                AuthService().signOut(); // Sign out the user
                                // Optionally, navigate to a login screen or home screen after logout
                                // For example, if you have a SignInPage:
                                // Navigator.of(context).pushAndRemoveUntil(
                                //   MaterialPageRoute(builder: (context) => const SignInPage()),
                                //   (Route<dynamic> route) => false,
                                // );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: const Text('Wishlist'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WishlistPage()),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ensure scaffold adjusts
      body: Stack(
        children: [
          // 1) Animated liquid background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _LiquidBackgroundPainter(_controller.value),
                );
              },
            ),
          ),

          // 2) Glass overlay gradient tint (subtle)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withAlpha(5),
                      Colors.white.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3) Page content on a frosted glass container

          // ✅ switch body depending on tab
          Positioned.fill(
            child: _selectedIndex == 0
                ? _buildHomeContent(context) // your big glass home page
                : _pages[_selectedIndex],    // Shop, Design, Profile
          ),
        ],
      ),
      // ✅ add your bottom nav here
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
  Widget _buildHomeContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GlassAppBar(onMenuTap: _openMenu),
            const SizedBox(height: 8),
            const _GlassSearchBar(),
            const SizedBox(height: 8),
            const _PromoCard(),
            const SizedBox(height: 8),
            _CategoryChips(
              onTapCategory: (cat) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(category: cat),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            const Expanded(child: _FeaturedCarousel()),
          ],
        ),
      ),
    );
  }

}

class _GlassAppBar extends StatelessWidget {
  const _GlassAppBar({required this.onMenuTap});
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _GlassButton(
          onTap: onMenuTap,
          child: const Icon(Icons.menu_rounded),
        ),
        const SizedBox(width: 12),
        const Text(
          'CFC',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const Spacer(),
        _GlassButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            );
          },
          child: const Icon(Icons.notifications_none_rounded),
        ),
        const SizedBox(width: 8),
        _GlassButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
          child: const Icon(Icons.person_outline_rounded),
        ),
      ],
    );
  }
}

class _GlassSearchBar extends StatelessWidget {
  const _GlassSearchBar();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5                  ),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withAlpha(26)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded),
              const SizedBox(width: 6),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search designs, fabrics, or creators…',
                    border: InputBorder.none,
                  ),
                ),
              ),
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: 240,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Design • Predict • Sell',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'AI-assisted demand prediction and 3D visualization for your custom fashion.',
                      style: TextStyle(
                        color: Colors.white.withAlpha(217),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () {},
                          child: const Text('Start Designing'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Import Design'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                'https://images.unsplash.com/photo-1540574163026-643ea20ade25?q=80&w=800&auto=format&fit=crop',
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({this.onTapCategory});
  final void Function(String category)? onTapCategory;

  @override
  Widget build(BuildContext context) {
    final cats = <String>[
      'Trending',
      'Streetwear',
      'Formal',
      'Saree',
      'Ethnic',
      'Active',
      'Accessories',
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => onTapCategory?.call(cats[i]),
          child: _GlassChip(label: cats[i],),
        ),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: cats.length,
      ),
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  const _FeaturedCarousel();

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final _controller = PageController(viewportFraction: 0.85);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(5, (i) => i);
    return PageView.builder(
      controller: _controller,
      itemCount: items.length,
      padEnds: false,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double page = 0;
            try {
              page = _controller.page ?? _controller.initialPage.toDouble();
            } catch (_) {}
            final dist = (index - page).abs().clamp(0.0, 1.0);
            final scale = 1 - dist * 0.06;
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          // IMPORTANT: give the card a fixed height to avoid unconstrained/overflow errors
          child: const _FeaturedCard(height: 180),
        );
      },
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: height,
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Featured Drop',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Limited edition pieces generated from community moodboards.',
                    style: TextStyle(color: Colors.white.withAlpha(217)),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, // ✅ horizontal space
                    runSpacing: 6, // ✅ vertical space if wrapped
                    children: [
                      FilledButton.tonal(
                        onPressed: () {},
                        child: const Text('Preview 3D'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Details'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?q=80&w=800&auto=format&fit=crop',
              width: 120,
              height: double.infinity, // safe now because parent has fixed height
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Reusable "Glass" widgets ----------
class _GlassCard extends StatelessWidget {
  const _GlassCard({this.child, this.height});
  final Widget? child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withAlpha(15),
            border: Border.all(color: Colors.white.withAlpha(26)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(89),
                blurRadius: 24,
                spreadRadius: 2,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withAlpha(18),
              border: Border.all(color: Colors.white.withAlpha(26)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(26)),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

// ---------- Animated "liquid" background painter ----------
class _LiquidBackgroundPainter extends CustomPainter {
  _LiquidBackgroundPainter(this.t);
  final double t; // 0..1 animation progress

  @override
  void paint(Canvas canvas, Size size) {
    // Deep gradient backdrop
    final rect = Offset.zero & size;
    final gradient = const RadialGradient(
      center: Alignment(-0.6, -0.6),
      radius: 1.2,
      colors: [Color(0xFF0B0B14), Color(0xFF1F1F2E)], // Updated gradient colors
      stops: [0.0, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );

    // Animated blobs (metaball-ish illusion with blur)
    final blobs = [
      _Blob(
        color: const Color(0xFF7C3AED).withAlpha(89),
        baseX: size.width * 0.2,
        baseY: size.height * 0.3,
        r: size.shortestSide * 0.28,
        speed: 1.0,
        dx: 40,
        dy: 30,
      ),
      _Blob(
        color: const Color(0xFF06B6D4).withAlpha(89),
        baseX: size.width * 0.75,
        baseY: size.height * 0.25,
        r: size.shortestSide * 0.24,
        speed: 1.2,
        dx: -30,
        dy: 20,
      ),
      _Blob(
        color: const Color(0xFFFF6B6B).withAlpha(77),
        baseX: size.width * 0.6,
        baseY: size.height * 0.8,
        r: size.shortestSide * 0.36,
        speed: 0.8,
        dx: 30,
        dy: -25,
      ),
    ];

    for (final blob in blobs) {
      final p = Paint()
        ..color = blob.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);
      final cx = blob.baseX + math.sin(t * math.pi * 2 * blob.speed) * blob.dx;
      final cy = blob.baseY + math.cos(t * math.pi * 2 * blob.speed) * blob.dy;
      canvas.drawCircle(Offset(cx, cy), blob.r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _LiquidBackgroundPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _Blob {
  const _Blob({
    required this.color,
    required this.baseX,
    required this.baseY,
    required this.r,
    required this.speed,
    required this.dx,
    required this.dy,
  });
  final Color color;
  final double baseX;
  final double baseY;
  final double r;
  final double speed;
  final double dx;
  final double dy;
}
