// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:venure/features/favorite/presentation/view_model/favorite_view_model.dart';
// import 'package:venure/features/favorite/presentation/view_model/favorites_event.dart';
// import 'package:venure/features/favorite/presentation/view_model/favorites_state.dart';
// import 'package:venure/features/home/domain/entity/venue_entity.dart';
// import 'package:venure/features/home/domain/repository/venue_repository.dart';
// import 'package:venure/features/home/presentation/view_model/home_screen_event.dart' hide LoadFavorites;
// import 'package:venure/features/home/presentation/view_model/home_screen_event.dart' as favorite_events;

// class FavoritesPageView extends StatelessWidget {
//   const FavoritesPageView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Favorite Venues')),
//       body: BlocProvider(
//         create: (context) => FavoritesBloc(
//           venueRepository: context.read<IVenueRepository>(),
//         )..add(LoadFavorites()),
//         child: BlocBuilder<FavoritesBloc, FavoritesState>(
//           builder: (context, state) {
//             if (state is FavoritesLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is FavoritesLoaded) {
//               final favorites = state.favoriteVenues;

//               if (favorites.isEmpty) {
//                 return const Center(child: Text('No favorite venues yet'));
//               }

//               return ListView.builder(
//                 itemCount: favorites.length,
//                 itemBuilder: (context, index) {
//                   final venue = favorites[index];

//                   return Dismissible(
//                     key: Key(venue.id),
//                     direction: DismissDirection.endToStart,
//                     background: Container(
//                       color: Colors.red,
//                       alignment: Alignment.centerRight,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: const Icon(Icons.delete, color: Colors.white),
//                     ),
//                     onDismissed: (_) {
//                       context.read<FavoritesBloc>().add(UnfavoriteVenue(venue.id));

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('${venue.venueName} removed from favorites')),
//                       );
//                     },
//                     child: ListTile(
//                       title: Text(venue.venueName),
//                       subtitle: Text(venue.location?.address ?? ''),
//                       leading: venue.venueImages.isNotEmpty
//                           ? Image.network(
//                               venue.venueImages.first.url,
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                             )
//                           : const Icon(Icons.location_on),
//                       onTap: () {
//                         // Optional: Navigate to venue details
//                       },
//                     ),
//                   );
//                 },
//               );
//             } else if (state is FavoritesError) {
//               return Center(child: Text('Error: ${state.message}'));
//             } else {
//               return const SizedBox.shrink();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
