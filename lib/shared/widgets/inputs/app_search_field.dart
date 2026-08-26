import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.hintText,
    super.key,
    this.controller,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
