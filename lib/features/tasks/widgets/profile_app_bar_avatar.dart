import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';

class ProfileAppBarAvatar extends StatelessWidget {
  const ProfileAppBarAvatar({
    super.key,
    required this.imageBase64,
    this.size = 56,
  });

  final String? imageBase64;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageBase64 != null && imageBase64!.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.avatarBorder,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.avatarBackground,
        child: ClipOval(
          child: hasImage
              ? Image.memory(
                  base64Decode(imageBase64!),
                  width: size - 6,
                  height: size - 6,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _fallbackIcon(),
                )
              : _fallbackIcon(),
        ),
      ),
    );
  }

  Widget _fallbackIcon() {
    return const Icon(
      Icons.person,
      color: AppColors.avatarIcon,
    );
  }
}
