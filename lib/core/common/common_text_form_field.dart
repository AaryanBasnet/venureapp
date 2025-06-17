import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool obsecure;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const CommonTextFormField({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.obsecure = false,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obsecure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: color),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: color),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: color, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
