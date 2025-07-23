
import 'package:flutter/material.dart';

class PremiumDropdown extends StatelessWidget {
  const PremiumDropdown({
    super.key,
    required Color textDark,
    required Color primaryRed,
    required Color mediumGray,
    required Color lightGray,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.validator,
    required this.icon,
  }) : _textDark = textDark, _primaryRed = primaryRed, _mediumGray = mediumGray, _lightGray = lightGray;

  final Color _textDark;
  final Color _primaryRed;
  final Color _mediumGray;
  final Color _lightGray;
  final String label;
  final String? value;
  final List<String> items;
  final Function(String? p1) onChanged;
  final String? Function(String? p1) validator;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            prefixIcon:
                icon != null
                    ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(icon, color: _primaryRed, size: 20),
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _mediumGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _mediumGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryRed, width: 2),
            ),
            filled: true,
            fillColor: _lightGray,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: _textDark,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          value: value,
          onChanged: onChanged,
          validator: validator,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
