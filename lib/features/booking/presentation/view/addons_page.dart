import 'package:flutter/material.dart';

const Color _primaryRed = Color(0xFFE74C3C);
const Color _textDark = Color(0xFF333333);
const Color _lightGray = Color(0xFFF8F8F8);
const Color _mediumGray = Color(0xFFE0E0E0);

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
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Select Add-ons',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _availableAddons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final addon = _availableAddons[index];
                final isSelected = _selectedAddons.any(
                  (a) => a['id'] == addon['id'],
                );
                return Container(
                  decoration: BoxDecoration(
                    color: _lightGray,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _mediumGray, width: 1.2),
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: (val) => _toggleAddon(addon, val ?? false),
                    activeColor: _primaryRed,
                    title: Text(
                      addon['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    subtitle: Text(
                      'Nrs. ${addon['price']} ${addon['perPerson'] ? "per person" : ""}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primaryRed),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: _primaryRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
