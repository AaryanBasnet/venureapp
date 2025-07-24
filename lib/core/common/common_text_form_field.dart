import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonTextFormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final TextEditingController controller;
  final bool obsecure;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const CommonTextFormField({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.controller,
    this.obsecure = false,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}