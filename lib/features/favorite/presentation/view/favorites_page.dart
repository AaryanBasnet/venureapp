// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:venure/features/favorite/presentation/view_model/favorite_view_model.dart';
// import 'package:venure/features/favorite/presentation/view_model/favorites_event.dart';
// import 'package:venure/features/favorite/presentation/view/favorites_page_view.dart';
// import 'package:venure/features/home/domain/repository/venue_repository.dart'; // Your UI widget

// class FavoritesPage extends StatelessWidget {
//   final IVenueRepository venueRepository;

//   const FavoritesPage({required this.venueRepository, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => FavoritesBloc(venueRepository: venueRepository)..add(LoadFavorites()),
//       child: const FavoritesPageView(), // This is your actual UI implementation of the favorites screen
//     );
//   }
// }
