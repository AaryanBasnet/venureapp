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
          (_) => _FilterSheet(
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

class _FilterSheet extends StatefulWidget {
  final String? selectedCategory;
  final String? selectedCity;
  final String? selectedCapacity;
  final List<String> selectedAmenities;
  final String? selectedSort;

  const _FilterSheet({
    this.selectedCategory,
    this.selectedCity,
    this.selectedCapacity,
    required this.selectedAmenities,
    this.selectedSort,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _category;
  late String? _city;
  late String? _capacity;
  late List<String> _amenities;
  late String? _sort;

  final List<String> categories = ['All', 'Birthday', 'Wedding', 'Business'];
  final List<String> cities = ['All', 'Kathmandu', 'Lalitpur', 'Bhaktapur'];
  final List<String> capacities = ['All', '0-50', '51-100', '100+'];
  final List<String> amenitiesOptions = ['WiFi', 'Parking', 'Projector', 'AC'];
  final List<String> sortOptions = [
    'Relevance',
    'Price Low to High',
    'Price High to Low',
    'Rating',
  ];

  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory ?? 'All';
    _city = widget.selectedCity ?? 'All';
    _capacity = widget.selectedCapacity ?? 'All';
    _amenities = List.from(widget.selectedAmenities);
    _sort = widget.selectedSort ?? 'Relevance';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildChoiceChips(
                "Category",
                categories,
                _category,
                (val) => setState(() => _category = val),
              ),
              _buildChoiceChips(
                "City",
                cities,
                _city,
                (val) => setState(() => _city = val),
              ),
              _buildChoiceChips(
                "Capacity",
                capacities,
                _capacity,
                (val) => setState(() => _capacity = val),
              ),
              _buildFilterChips("Amenities", amenitiesOptions, _amenities),
              _buildChoiceChips(
                "Sort",
                sortOptions,
                _sort,
                (val) => setState(() => _sort = val),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed:
                        () => Navigator.pop(context, {
                          'category': null,
                          'city': null,
                          'capacity': null,
                          'amenities': [],
                          'sort': null,
                        }),
                    child: const Text("Clear"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'category': _category == 'All' ? null : _category,
                        'city': _city == 'All' ? null : _city,
                        'capacity': _capacity == 'All' ? null : _capacity,
                        'amenities': _amenities,
                        'sort': _sort,
                      });
                    },
                    child: const Text("Apply"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChips(
    String title,
    List<String> options,
    String? selected,
    Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children:
              options
                  .map(
                    (e) => ChoiceChip(
                      label: Text(e),
                      selected: selected == e,
                      onSelected: (_) => onSelected(e),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildFilterChips(
    String title,
    List<String> options,
    List<String> selectedList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children:
              options
                  .map(
                    (e) => FilterChip(
                      label: Text(e),
                      selected: selectedList.contains(e),
                      onSelected: (_) {
                        setState(() {
                          if (selectedList.contains(e)) {
                            selectedList.remove(e);
                          } else {
                            selectedList.add(e);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
