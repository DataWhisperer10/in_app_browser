import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../services/connectivity_service.dart';
import '../providers/browser_provider.dart';
import 'browser_screen.dart';
import 'files_screen.dart';
import 'tabs_screen.dart';
import 'settings_screen.dart';

/// Home screen with bottom navigation
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavigationTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityState = ref.watch(connectivityStateProvider);
    final isOffline = connectivityState.whenOrNull(
          data: (state) => state == ConnectivityState.offline,
        ) ??
        false;

    return Scaffold(
      body: Stack(
        children: [
          // Page content
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const BrowserScreen(),
              const FilesScreen(),
              TabsScreen(onTabSelected: _onNavigationTap),
              const SettingsScreen(),
            ],
          ),
          // Offline banner
          if (isOffline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _OfflineBanner(),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(color: AppColors.borderDark, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.public,
                label: 'Browse',
                isSelected: _currentIndex == 0,
                onTap: () => _onNavigationTap(0),
              ),
              _NavItem(
                icon: Icons.folder_open,
                label: 'Files',
                isSelected: _currentIndex == 1,
                onTap: () => _onNavigationTap(1),
              ),
              _NavItem(
                icon: Icons.layers,
                label: 'Tabs',
                isSelected: _currentIndex == 2,
                onTap: () => _onNavigationTap(2),
                badge: ref.watch(browserProvider).tabs.length,
              ),
              _NavItem(
                icon: Icons.settings,
                label: 'Settings',
                isSelected: _currentIndex == 3,
                onTap: () => _onNavigationTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isSelected ? AppColors.primary : AppColors.textTertiaryDark,
                  ),
                ),
                if (badge != null && badge! > 1)
                  Positioned(
                    right: 4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textTertiaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: AppColors.warning,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 16,
              color: AppColors.backgroundDark,
            ),
            const SizedBox(width: 8),
            Text(
              'You are offline. Showing cached content.',
              style: TextStyle(
                color: AppColors.backgroundDark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: -1, duration: 300.ms),
    );
  }
}
