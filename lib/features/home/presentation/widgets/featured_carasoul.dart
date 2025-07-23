
import 'package:flutter/material.dart';

class FeaturedCarousel extends StatelessWidget {
  const FeaturedCarousel({
    super.key,
    required this.richBlack,
    required this.pearlWhite,
    required this.primaryGold,
  });

  final Color richBlack;
  final Color pearlWhite;
  final Color primaryGold;

  @override
  Widget build(BuildContext context) {
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              style: TextStyle(
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
                          child: Text(
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
}
