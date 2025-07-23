
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_bloc.dart';
import 'package:venure/features/home/presentation/view/search_page.dart';
import 'package:venure/features/home/presentation/view_model/search_bloc.dart';

class PremiumSearchBar extends StatelessWidget {
  const PremiumSearchBar({
    super.key,
    required this.richBlack,
    required this.warmGray,
    required this.primaryGold,
    required this.pearlWhite,
    required this.context,
  });

  final Color richBlack;
  final Color warmGray;
  final Color primaryGold;
  final Color pearlWhite;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<ChatListBloc>()),
                    BlocProvider(create: (_) => serviceLocator<SearchBloc>()),
                  ],
                  child: const SearchPage(),
                ),
          ),
        );
      },
      child: Container(
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
        child: IgnorePointer(
          // Prevents keyboard from popping up
          child: TextField(
            style: TextStyle(
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
                child: Icon(
                  Icons.tune_rounded,
                  color: pearlWhite,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
