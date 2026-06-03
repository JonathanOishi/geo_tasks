import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.imageBytes,
    this.imageBase64,
    this.onEditTap,
    this.radius = 58,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? imageBase64;
  final VoidCallback? onEditTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final outerSize = radius * 2;
    final innerSize = radius * 1.72;
    final imageSize = radius * 1.32;

    return SizedBox(
      width: outerSize + 30,
      height: outerSize + 30,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: outerSize,
            height: outerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1AA79A).withValues(alpha: 0.22),
            ),
          ),
          Container(
            width: innerSize,
            height: innerSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF355E5E),
            ),
          ),
          Container(
            width: imageSize,
            height: imageSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE6EEEE),
            ),
            child: ClipOval(
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                    )
                  : imageBase64 != null && imageBase64!.trim().isNotEmpty
                  ? Image.memory(
                      base64Decode(imageBase64!),
                      fit: BoxFit.cover,
                    )
                  : imageUrl != null && imageUrl!.trim().isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.person,
                        size: 44,
                        color: Color(0xFF0B7267),
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 44,
                      color: Color(0xFF0B7267),
                    ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 8,
            child: Material(
              color: const Color(0xFF0B7267),
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onEditTap,
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
