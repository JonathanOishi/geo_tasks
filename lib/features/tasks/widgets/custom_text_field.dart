import 'package:flutter/material.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    this.icon,
    this.controller,
    this.readOnly = false,
    this.onTap,
  });

  final String? label;
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9AA8A3), fontSize: 18),
            filled: true,
            fillColor: AppColors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            suffixIcon: icon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Icon(icon, color: AppColors.textSecondary),
                  ),
            suffixIconConstraints: const BoxConstraints(minWidth: 40),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
