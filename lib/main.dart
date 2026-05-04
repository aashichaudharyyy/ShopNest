import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const ShopNestApp());
}

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

class Review {
  final String reviewer;
  final String avatar; // initials
  final double rating;
  final String comment;
  final String date;

  const Review({
    required this.reviewer,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class CartItem {
  final Product product;
  int quantity;
  CartItem(this.product, {this.quantity = 1});
}

class Product {
  final int id;
  final String name;
  final double price;
  final double originalPrice;
  final String description;
  final String imageUrl;
  final String category;
  final String emoji;
  final List<Review> reviews;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.emoji,
    required this.reviews,
  });

  double get averageRating => reviews.isEmpty
      ? 0
      : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

  bool get isOnSale => originalPrice > price;
}

// ─────────────────────────────────────────────
//  SAMPLE DATA
// ─────────────────────────────────────────────

final List<Product> sampleProducts = [
  Product(
    id: 1,
    name: 'Minimalist Watch',
    price: 129.99,
    originalPrice: 179.99,
    description:
        'A clean, elegant timepiece with a leather strap and sapphire crystal glass. Perfect for everyday wear and special occasions alike. Swiss movement ensures precision timekeeping.',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80',
    category: 'Accessories',
    emoji: '⌚',
    reviews: const [
      Review(reviewer: 'Aryan S.', avatar: 'AS', rating: 5, comment: 'Absolutely stunning watch. The leather strap is top quality!', date: 'Mar 2026'),
      Review(reviewer: 'Priya M.', avatar: 'PM', rating: 4, comment: 'Elegant design, runs perfectly. A bit pricey but worth it.', date: 'Feb 2026'),
      Review(reviewer: 'Rahul K.', avatar: 'RK', rating: 5, comment: 'Got compliments everywhere I wore this. Love it!', date: 'Jan 2026'),
    ],
  ),
  Product(
    id: 2,
    name: 'Wireless Headphones',
    price: 89.99,
    originalPrice: 89.99,
    description:
        'Premium over-ear headphones with active noise cancellation, 30-hour battery life, and crystal-clear audio for music lovers.',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80',
    category: 'Electronics',
    emoji: '🎧',
    reviews: const [
      Review(reviewer: 'Sneha R.', avatar: 'SR', rating: 5, comment: 'Best headphones I have ever owned. ANC is incredible.', date: 'Mar 2026'),
      Review(reviewer: 'Dev P.', avatar: 'DP', rating: 4, comment: 'Sound quality is superb. Comfortable for long sessions.', date: 'Feb 2026'),
    ],
  ),
  Product(
    id: 3,
    name: 'Leather Backpack',
    price: 149.00,
    originalPrice: 199.00,
    description:
        'Handcrafted genuine leather backpack with padded laptop compartment and multiple organizer pockets. Built to last a lifetime.',
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&q=80',
    category: 'Bags',
    emoji: '🎒',
    reviews: const [
      Review(reviewer: 'Kavya T.', avatar: 'KT', rating: 5, comment: 'Perfect for college and travel. The leather ages beautifully!', date: 'Mar 2026'),
      Review(reviewer: 'Mohit J.', avatar: 'MJ', rating: 4, comment: 'Very sturdy and stylish. My laptop fits perfectly inside.', date: 'Jan 2026'),
    ],
  ),
  Product(
    id: 4,
    name: 'Sneakers Pro',
    price: 74.99,
    originalPrice: 74.99,
    description:
        'Lightweight running sneakers with cushioned insoles and breathable mesh upper. Great for gym sessions and casual outings.',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
    category: 'Footwear',
    emoji: '👟',
    reviews: const [
      Review(reviewer: 'Ankit V.', avatar: 'AV', rating: 4, comment: 'Super comfortable! Wore them for a 10k run without any issues.', date: 'Feb 2026'),
      Review(reviewer: 'Riya S.', avatar: 'RS', rating: 5, comment: 'Stylish and breathable. Perfect for summer workouts.', date: 'Feb 2026'),
    ],
  ),
  Product(
    id: 5,
    name: 'Ceramic Mug Set',
    price: 34.99,
    originalPrice: 49.99,
    description:
        'Set of 4 hand-painted ceramic mugs in pastel shades. Microwave and dishwasher safe. A cozy addition to your morning routine.',
    imageUrl: 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=600&q=80',
    category: 'Home',
    emoji: '☕',
    reviews: const [
      Review(reviewer: 'Nisha B.', avatar: 'NB', rating: 5, comment: 'Gorgeous mugs! The colors are even prettier in person.', date: 'Mar 2026'),
      Review(reviewer: 'Varun L.', avatar: 'VL', rating: 4, comment: 'Great quality, good size. My morning coffee tastes better now!', date: 'Jan 2026'),
    ],
  ),
  Product(
    id: 6,
    name: 'Sunglasses Classic',
    price: 59.99,
    originalPrice: 59.99,
    description:
        'UV400 polarised lenses with a lightweight acetate frame. Timeless aviator style that suits every face shape.',
    imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600&q=80',
    category: 'Accessories',
    emoji: '🕶️',
    reviews: const [
      Review(reviewer: 'Aisha Q.', avatar: 'AQ', rating: 5, comment: 'Perfect UV protection and super stylish. Love the aviator look!', date: 'Mar 2026'),
    ],
  ),
  Product(
    id: 7,
    name: 'Smart Water Bottle',
    price: 45.00,
    originalPrice: 60.00,
    description:
        'Insulated stainless steel bottle that keeps drinks cold for 24 h and hot for 12 h. LED hydration reminder built in.',
    imageUrl: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=80',
    category: 'Sports',
    emoji: '💧',
    reviews: const [
      Review(reviewer: 'Siddharth N.', avatar: 'SN', rating: 5, comment: 'The LED reminder is genius! Keeps my coffee hot all morning.', date: 'Feb 2026'),
      Review(reviewer: 'Meera P.', avatar: 'MP', rating: 4, comment: 'Great insulation. Sleek design and easy to carry.', date: 'Jan 2026'),
    ],
  ),
  Product(
    id: 8,
    name: 'Scented Candle',
    price: 22.50,
    originalPrice: 22.50,
    description:
        'Hand-poured soy wax candle with calming lavender and vanilla fragrance. 50-hour burn time in a reusable glass jar.',
    imageUrl: 'https://images.unsplash.com/photo-1602523961358-f9f03dd557db?w=600&q=80',
    category: 'Home',
    emoji: '🕯️',
    reviews: const [
      Review(reviewer: 'Tanvi R.', avatar: 'TR', rating: 5, comment: 'The fragrance fills my entire room. So relaxing after a long day!', date: 'Mar 2026'),
      Review(reviewer: 'Karan M.', avatar: 'KM', rating: 4, comment: 'Burns evenly and the jar is beautiful. Great gift idea.', date: 'Feb 2026'),
    ],
  ),
];

// ─────────────────────────────────────────────
//  THEME COLOURS
// ─────────────────────────────────────────────

class AppColors {
  static const Color coral    = Color(0xFFFF6B6B);
  static const Color coralDark= Color(0xFFE85555);
  static const Color peach    = Color(0xFFFFD93D);
  static const Color mint     = Color(0xFF4ECDC4);
  static const Color sky      = Color(0xFF45B7D1);
  static const Color lavender = Color(0xFFA78BFA);
  static const Color blush    = Color(0xFFFB7185);
  static const Color cream    = Color(0xFFFFFBF7);
  static const Color charcoal = Color(0xFF1A1A2E);
  static const Color slate    = Color(0xFF374151);
  static const Color muted    = Color(0xFF9CA3AF);

  static const Color darkBg       = Color(0xFF0F0F1A);
  static const Color darkSurface  = Color(0xFF1A1A2E);
  static const Color darkCard     = Color(0xFF252540);
  static const Color darkBorder   = Color(0xFF2D2D4A);

  static const List<Color> cardAccents = [
    Color(0xFFFFE8E8),
    Color(0xFFE8F4FE),
    Color(0xFFE8FFF0),
    Color(0xFFFFF8E8),
    Color(0xFFF0E8FF),
    Color(0xFFE8FFFE),
    Color(0xFFFFEDF0),
    Color(0xFFF5FFE8),
  ];
  static const List<Color> cardAccentsDark = [
    Color(0xFF3D1F1F),
    Color(0xFF1F2E3D),
    Color(0xFF1F3D28),
    Color(0xFF3D3420),
    Color(0xFF2D1F3D),
    Color(0xFF1F3D3B),
    Color(0xFF3D1F25),
    Color(0xFF293D1F),
  ];
}

// ─────────────────────────────────────────────
//  GLOBAL NOTIFIERS
// ─────────────────────────────────────────────

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);
  void toggle() => value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  bool get isDark => value == ThemeMode.dark;
}

class CartNotifier extends ValueNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void add(Product p) {
    final idx = value.indexWhere((i) => i.product.id == p.id);
    if (idx >= 0) {
      value[idx].quantity++;
      value = [...value];
    } else {
      value = [...value, CartItem(p)];
    }
  }

  void increment(CartItem item) {
    item.quantity++;
    value = [...value];
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      value = [...value];
    } else {
      remove(item);
    }
  }

  void remove(CartItem item) {
    value = value.where((i) => i.product.id != item.product.id).toList();
  }

  void clear() => value = [];

  int get totalItems => value.fold(0, (s, i) => s + i.quantity);
  double get total => value.fold(0.0, (s, i) => s + i.product.price * i.quantity);
  bool contains(Product p) => value.any((i) => i.product.id == p.id);
}

class WishlistNotifier extends ValueNotifier<List<Product>> {
  WishlistNotifier() : super([]);
  void toggle(Product p) {
    value = value.any((x) => x.id == p.id)
        ? value.where((x) => x.id != p.id).toList()
        : [...value, p];
  }
  bool contains(Product p) => value.any((x) => x.id == p.id);
}

class OnboardingNotifier extends ValueNotifier<bool> {
  OnboardingNotifier() : super(false); // false = not done
  void complete() => value = true;
}

final themeNotifier     = ThemeNotifier();
final cartNotifier      = CartNotifier();
final wishlistNotifier  = WishlistNotifier();
final onboardingNotifier = OnboardingNotifier();

typedef MyApp = ShopNestApp;

// ─────────────────────────────────────────────
//  ROOT APP
// ─────────────────────────────────────────────

class ShopNestApp extends StatelessWidget {
  const ShopNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) => MaterialApp(
        title: 'ShopNest',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        home: ValueListenableBuilder<bool>(
          valueListenable: onboardingNotifier,
          builder: (_, done, __) =>
              done ? const SplashScreen() : const OnboardingScreen(),
        ),
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? AppColors.darkBg : AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.coral,
        brightness: brightness,
      ).copyWith(
        primary: AppColors.coral,
        secondary: AppColors.mint,
        surface: isDark ? AppColors.darkSurface : Colors.white,
      ),
      fontFamily: 'Georgia',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Georgia'),
        headlineLarge: TextStyle(fontFamily: 'Georgia'),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.charcoal),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.charcoal,
          fontWeight: FontWeight.w800,
          fontSize: 20,
          letterSpacing: -0.5,
          fontFamily: 'Georgia',
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        indicatorColor: AppColors.coral.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ONBOARDING SCREEN
// ─────────────────────────────────────────────

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final Color lightColor;
  const _OnboardingPage({
    required this.emoji, required this.title,
    required this.subtitle, required this.color, required this.lightColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardingPage(
      emoji: '🛍️',
      title: 'Discover\nAmazing\nProducts',
      subtitle: 'Browse hundreds of curated items across categories. Find exactly what you need.',
      color: AppColors.coral,
      lightColor: Color(0xFFFFE8E8),
    ),
    _OnboardingPage(
      emoji: '❤️',
      title: 'Save Your\nFavourites',
      subtitle: 'Wishlist anything you love. Come back anytime to pick up where you left off.',
      color: AppColors.lavender,
      lightColor: Color(0xFFF0E8FF),
    ),
    _OnboardingPage(
      emoji: '🚀',
      title: 'Fast &\nEasy\nCheckout',
      subtitle: 'A cart that remembers everything. Checkout in seconds, every time.',
      color: AppColors.mint,
      lightColor: Color(0xFFE8FFFED),
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _ctrl.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    } else {
      onboardingNotifier.complete();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_page];
    return Scaffold(
      backgroundColor: page.lightColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _page < _pages.length - 1
                    ? GestureDetector(
                        onTap: onboardingNotifier.complete,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Skip', style: TextStyle(color: page.color, fontWeight: FontWeight.w700, fontSize: 14)),
                        ),
                      )
                    : const SizedBox(height: 36),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (ctx, i) => _OnboardingPageWidget(page: _pages[i]),
              ),
            ),
            // Dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _page ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page ? page.color : page.color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: _next,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: page.color,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: page.color.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Center(
                        child: Text(
                          _page == _pages.length - 1 ? 'Get Started  🎉' : 'Continue  →',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17, letterSpacing: 0.3),
                        ),
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
}

class _OnboardingPageWidget extends StatelessWidget {
  final _OnboardingPage page;
  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [BoxShadow(color: page.color.withOpacity(0.35), blurRadius: 30, offset: const Offset(0, 12))],
            ),
            child: Center(child: Text(page.emoji, style: const TextStyle(fontSize: 52))),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: AppColors.charcoal,
              height: 1.1,
              letterSpacing: -1.5,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            page.subtitle,
            style: const TextStyle(fontSize: 16, color: AppColors.slate, height: 1.65, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween(begin: 0.65, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _slide = Tween(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFD93D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: FadeTransition(
                  opacity: _fade,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 16))],
                    ),
                    child: const Center(child: Text('🛍️', style: TextStyle(fontSize: 54))),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: const [
                      Text('ShopNest', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2, fontFamily: 'Georgia', shadows: [Shadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4))])),
                      SizedBox(height: 8),
                      Text('Your vibe. Your style.', style: TextStyle(fontSize: 15, color: Colors.white70, letterSpacing: 1.5, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 70),
              FadeTransition(
                opacity: _fade,
                child: const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MAIN SHELL (Bottom Nav)
// ─────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE), width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          height: 68,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront_rounded, color: AppColors.coral),
              label: 'Shop',
            ),
            NavigationDestination(
              icon: ValueListenableBuilder<List<Product>>(
                valueListenable: wishlistNotifier,
                builder: (_, list, __) => Badge(
                  isLabelVisible: list.isNotEmpty,
                  label: Text('${list.length}'),
                  backgroundColor: AppColors.blush,
                  child: const Icon(Icons.favorite_border_rounded),
                ),
              ),
              selectedIcon: const Icon(Icons.favorite_rounded, color: AppColors.blush),
              label: 'Wishlist',
            ),
            NavigationDestination(
              icon: ValueListenableBuilder<List<CartItem>>(
                valueListenable: cartNotifier,
                builder: (_, cart, __) => Badge(
                  isLabelVisible: cart.isNotEmpty,
                  label: Text('${cartNotifier.totalItems}'),
                  backgroundColor: AppColors.coral,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
              selectedIcon: const Icon(Icons.shopping_bag_rounded, color: AppColors.coral),
              label: 'Cart',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.mint),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HOME SCREEN
// ─────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = 'All';
  String _query = '';
  final TextEditingController _searchCtrl = TextEditingController();

  List<String> get _categories =>
      ['All', ...sampleProducts.map((p) => p.category).toSet().toList()];

  List<Product> get _filtered {
    var list = _category == 'All'
        ? sampleProducts
        : sampleProducts.where((p) => p.category == _category).toList();
    if (_query.isNotEmpty) {
      list = list.where((p) =>
          p.name.toLowerCase().contains(_query.toLowerCase()) ||
          p.category.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    return list;
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildBanner(),
          _buildCategoryChips(),
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(10)),
          child: const Center(child: Text('🛍️', style: TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 10),
        const Text('ShopNest'),
      ]),
      actions: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, mode, __) => IconButton(
            icon: Icon(mode == ThemeMode.dark ? Icons.wb_sunny_rounded : Icons.nightlight_round, size: 22),
            onPressed: themeNotifier.toggle,
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: _isDark ? AppColors.darkCard : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isDark ? AppColors.darkBorder : Colors.transparent),
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _query = v),
          style: TextStyle(fontSize: 14, color: _isDark ? Colors.white : AppColors.charcoal),
          decoration: InputDecoration(
            hintText: 'Search products, categories...',
            hintStyle: TextStyle(color: _isDark ? Colors.white38 : AppColors.muted, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: _isDark ? Colors.white38 : AppColors.muted, size: 20),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded, color: _isDark ? Colors.white38 : AppColors.muted, size: 18),
                    onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      height: 130,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFD93D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.coral.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(right: -20, top: -20,
            child: Container(width: 110, height: 110,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))),
          Positioned(right: 40, bottom: -30,
            child: Container(width: 80, height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Text('LIMITED TIME', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                ),
                const SizedBox(height: 8),
                const Text('Summer Sale 🎉', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, fontFamily: 'Georgia')),
                const SizedBox(height: 4),
                const Text('Up to 40% off selected items', style: TextStyle(color: Colors.white70, fontSize: 12.5)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                child: const Text('Shop Now', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w800, fontSize: 13)),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 52,
      margin: const EdgeInsets.only(top: 14),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final sel = cat == _category;
          return GestureDetector(
            onTap: () => setState(() => _category = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? AppColors.coral : (_isDark ? AppColors.darkCard : Colors.white),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: sel ? AppColors.coral : (_isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE))),
                boxShadow: sel ? [BoxShadow(color: AppColors.coral.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
              ),
              child: Text(cat, style: TextStyle(
                color: sel ? Colors.white : (_isDark ? Colors.white60 : AppColors.slate),
                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    final products = _filtered;
    if (products.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('🔍', style: const TextStyle(fontSize: 52)),
        const SizedBox(height: 16),
        Text('No results for "$_query"', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _isDark ? Colors.white54 : AppColors.slate)),
        const SizedBox(height: 8),
        Text('Try a different search', style: TextStyle(color: _isDark ? Colors.white38 : AppColors.muted)),
      ]));
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.68,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => _ProductCard(product: products[i]),
    );
  }
}

// ─────────────────────────────────────────────
//  PRODUCT CARD
// ─────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? AppColors.cardAccentsDark[product.id % AppColors.cardAccentsDark.length]
        : AppColors.cardAccents[product.id % AppColors.cardAccents.length];
    final cardBg = isDark ? AppColors.darkCard : Colors.white;

    return GestureDetector(
      onTap: () => Navigator.push(context, PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => ProductDetailScreen(product: product, accentColor: accent),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
      )),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.07), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image area
          Stack(children: [
            Hero(
              tag: 'product_${product.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: Container(
                  height: 148,
                  color: accent,
                  width: double.infinity,
                  child: Image.network(
                    product.imageUrl, fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : _ShimmerBox(height: 148, borderRadius: 0),
                    errorBuilder: (_, __, ___) => Center(child: Text(product.emoji, style: const TextStyle(fontSize: 48))),
                  ),
                ),
              ),
            ),
            // Sale badge
            if (product.isOnSale)
              Positioned(top: 10, left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(8)),
                  child: Text('SALE', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
                )),
            // Wishlist button
            Positioned(top: 8, right: 8,
              child: ValueListenableBuilder<List<Product>>(
                valueListenable: wishlistNotifier,
                builder: (_, list, __) {
                  final inWish = wishlistNotifier.contains(product);
                  return GestureDetector(
                    onTap: () => wishlistNotifier.toggle(product),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: inWish ? AppColors.blush.withOpacity(0.95) : Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Icon(
                        inWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16,
                        color: inWish ? Colors.white : AppColors.slate,
                      ),
                    ),
                  );
                },
              )),
          ]),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.charcoal, height: 1.3)),
              const SizedBox(height: 6),
              // Rating
              Row(children: [
                const Icon(Icons.star_rounded, size: 12, color: AppColors.peach),
                const SizedBox(width: 3),
                Text(product.averageRating.toStringAsFixed(1),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white60 : AppColors.slate)),
                Text(' (${product.reviews.length})',
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : AppColors.muted)),
              ]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.coral)),
                  if (product.isOnSale)
                    Text('\$${product.originalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 11, color: AppColors.muted, decoration: TextDecoration.lineThrough)),
                ]),
                _AddToCartBtn(product: product),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _AddToCartBtn extends StatefulWidget {
  final Product product;
  const _AddToCartBtn({required this.product});
  @override
  State<_AddToCartBtn> createState() => _AddToCartBtnState();
}

class _AddToCartBtnState extends State<_AddToCartBtn> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));
    _scale = Tween(begin: 1.0, end: 0.82).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: cartNotifier,
      builder: (_, cart, __) {
        final inCart = cartNotifier.contains(widget.product);
        return GestureDetector(
          onTap: () {
            _ctrl.forward().then((_) => _ctrl.reverse());
            cartNotifier.add(widget.product);
            _showSnack(context, '${widget.product.name} added! 🛒');
          },
          child: ScaleTransition(
            scale: _scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: inCart ? AppColors.mint : AppColors.coral,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: (inCart ? AppColors.mint : AppColors.coral).withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Icon(inCart ? Icons.check_rounded : Icons.add_rounded, color: Colors.white, size: 20),
            ),
          ),
        );
      },
    );
  }
}

void _showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
    backgroundColor: AppColors.charcoal,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
  ));
}

// ─────────────────────────────────────────────
//  SHIMMER BOX
// ─────────────────────────────────────────────

class _ShimmerBox extends StatefulWidget {
  final double height;
  final double borderRadius;
  const _ShimmerBox({required this.height, this.borderRadius = 12});
  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: const Alignment(-1.5, 0),
            end: const Alignment(1.5, 0),
            transform: _ShimmerTransform(_ctrl.value),
            colors: isDark
                ? [const Color(0xFF2A2A45), const Color(0xFF353560), const Color(0xFF2A2A45)]
                : [const Color(0xFFEEEEEE), const Color(0xFFFAFAFA), const Color(0xFFEEEEEE)],
          ),
        ),
      ),
    );
  }
}

class _ShimmerTransform extends GradientTransform {
  final double progress;
  const _ShimmerTransform(this.progress);
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * 2 * (progress - 0.5), 0, 0);
  }
}

// ─────────────────────────────────────────────
//  PRODUCT DETAIL SCREEN
// ─────────────────────────────────────────────

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Color accentColor;
  const ProductDetailScreen({super.key, required this.product, required this.accentColor});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _showAllReviews = false;
  final TextEditingController _reviewCtrl = TextEditingController();
  int _newRating = 0;
  List<Review> _extraReviews = [];

  @override
  void dispose() { _reviewCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.cream;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.charcoal;

    final allReviews = [...widget.product.reviews, ..._extraReviews];
    final visibleReviews = _showAllReviews ? allReviews : allReviews.take(2).toList();
    final avgRating = allReviews.isEmpty ? 0.0
        : allReviews.map((r) => r.rating).reduce((a, b) => a + b) / allReviews.length;

    return Scaffold(
      backgroundColor: bg,
      body: Column(children: [
        Expanded(
          child: CustomScrollView(slivers: [
            // Hero app bar
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: widget.accentColor.withOpacity(isDark ? 0.4 : 0.6),
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.charcoal, size: 18),
                ),
              ),
              actions: [
                // Share button
                GestureDetector(
                  onTap: () => _showShareSheet(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                    child: const Icon(Icons.ios_share_rounded, color: AppColors.charcoal, size: 18),
                  ),
                ),
                // Wishlist button
                ValueListenableBuilder<List<Product>>(
                  valueListenable: wishlistNotifier,
                  builder: (_, __, ___) {
                    final inWish = wishlistNotifier.contains(widget.product);
                    return GestureDetector(
                      onTap: () => wishlistNotifier.toggle(widget.product),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: inWish ? AppColors.blush : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          inWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: inWish ? Colors.white : AppColors.charcoal, size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product_${widget.product.id}',
                  child: Image.network(
                    widget.product.imageUrl, fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null ? child : _ShimmerBox(height: 300, borderRadius: 0),
                    errorBuilder: (_, __, ___) => Container(
                      color: widget.accentColor,
                      child: Center(child: Text(widget.product.emoji, style: const TextStyle(fontSize: 80))),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: cardBg, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Category + sale badge
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: widget.accentColor.withOpacity(isDark ? 0.3 : 1.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(widget.product.category,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                              color: isDark ? widget.accentColor : AppColors.charcoal)),
                        ),
                        if (widget.product.isOnSale) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(20)),
                            child: const Text('ON SALE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 12),
                      Text(widget.product.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textColor, letterSpacing: -0.8, fontFamily: 'Georgia')),
                      const SizedBox(height: 12),
                      // Price row
                      Row(children: [
                        Text('\$${widget.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.coral)),
                        if (widget.product.isOnSale) ...[
                          const SizedBox(width: 10),
                          Text('\$${widget.product.originalPrice.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, color: AppColors.muted, decoration: TextDecoration.lineThrough)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              '${(((widget.product.originalPrice - widget.product.price) / widget.product.originalPrice) * 100).round()}% OFF',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF166534)),
                            ),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 16),
                      // Rating summary
                      Row(children: [
                        ...List.generate(5, (i) => Icon(
                          i < avgRating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 18, color: AppColors.peach,
                        )),
                        const SizedBox(width: 8),
                        Text('${avgRating.toStringAsFixed(1)} (${allReviews.length} reviews)',
                          style: TextStyle(fontSize: 13, color: isDark ? Colors.white60 : AppColors.slate, fontWeight: FontWeight.w600)),
                      ]),
                      const SizedBox(height: 20),
                      // Description
                      Text('About this item',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textColor.withOpacity(0.5))),
                      const SizedBox(height: 8),
                      Text(widget.product.description,
                        style: TextStyle(fontSize: 14.5, height: 1.7, color: textColor.withOpacity(0.85))),
                      const SizedBox(height: 24),
                      // Spec badges
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        _specBadge('⭐ ${avgRating.toStringAsFixed(1)} Rated', widget.accentColor, isDark),
                        _specBadge('🚚 Free Delivery', widget.accentColor, isDark),
                        _specBadge('↩️ 30-Day Return', widget.accentColor, isDark),
                        _specBadge('🛡️ Secure Payment', widget.accentColor, isDark),
                      ]),
                      const SizedBox(height: 28),
                    ]),
                  ),

                  // Reviews section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE)),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textColor, fontFamily: 'Georgia')),
                        GestureDetector(
                          onTap: () => _showReviewSheet(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.coral.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.coral.withOpacity(0.3)),
                            ),
                            child: const Text('Write one', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700, fontSize: 12)),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      if (allReviews.isEmpty)
                        Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text('No reviews yet. Be the first! 💬',
                            style: TextStyle(color: isDark ? Colors.white38 : AppColors.muted)),
                        ))
                      else ...[
                        ...visibleReviews.map((r) => _ReviewTile(review: r, isDark: isDark)),
                        if (allReviews.length > 2)
                          GestureDetector(
                            onTap: () => setState(() => _showAllReviews = !_showAllReviews),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                _showAllReviews ? 'Show less ↑' : 'View all ${allReviews.length} reviews ↓',
                                style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                          ),
                      ],
                    ]),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ]),
        ),

        // Bottom action bar
        Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          decoration: BoxDecoration(
            color: cardBg,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
          ),
          child: ValueListenableBuilder<List<CartItem>>(
            valueListenable: cartNotifier,
            builder: (_, cart, __) {
              final inCart = cartNotifier.contains(widget.product);
              return Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text('Price', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : AppColors.muted)),
                  Text('\$${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.coral)),
                ]),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (inCart) {
                        cartNotifier.remove(cart.firstWhere((i) => i.product.id == widget.product.id));
                      } else {
                        cartNotifier.add(widget.product);
                        _showSnack(context, '${widget.product.name} added to cart! 🛒');
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: inCart ? AppColors.mint : AppColors.coral,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: (inCart ? AppColors.mint : AppColors.coral).withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 5))],
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(inCart ? Icons.check_circle_rounded : Icons.add_shopping_cart_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(inCart ? 'Added to Cart ✓' : 'Add to Cart',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                      ]),
                    ),
                  ),
                ),
              ]);
            },
          ),
        ),
      ]),
    );
  }

  Widget _specBadge(String label, Color accent, bool isDark) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: accent.withOpacity(isDark ? 0.2 : 0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: accent.withOpacity(0.3)),
    ),
    child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? accent.withOpacity(0.9) : AppColors.charcoal)),
  );

  void _showReviewSheet(BuildContext context) {
    _newRating = 0;
    _reviewCtrl.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (ctx, setModalState) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bg = isDark ? AppColors.darkCard : Colors.white;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(color: bg, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Write a Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : AppColors.charcoal, fontFamily: 'Georgia')),
              const SizedBox(height: 20),
              Text('Your rating', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white60 : AppColors.slate)),
              const SizedBox(height: 10),
              Row(children: List.generate(5, (i) => GestureDetector(
                onTap: () => setModalState(() => _newRating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(i < _newRating ? Icons.star_rounded : Icons.star_border_rounded, color: AppColors.peach, size: 36),
                ),
              ))),
              const SizedBox(height: 20),
              TextField(
                controller: _reviewCtrl,
                maxLines: 3,
                style: TextStyle(color: isDark ? Colors.white : AppColors.charcoal),
                decoration: InputDecoration(
                  hintText: 'Share your experience with this product...',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : AppColors.muted, fontSize: 14),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    if (_newRating == 0 || _reviewCtrl.text.trim().isEmpty) {
                      _showSnack(context, 'Please add a rating and comment!');
                      return;
                    }
                    setState(() {
                      _extraReviews.add(Review(
                        reviewer: 'You', avatar: 'YO', rating: _newRating.toDouble(),
                        comment: _reviewCtrl.text.trim(), date: 'Just now',
                      ));
                      _showAllReviews = true;
                    });
                    Navigator.pop(context);
                    _showSnack(context, 'Review submitted! Thank you 🙏');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.coral,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppColors.coral.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 5))],
                    ),
                    child: const Center(child: Text('Submit Review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15))),
                  ),
                ),
              ),
            ]),
          ),
        );
      }),
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bg = isDark ? AppColors.darkCard : Colors.white;
        final textColor = isDark ? Colors.white : AppColors.charcoal;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
          decoration: BoxDecoration(color: bg, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Share Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'Georgia')),
            const SizedBox(height: 20),
            // Mini product card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.product.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: AppColors.cardAccents[widget.product.id % 8],
                      child: Center(child: Text(widget.product.emoji, style: const TextStyle(fontSize: 28))))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.product.name, style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 14)),
                  Text('\$${widget.product.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w900)),
                ])),
              ]),
            ),
            const SizedBox(height: 24),
            // Share icons
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _shareIcon('WhatsApp', '💬', const Color(0xFF25D366)),
              _shareIcon('Instagram', '📸', const Color(0xFFE1306C)),
              _shareIcon('Twitter', '🐦', const Color(0xFF1DA1F2)),
              _shareIcon('Copy Link', '🔗', AppColors.slate),
            ]),
            const SizedBox(height: 24),
            // Copy link field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Expanded(child: Text('shopnest://product/${widget.product.id}',
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : AppColors.muted))),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: 'shopnest://product/${widget.product.id}'));
                    Navigator.pop(context);
                    _showSnack(context, 'Link copied! 🔗');
                  },
                  child: const Text('Copy', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ]),
            ),
          ]),
        );
      },
    );
  }

  Widget _shareIcon(String label, String icon, Color color) {
    return Column(children: [
      Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.25))),
        child: Center(child: Text(icon, style: const TextStyle(fontSize: 26))),
      ),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted)),
    ]);
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  final bool isDark;
  const _ReviewTile({required this.review, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: AppColors.coral.withOpacity(0.15), shape: BoxShape.circle),
          child: Center(child: Text(review.avatar, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.coral))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(review.reviewer, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isDark ? Colors.white : AppColors.charcoal)),
            const Spacer(),
            Text(review.date, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : AppColors.muted)),
          ]),
          const SizedBox(height: 4),
          Row(children: List.generate(5, (i) => Icon(
            i < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
            size: 13, color: AppColors.peach,
          ))),
          const SizedBox(height: 4),
          Text(review.comment, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : AppColors.slate, height: 1.5)),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  WISHLIST SCREEN
// ─────────────────────────────────────────────

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: ValueListenableBuilder<List<Product>>(
        valueListenable: wishlistNotifier,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('🤍', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text('No favourites yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: isDark ? Colors.white54 : AppColors.slate, fontFamily: 'Georgia')),
              const SizedBox(height: 8),
              Text('Tap ❤️ on any product to save it here', style: TextStyle(color: isDark ? Colors.white38 : AppColors.muted, fontSize: 14)),
            ]));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.68,
            ),
            itemCount: list.length,
            itemBuilder: (_, i) => _ProductCard(product: list[i]),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CART SCREEN
// ─────────────────────────────────────────────

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: cartNotifier,
        builder: (_, cart, __) {
          if (cart.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('🛒', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: isDark ? Colors.white54 : AppColors.slate, fontFamily: 'Georgia')),
              const SizedBox(height: 8),
              Text('Add something you love 💛', style: TextStyle(color: isDark ? Colors.white38 : AppColors.muted)),
            ]));
          }
          return Column(children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cart.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final item = cart[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.06), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(item.product.imageUrl, width: 76, height: 76, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 76, height: 76,
                            color: AppColors.cardAccents[item.product.id % 8],
                            child: Center(child: Text(item.product.emoji, style: const TextStyle(fontSize: 32))))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.product.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: isDark ? Colors.white : AppColors.charcoal)),
                        const SizedBox(height: 4),
                        Text(item.product.category, style: const TextStyle(fontSize: 12, color: AppColors.coral, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Text('\$${item.product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.coral)),
                          const Spacer(),
                          // Quantity controls
                          _QtyButton(icon: Icons.remove_rounded, onTap: () => cartNotifier.decrement(item), isDark: isDark),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('${item.quantity}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppColors.charcoal)),
                          ),
                          _QtyButton(icon: Icons.add_rounded, onTap: () => cartNotifier.increment(item), isDark: isDark),
                        ]),
                      ])),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => cartNotifier.remove(item),
                        child: Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
            // Summary footer
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
              ),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${cartNotifier.totalItems} item${cartNotifier.totalItems > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : AppColors.muted)),
                  Text('Subtotal: \$${cartNotifier.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.coral)),
                ]),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      title: const Text('Order Placed! 🎉', style: TextStyle(fontWeight: FontWeight.w900, fontFamily: 'Georgia')),
                      content: const Text('Thank you for shopping with ShopNest! Your order is on its way.'),
                      actions: [
                        TextButton(
                          onPressed: () { cartNotifier.clear(); Navigator.pop(context); },
                          child: const Text('Done', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.coral, Color(0xFFFF8E53)]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: AppColors.coral.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: const Center(child: Text('Checkout  →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.3))),
                  ),
                ),
              ]),
            ),
          ]);
        },
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  const _QtyButton({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE)),
        ),
        child: Icon(icon, size: 16, color: isDark ? Colors.white70 : AppColors.charcoal),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROFILE SCREEN
// ─────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.charcoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, mode, __) => IconButton(
              icon: Icon(mode == ThemeMode.dark ? Icons.wb_sunny_rounded : Icons.nightlight_round, size: 22),
              onPressed: themeNotifier.toggle,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.coral, Color(0xFFFF8E53)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
                child: const Center(child: Text('👤', style: TextStyle(fontSize: 38))),
              ),
              const SizedBox(height: 14),
              const Text('Guest User', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'Georgia')),
              const SizedBox(height: 4),
              const Text('guest@shopnest.app', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _statChip('Orders', '12'),
                Container(width: 1, height: 30, color: Colors.white30, margin: const EdgeInsets.symmetric(horizontal: 16)),
                ValueListenableBuilder<List<Product>>(valueListenable: wishlistNotifier, builder: (_, l, __) => _statChip('Wishlist', '${l.length}')),
                Container(width: 1, height: 30, color: Colors.white30, margin: const EdgeInsets.symmetric(horizontal: 16)),
                ValueListenableBuilder<List<CartItem>>(valueListenable: cartNotifier, builder: (_, c, __) => _statChip('In Cart', '${c.length}')),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          // Menu items
          ...([
            ('🛍️', 'My Orders', 'View your order history'),
            ('📍', 'Delivery Address', 'Manage your addresses'),
            ('💳', 'Payment Methods', 'Cards and UPI'),
            ('🔔', 'Notifications', 'Manage alerts'),
            ('🛡️', 'Privacy & Security', 'Account settings'),
            ('❓', 'Help & Support', 'FAQs and contact'),
          ].map((item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE))),
            child: ListTile(
              leading: Text(item.$1, style: const TextStyle(fontSize: 22)),
              title: Text(item.$2, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textColor)),
              subtitle: Text(item.$3, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : AppColors.muted)),
              trailing: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white38 : AppColors.muted),
              onTap: () {},
            ),
          ))),
          const SizedBox(height: 8),
          // Theme toggle
          Container(
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE))),
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (_, mode, __) => ListTile(
                leading: Text(mode == ThemeMode.dark ? '🌙' : '☀️', style: const TextStyle(fontSize: 22)),
                title: Text(mode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textColor)),
                subtitle: Text('Tap to toggle', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : AppColors.muted)),
                trailing: Switch(value: mode == ThemeMode.dark, onChanged: (_) => themeNotifier.toggle(), activeColor: AppColors.coral),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(child: Text('ShopNest v2.0  ·  Made with ❤️  ·  2026',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white24 : AppColors.muted))),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value) => Column(children: [
    Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
  ]);
}