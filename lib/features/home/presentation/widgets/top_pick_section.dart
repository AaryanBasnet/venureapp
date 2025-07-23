
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/common/venue_card.dart';
import 'package:venure/features/booking/presentation/view/main_booking_page.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_bloc.dart';
import 'package:venure/features/common/presentation/view/venue_details_page.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_bloc.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_event.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_event.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_state.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';

class TopPickSection extends StatelessWidget {
  const TopPickSection({
    super.key,
    required this.richBlack,
    required this.context,
  });

  final Color richBlack;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                pricePerHour: venue.pricePerHour.toInt(),
                                onSubmit: (bookingData) {},
                              ),
                        ),
                      );
                    },
                    onDetailsPage: () {
                      final chatBloc = context.read<ChatListBloc>();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(value: chatBloc),
                                  BlocProvider(
                                    create:
                                        (_) =>
                                            serviceLocator<VenueDetailsBloc>()
                                              ..add(LoadVenueDetails(venue.id)),
                                  ),
                                ],
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
