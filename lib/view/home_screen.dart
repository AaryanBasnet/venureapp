import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:venure/common/category_icon.dart';
// import 'package:venure/common/venue_card.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<Map<String, String>> featuredVenues = [
    {
      'image': 'assets/img/club.jpg',
      'title': 'Luxury Club Experience',
      'subtitle': 'Premium nightlife destination'
    },
    {
      'image': 'assets/img/banquet1.jpg',
      'title': 'Grand Ballroom',
      'subtitle': 'Elegant celebration spaces'
    },
    {
      'image': 'assets/img/bar.jpg',
      'title': 'Exclusive Lounge',
      'subtitle': 'Sophisticated cocktail bar'
    },
    {
      'image': 'assets/img/hotel.jpg',
      'title': 'Boutique Hotel',
      'subtitle': 'Luxury accommodation'
    },
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedNavIndex = 0;

  // Premium color palette
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color deepPurple = Color(0xFF1A0B2E);
  static const Color richBlack = Color(0xFF0F0F0F);
  static const Color pearlWhite = Color(0xFFFFFDF7);
  static const Color silverGray = Color(0xFFC0C0C0);
  static const Color warmGray = Color(0xFF8B8B8B);
  static const Color luxuryGradientStart = Color(0xFF2D1B69);
  static const Color luxuryGradientEnd = Color(0xFF11998E);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pearlWhite,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: CustomScrollView(
        slivers: [
          _buildPremiumHeader(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildFeaturedCarousel(),
                const SizedBox(height: 40),
                _buildCategoriesSection(),
                const SizedBox(height: 40),
                _buildTopPicksSection(),
                const SizedBox(height: 100), // Bottom padding for nav bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildPremiumBottomNavBar(),
    );
  }

  Widget _buildPremiumHeader() {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [luxuryGradientStart, luxuryGradientEnd],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topRight,
                      radius: 2.0,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderTopRow(),
                    const SizedBox(height: 8),
                    const Text(
                      "Aaryan Basnet",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: pearlWhite,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    _buildPremiumSearchBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: pearlWhite.withOpacity(0.9),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: pearlWhite,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        style: const TextStyle(
          fontSize: 16,
          color: richBlack,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: "Discover exceptional venues...",
          hintStyle: TextStyle(
            color: warmGray,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          icon: Icon(
            Icons.search_rounded,
            color: primaryGold,
            size: 24,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryGold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: pearlWhite,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Featured Venues",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: richBlack,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _pageController,
            itemCount: featuredVenues.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _buildCarouselCard(featuredVenues[index], index);
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildElegantPageIndicator(),
      ],
    );
  }

  Widget _buildCarouselCard(Map<String, String> venue, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              venue['image']!,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue['title']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: pearlWhite,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    venue['subtitle']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: pearlWhite.withOpacity(0.9),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryGold,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Premium",
                  style: TextStyle(
                    color: pearlWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElegantPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(featuredVenues.length, (index) {
        bool isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? primaryGold : silverGray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'icon': Icons.cake_outlined, 'name': 'Birthday', 'color': const Color(0xFFFF6B6B)},
      {'icon': Icons.favorite_outline, 'name': 'Wedding', 'color': const Color(0xFFFF8E53)},
      {'icon': Icons.celebration_outlined, 'name': 'Engagement', 'color': const Color(0xFF4ECDC4)},
      {'icon': Icons.business_outlined, 'name': 'Business', 'color': const Color(0xFF45B7D1)},
      {'icon': Icons.school_outlined, 'name': 'Graduation', 'color': const Color(0xFF96CEB4)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Event Categories",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: richBlack,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: (category['color'] as Color).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        size: 32,
                        color: category['color'] as Color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: richBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopPicksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Our Top Picks",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: richBlack,
                  letterSpacing: 0.5,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryGold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildVenueCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVenueCard(int index) {
    final venues = [
      {'name': 'The Grand Palace', 'location': 'Kathmandu', 'rating': '4.9', 'price': '\$200'},
      {'name': 'Royal Gardens', 'location': 'Lalitpur', 'rating': '4.8', 'price': '\$180'},
      {'name': 'Elite Banquet', 'location': 'Bhaktapur', 'rating': '4.7', 'price': '\$150'},
      {'name': 'Luxury Lounge', 'location': 'Pokhara', 'rating': '4.6', 'price': '\$120'},
      {'name': 'Premium Hall', 'location': 'Chitwan', 'rating': '4.5', 'price': '\$100'},
    ];

    final venue = venues[index % venues.length];

    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: AssetImage(featuredVenues[index % featuredVenues.length]['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: richBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: richBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: warmGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      venue['location']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: warmGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: primaryGold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          venue['rating']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: richBlack,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${venue['price']!}/hr',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryGold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: NavigationBar(
          height: 80,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: _selectedNavIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedNavIndex = index);
          },
          indicatorColor: primaryGold.withOpacity(0.15),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: warmGray),
              selectedIcon: Icon(Icons.home, color: primaryGold),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: warmGray),
              selectedIcon: Icon(Icons.search, color: primaryGold),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline, color: warmGray),
              selectedIcon: Icon(Icons.favorite, color: primaryGold),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: warmGray),
              selectedIcon: Icon(Icons.person, color: primaryGold),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}