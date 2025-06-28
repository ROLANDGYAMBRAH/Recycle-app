import 'package:flutter/material.dart';

class CollectorHomeScreen extends StatefulWidget {
  const CollectorHomeScreen({Key? key}) : super(key: key);

  @override
  State<CollectorHomeScreen> createState() => _CollectorHomeScreenState();
}

class _CollectorHomeScreenState extends State<CollectorHomeScreen> {
  int _selectedTab = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });
    // You can navigate or perform actions here for each tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // The main scrollable content
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Header
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: const Color(0xFFE4F5DB),
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/profile.png'),
                                    fit: BoxFit.cover,
                                    onError: (exception, stackTrace) {
                                      // Handle image loading error
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hello Kofi,',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF34A853),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search, color: Color(0xFF203040), size: 28),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Stats section
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'EARNED',
                                value: 'GHS 152.00',
                                chartColor: Color(0xFF56D39F),
                                change: '+15% this week',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ProgressStat(
                                label: 'KG COLLECTED',
                                value: '72 kg',
                                percent: 0.8,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ProgressStat(
                                label: 'CO2 SAVED',
                                value: '500 g',
                                percent: 0.7,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Search bar
                        Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8FA),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: Color(0xFFE0E0E0)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(Icons.search, color: Color(0xFFB8B8B8)),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'What do you want to recycle?',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Color(0xFF607180),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 17),
                                  cursorColor: Color(0xFF34A853),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Categories - horizontal
                        SizedBox(
                          height: 96,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            scrollDirection: Axis.horizontal,
                            children: [
                              _CategoryCard(image: 'assets/images/plastic.png', label: 'Plastic'),
                              _CategoryCard(image: 'assets/images/glass.png', label: 'Glass'),
                              _CategoryCard(image: 'assets/images/metal.png', label: 'Metal'),
                              _CategoryCard(image: 'assets/images/paper.png', label: 'Paper'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Hot Deals
                        Row(
                          children: [
                            const Text(
                              '🔥 Hot Deals Near You',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF203040),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'view all',
                                style: TextStyle(
                                  color: Color(0xFF7B8BA4),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        _HotDealCard(),
                        const SizedBox(height: 8),
                        _HotDealCard(),
                        const SizedBox(height: 18),
                        // How to Earn and Learn more
                        Row(
                          children: [
                            const Text(
                              '💡 How to Earn',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF33434A),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Learn more >',
                                style: TextStyle(
                                  color: Color(0xFF203040),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // How to Earn Row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _HowToEarnCard(
                                image: 'assets/images/collect_waste.png',
                                label: 'Collect\nWaste',
                              ),
                              _HowToEarnCard(
                                image: 'assets/images/find_compounder.png',
                                label: 'Find\nCompounder',
                              ),
                              _HowToEarnCard(
                                image: 'assets/images/exchange_cash.png',
                                label: 'Exchange\nfor Cash',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100), // Space for bottom navbar
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Bottom NavBar
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomNavBar(
                selected: _selectedTab,
                onTab: _onTabSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======== Sub-Widgets =======

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color chartColor;
  final String change;

  const _StatCard({
    required this.label,
    required this.value,
    required this.chartColor,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Increased height to prevent overflow
      decoration: BoxDecoration(
        color: Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF607180),
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF144A3F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 16,
                  width: 28,
                  child: CustomPaint(
                    painter: _MiniChartPainter(chartColor),
                  ),
                ),
              ],
            ),
          ),
          Text(
            change,
            style: TextStyle(
              color: Color(0xFF5BBF4B),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  final Color color;
  _MiniChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.4, size.height * 0.2, size.width, size.height * 0.1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final String value;
  final double percent;

  const _ProgressStat({
    required this.label,
    required this.value,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Increased height to match StatCard
      decoration: BoxDecoration(
        color: Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF607180),
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF144A3F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 28,
                  height: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: percent.clamp(0.0, 1.0),
                      backgroundColor: Color(0xFFE6F7D9),
                      valueColor: AlwaysStoppedAnimation(Color(0xFF38B000)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            '', // Empty text to maintain spacing
            style: TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String image;
  final String label;

  const _CategoryCard({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            child: Image.asset(
              image,
              width: 38,
              height: 38,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 38,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF203040),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _HotDealCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFDFCF8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            child: Image.asset(
              'assets/images/blue_bag.png',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.shopping_bag, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pure Water Rubbers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF213341),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'GHS 0.45 per kg',
                  style: TextStyle(
                    color: Color(0xFF2FB000),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.verified, color: Color(0xFF9CA8B8), size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Top-rated Compounder',
                          style: TextStyle(
                            color: Color(0xFF9CA8B8),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF6D2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 12, color: Color(0xFFF9D246)),
                            const SizedBox(width: 2),
                            Text(
                              'Top',
                              style: TextStyle(
                                color: Color(0xFFF9C800),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HowToEarnCard extends StatelessWidget {
  final String image;
  final String label;

  const _HowToEarnCard({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              image,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey,
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF425663),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selected;
  final Function(int) onTab;

  const _BottomNavBar({Key? key, required this.selected, required this.onTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavBarItem(icon: Icons.home, label: 'Home'),
      _NavBarItem(icon: Icons.search, label: 'Search'),
      _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Chats'),
      _NavBarItem(icon: Icons.school, label: 'Learn'),
      _NavBarItem(icon: Icons.person_outline, label: 'Profile'),
    ];
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(

            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          return Expanded(
            child: InkWell(
              onTap: () => onTab(i),
              borderRadius: BorderRadius.circular(12),
              child: items[i].copyWith(active: i == selected),
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavBarItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  Widget copyWith({bool? active}) => _NavBarItem(
    icon: icon,
    label: label,
    active: active ?? this.active,
  );

  @override
  Widget build(BuildContext context) {
    final color = active ? Color(0xFF38B000) : Color(0xFF97B8B0);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}