import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/common/venue_card.dart';
import 'package:venure/features/booking/presentation/view/main_booking_page.dart';
import 'package:venure/features/common/presentation/view/venue_details_page.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_bloc.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_event.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_event.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_state.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color deepPurple = Color(0xFF1A0B2E);
  static const Color richBlack = Color(0xFF0F0F0F);
  static const Color pearlWhite = Color(0xFFFFFDF7);
  static const Color warmGray = Color(0xFF8B8B8B);
  static const Color luxuryGradientStart = Color(0xFF2D1B69);
  static const Color luxuryGradientEnd = Color(0xFF11998E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pearlWhite,
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
                _buildTopPicksSection(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return SliverAppBar(
      expandedHeight: 250,
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderTopRow(),
                const Text(
                  "Welcome Back",
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
        ),
      ),
    );
  }

  Widget _buildHeaderTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Discover Premium Venues",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: pearlWhite.withOpacity(0.9),
            letterSpacing: 0.5,
          ),
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
          icon: Icon(Icons.search_rounded, color: primaryGold, size: 24),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryGold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune_rounded, color: pearlWhite, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    final featuredVenues = [
      {
        'image': 'assets/img/bar.jpg',
        'title': 'The Grand Palace',
        'subtitle': 'Kathmandu, Nepal',
      },
      {
        'image': 'assets/img/club.jpg',
        'title': 'Royal Gardens',
        'subtitle': 'Lalitpur, Nepal',
      },
    ];

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
            itemCount: featuredVenues.length,
            itemBuilder: (context, index) {
              final venue = featuredVenues[index];
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
                      Image.asset(venue['image']!, fit: BoxFit.cover),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
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
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {
        'icon': Icons.cake_outlined,
        'name': 'Birthday',
        'color': const Color(0xFFFF6B6B),
      },
      {
        'icon': Icons.favorite_outline,
        'name': 'Wedding',
        'color': const Color(0xFFFF8E53),
      },
      {
        'icon': Icons.celebration_outlined,
        'name': 'Engagement',
        'color': const Color(0xFF4ECDC4),
      },
      {
        'icon': Icons.business_outlined,
        'name': 'Business',
        'color': const Color(0xFF45B7D1),
      },
      {
        'icon': Icons.school_outlined,
        'name': 'Graduation',
        'color': const Color(0xFF96CEB4),
      },
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

  Widget _buildTopPicksSection(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is HomeScreenLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeScreenError) {
          return Center(child: Text(state.error));
        } else if (state is HomeScreenLoaded) {
          final venues = state.venues;
          if (venues.isEmpty) {
            return const Center(child: Text("No venues available."));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Our Top Picks",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: richBlack,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: venues.length,
                itemBuilder: (context, index) {
                  final venue = venues[index];
                  final isFavorite = state.favoriteVenueIds.contains(venue.id);
                  return VenueCard(
                    key: ValueKey(venue.id),
                    venue: venue,
                    isFavorite: isFavorite,
                    onFavoriteToggle: () {
                      context.read<HomeScreenBloc>().add(
                        ToggleFavoriteVenue(venue.id),
                      );
                    },

                    onBookNow: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => MainBookingPage(
                                venueName: venue.venueName,
                                venueId: venue.id,
                                onSubmit: (bookingData) {},
                              ),
                        ),
                      );
                    },
                    onDetailsPage: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider(
                                create:
                                    (_) =>
                                        serviceLocator<VenueDetailsBloc>()
                                          ..add(LoadVenueDetails(venue.id)),
                                child: VenueDetailsPage(venueId: venue.id),
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
