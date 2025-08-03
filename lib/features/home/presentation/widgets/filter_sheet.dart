
import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final String? selectedCategory;
  final String? selectedCity;
  final String? selectedCapacity;
  final List<String> selectedAmenities;
  final String? selectedSort;

  const FilterSheet({super.key, 
    this.selectedCategory,
    this.selectedCity,
    this.selectedCapacity,
    required this.selectedAmenities,
    this.selectedSort,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
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
