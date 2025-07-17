import 'package:flutter/material.dart';

class AddonsPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialAddons;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;

  const AddonsPage({
    Key? key,
    required this.initialAddons,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  State<AddonsPage> createState() => _AddonsPageState();
}

class _AddonsPageState extends State<AddonsPage> {
  late List<Map<String, dynamic>> _selectedAddons;

  final List<Map<String, dynamic>> _availableAddons = [
    {'id': '1', 'name': 'Catering', 'price': 5000, 'perPerson': true},
    {'id': '2', 'name': 'Decoration', 'price': 3000, 'perPerson': false},
    {'id': '3', 'name': 'DJ', 'price': 2000, 'perPerson': false},
  ];

  @override
  void initState() {
    super.initState();
    _selectedAddons = List<Map<String, dynamic>>.from(widget.initialAddons);
  }

  void _toggleAddon(Map<String, dynamic> addon, bool selected) {
    setState(() {
      if (selected) {
        _selectedAddons.add(addon);
      } else {
        _selectedAddons.removeWhere((a) => a['id'] == addon['id']);
      }
    });
  }

  void _next() {
    widget.onNext({'selectedAddons': _selectedAddons});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Select Add-ons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView(
            children: _availableAddons.map((addon) {
              final isSelected = _selectedAddons.any((a) => a['id'] == addon['id']);
              return CheckboxListTile(
                title: Text('${addon['name']} - Nrs.${addon['price']}${addon['perPerson'] ? " per person" : ""}'),
                value: isSelected,
                onChanged: (val) => _toggleAddon(addon, val ?? false),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: widget.onBack, child: const Text('Back')),
            ElevatedButton(onPressed: _next, child: const Text('Next')),
          ],
        ),
      ],
    );
  }
}
