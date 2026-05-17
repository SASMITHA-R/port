import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/navigation_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../utils/responsive_utils.dart';

class PortfolioNavBar extends StatelessWidget implements PreferredSizeWidget {
  final List<GlobalKey> sectionKeys;
  final ScrollController scrollController;

  const PortfolioNavBar({
    super.key,
    required this.sectionKeys,
    required this.scrollController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  void _scrollToSection(int index) {
    final key = sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<NavigationViewModel>();
    final themeVM = context.watch<ThemeViewModel>();
    final isDark = themeVM.isDark;
    final isMobile = ResponsiveUtils.isMobile(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 64,
          decoration: BoxDecoration(
            color: isDark
                ? AppTheme.darkBg.withValues(alpha: navVM.isScrolled ? 0.85 : 0.5)
                : AppTheme.lightBg.withValues(alpha: navVM.isScrolled ? 0.9 : 0.7),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? AppTheme.darkBorder.withValues(alpha: 0.5)
                    : AppTheme.lightBorder.withValues(alpha: 0.8),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getHorizontalPadding(context),
            ),
            child: Row(
              children: [
                // Logo
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppTheme.accentTeal, AppTheme.accentCoral],
                  ).createShader(bounds),
                  child: Text(
                    'SR.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),

                // Nav items (desktop/tablet only)
                if (!isMobile)
                  Row(
                    children: AppConstants.navItems.asMap().entries.map((e) {
                      final isActive = navVM.activeSection == e.key;
                      return _NavItem(
                        label: e.value,
                        isActive: isActive,
                        onTap: () => _scrollToSection(e.key),
                      );
                    }).toList(),
                  ),

                const SizedBox(width: 16),

                // Theme toggle
                _ThemeToggle(isDark: isDark, onToggle: themeVM.toggleTheme),

                // Mobile menu button
                if (isMobile) ...[
                  const SizedBox(width: 8),
                  _MobileMenuButton(
                    sectionKeys: sectionKeys,
                    onTap: _scrollToSection,
                    activeIndex: navVM.activeSection,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isActive
                ? accent.withValues(alpha: 0.12)
                : _hovered
                    ? accent.withValues(alpha: 0.06)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
              color: widget.isActive
                  ? accent
                  : isDark
                      ? AppTheme.textSecondary
                      : AppTheme.lightTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ThemeToggle({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 56,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: isDark
              ? const LinearGradient(
                  colors: [AppTheme.accentCoral, AppTheme.accentTeal],
                )
              : null,
          color: isDark ? null : AppTheme.lightBorder,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                isDark ? '🌙' : '☀️',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final List<GlobalKey> sectionKeys;
  final Function(int) onTap;
  final int activeIndex;

  const _MobileMenuButton({
    required this.sectionKeys,
    required this.onTap,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.menu_rounded,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surface,
      onSelected: onTap,
      itemBuilder: (_) => AppConstants.navItems.asMap().entries.map((e) {
        return PopupMenuItem<int>(
          value: e.key,
          child: Text(
            e.value,
            style: TextStyle(
              color: activeIndex == e.key
                  ? Theme.of(context).colorScheme.primary
                  : null,
              fontWeight:
                  activeIndex == e.key ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
