import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';
import 'package:geo_tasks/features/tasks/views/dashboard_page.dart';
import 'package:geo_tasks/features/tasks/views/home_page.dart';
import 'package:geo_tasks/features/tasks/views/profile_page.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(
        onProfileTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
      const DashboardPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 78,
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.65),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.08),
                    blurRadius: 34,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: Icons.task_alt_rounded,
                      label: 'Tasks',
                      isSelected: _currentIndex == 0,
                      onTap: () => _selectTab(0),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      isSelected: _currentIndex == 1,
                      onTap: () => _selectTab(1),
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Profile',
                      isSelected: _currentIndex == 2,
                      onTap: () => _selectTab(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 56,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.95)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSelected ? 25 : 22,
                color: isSelected ? AppColors.onPrimary : AppColors.outline,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.onPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
