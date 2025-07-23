import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/common/venue_card.dart';
import 'package:venure/features/booking/presentation/view/main_booking_page.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_bloc.dart';
import 'package:venure/features/common/presentation/view/venue_details_page.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_bloc.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_event.dart';
import 'package:venure/features/home/presentation/view_model/search_bloc.dart';
import 'package:venure/features/home/presentation/view_model/search_event.dart';
import 'package:venure/features/home/presentation/view_model/search_state.dart';
import 'package:venure/features/home/presentation/widgets/filter_sheet.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? _debounce;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedCity;
  String? _selectedCapacityRange;
  List<String> _selectedAmenities = [];
  String? _selectedSort;

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadDefaultVenuesEvent());
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _triggerSearch();
  }

  void _triggerSearch() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchBloc>().add(
        SearchQueryChangedEvent(
          query: _searchQuery,
          city: _selectedCity,
          capacityRange: _selectedCapacityRange,
          amenities: _selectedAmenities,
          sort: _selectedSort,
        ),
      );
    });
  }

  void _openFilterDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => FilterSheet(
            selectedCategory: _selectedCategory,
            selectedCity: _selectedCity,
            selectedCapacity: _selectedCapacityRange,
            selectedAmenities: _selectedAmenities,
            selectedSort: _selectedSort,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedCategory = result['category'];
        _selectedCity = result['city'];
        _selectedCapacityRange = result['capacity'];
        _selectedAmenities = List<String>.from(result['amenities'] ?? []);
        _selectedSort = result['sort'];
      });
      _triggerSearch();
    }
  }

  Widget _buildActiveFilters() {
    final chips = <Widget>[];
    if (_selectedCategory != null) {
      chips.add(_buildFilterChip('Category', _selectedCategory!, 'category'));
    }
    if (_selectedCity != null) {
      chips.add(_buildFilterChip('City', _selectedCity!, 'city'));
    }
    if (_selectedCapacityRange != null) {
      chips.add(
        _buildFilterChip('Capacity', _selectedCapacityRange!, 'capacity'),
      );
    }
    if (_selectedAmenities.isNotEmpty) {
      chips.add(
        _buildFilterChip(
          'Amenities',
          _selectedAmenities.join(', '),
          'amenities',
        ),
      );
    }
    if (_selectedSort != null) {
      chips.add(_buildFilterChip('Sort', _selectedSort!, 'sort'));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: chips),
    );
  }

  Widget _buildFilterChip(String label, String value, String filterName) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InputChip(
        label: Text('$label: $value'),
        onDeleted:
            () => setState(() {
              switch (filterName) {
                case 'category':
                  _selectedCategory = null;
                  break;
                case 'city':
                  _selectedCity = null;
                  break;
                case 'capacity':
                  _selectedCapacityRange = null;
                  break;
                case 'amenities':
                  _selectedAmenities.clear();
                  break;
                case 'sort':
                  _selectedSort = null;
                  break;
              }
              _triggerSearch();
            }),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Venues"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search venues by name...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            _buildActiveFilters(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial || state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message));
                  } else if (state is SearchLoaded) {
                    final venues = state.venues;
                    if (venues.isEmpty) {
                      return const Center(child: Text("No venues found."));
                    }
                    return ListView.builder(
                      itemCount: venues.length,
                      itemBuilder: (context, index) {
                        final venue = venues[index];
                        return VenueCard(
                          venue: venue,
                          isFavorite: state.favoriteVenueIds.contains(venue.id),
                          onFavoriteToggle: () {
                            context.read<SearchBloc>().add(
                              ToggleSearchFavoriteEvent(venue.id),
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
                                                  serviceLocator<
                                                      VenueDetailsBloc
                                                    >()
                                                    ..add(
                                                      LoadVenueDetails(
                                                        venue.id,
                                                      ),
                                                    ),
                                        ),
                                      ],
                                      child: VenueDetailsPage(
                                        venueId: venue.id,
                                      ),
                                    ),
                              ),
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
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
