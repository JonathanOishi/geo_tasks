import 'package:flutter/material.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconWidget,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
    this.keyboardType,
  });

  final String? label;
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixIconWidget;
  final bool obscureText;
  final TextInputType? keyboardType;

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
          keyboardType: keyboardType,
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 18,
            ),
            filled: true,
            fillColor: AppColors.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: Icon(prefixIcon, color: AppColors.textSecondary),
                  ),
            suffixIcon: suffixIcon == null
                ? suffixIconWidget
                : Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Icon(suffixIcon, color: AppColors.textSecondary),
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
