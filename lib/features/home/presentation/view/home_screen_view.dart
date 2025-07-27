import 'package:flutter/material.dart';

import 'package:venure/features/home/presentation/widgets/featured_carasoul.dart';
import 'package:venure/features/home/presentation/widgets/header_top_row.dart';
import 'package:venure/features/home/presentation/widgets/premium_search_bar.dart';
import 'package:venure/features/home/presentation/widgets/top_pick_section.dart';

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
          _buildPremiumHeader(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                FeaturedCarousel(
                  richBlack: richBlack,
                  pearlWhite: pearlWhite,
                  primaryGold: primaryGold,
                ),
                const SizedBox(height: 40),
                // _buildCategoriesSection(),
                const SizedBox(height: 40),
                TopPickSection(richBlack: richBlack, parentContext: context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
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
                HeaderTopRow(pearlWhite: pearlWhite),
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
                PremiumSearchBar(
                  richBlack: richBlack,
                  warmGray: warmGray,
                  primaryGold: primaryGold,
                  pearlWhite: pearlWhite,
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //   Widget _buildCategoriesSection() {
  //     final categories = [
  //       {
  //         'icon': Icons.cake_outlined,
  //         'name': 'Birthday',
  //         'color': const Color(0xFFFF6B6B),
  //       },
  //       {
  //         'icon': Icons.favorite_outline,
  //         'name': 'Wedding',
  //         'color': const Color(0xFFFF8E53),
  //       },
  //       {
  //         'icon': Icons.celebration_outlined,
  //         'name': 'Engagement',
  //         'color': const Color(0xFF4ECDC4),
  //       },
  //       {
  //         'icon': Icons.business_outlined,
  //         'name': 'Business',
  //         'color': const Color(0xFF45B7D1),
  //       },
  //       {
  //         'icon': Icons.school_outlined,
  //         'name': 'Graduation',
  //         'color': const Color(0xFF96CEB4),
  //       },
  //     ];

  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 24),
  //           child: Text(
  //             "Event Categories",
  //             style: TextStyle(
  //               fontSize: 28,
  //               fontWeight: FontWeight.w600,
  //               color: richBlack,
  //               letterSpacing: 0.5,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         SizedBox(
  //           height: 120,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             itemCount: categories.length,
  //             itemBuilder: (context, index) {
  //               final category = categories[index];
  //               return Container(
  //                 width: 100,
  //                 margin: const EdgeInsets.symmetric(horizontal: 8),
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       width: 70,
  //                       height: 70,
  //                       decoration: BoxDecoration(
  //                         color: (category['color'] as Color).withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(20),
  //                         border: Border.all(
  //                           color: (category['color'] as Color).withOpacity(0.3),
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: Icon(
  //                         category['icon'] as IconData,
  //                         size: 32,
  //                         color: category['color'] as Color,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 12),
  //                     Text(
  //                       category['name'] as String,
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                         color: richBlack,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     );
  //   }
}
