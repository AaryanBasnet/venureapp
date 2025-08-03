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

  
}
