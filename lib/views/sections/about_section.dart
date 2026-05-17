import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';
import '../../models/timeline_model.dart';
import '../../viewmodels/portfolio_viewmodel.dart';
import '../widgets/animated_section.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<PortfolioViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveUtils.isMobile(context);
    final hPad = ResponsiveUtils.getHorizontalPadding(context);

    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 100, hPad, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            sectionKey: 'about_header',
            child: const SectionHeader(
              tag: '// ABOUT ME',
              title: 'Building Beautiful\nMobile Experiences',
              subtitle:
                  'Flutter apps, Firebase integrations, and beautiful mobile experiences.',
            ),
          ),
          const SizedBox(height: 60),
          if (isMobile)
            _buildMobileLayout(context, vm, isDark)
          else
            _buildDesktopLayout(context, vm, isDark),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
      BuildContext context, PortfolioViewModel vm, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: AnimatedSection(
            sectionKey: 'about_bio',
            child: _BioCard(isDark: isDark),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 7,
          child: AnimatedSection(
            sectionKey: 'about_timeline',
            delay: const Duration(milliseconds: 200),
            child: _Timeline(items: vm.timeline, isDark: isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, PortfolioViewModel vm, bool isDark) {
    return Column(
      children: [
        AnimatedSection(
          sectionKey: 'about_bio_m',
          child: _BioCard(isDark: isDark),
        ),
        const SizedBox(height: 32),
        AnimatedSection(
          sectionKey: 'about_timeline_m',
          delay: const Duration(milliseconds: 200),
          child: _Timeline(items: vm.timeline, isDark: isDark),
        ),
      ],
    );
  }
}

class _BioCard extends StatelessWidget {
  final bool isDark;

  const _BioCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.accentTeal, AppTheme.accentCoral],
              ),
            ),
            child: const Center(
              child: Text('👨‍💻', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sasmitha R',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Flutter Developer · Chennai, India',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentTeal,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'Passionate Flutter Developer building responsive, feature-rich '
            'mobile applications with clean MVVM/BLoC architecture and Firebase backend. '
            'I enjoy turning ideas into polished apps — from voice-controlled AI radio '
            'to cloud-powered gallery apps.\n\n'
            'Currently exploring advanced Flutter patterns while expanding skills '
            'in Firebase integrations and REST API workflows.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.8,
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              '📍 Chennai, TN',
              '🌐 Open to Remote',
              '📱 Flutter Dev',
              '🔥 Firebase',
            ].map((t) => _Chip(label: t)).toList(),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isDark ? AppTheme.darkBorder.withValues(alpha: 0.5) : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 12),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<TimelineItem> items;
  final bool isDark;

  const _Timeline({required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((e) {
        return AnimatedSection(
          sectionKey: 'timeline_${e.key}',
          delay: Duration(milliseconds: e.key * 120),
          child: _TimelineCard(
              item: e.value, isDark: isDark, isLast: e.key == items.length - 1),
        );
      }).toList(),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final TimelineItem item;
  final bool isDark;
  final bool isLast;

  const _TimelineCard({
    required this.item,
    required this.isDark,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    // Avoid IntrinsicHeight + Expanded in a vertical Column; this combination
    // can cause bottom overflows on tight constraints (e.g., web).
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.15),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 1.5,
                  height: 28,
                  margin: const EdgeInsets.only(top: 4),
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.year,
                      style: TextStyle(
                        fontSize: 11,
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: accent, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 13, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
