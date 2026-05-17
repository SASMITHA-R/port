import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/skill_model.dart';
import '../../utils/responsive_utils.dart';
import '../../viewmodels/portfolio_viewmodel.dart';
import '../widgets/animated_section.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<PortfolioViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hPad = ResponsiveUtils.getHorizontalPadding(context);
    final cols = ResponsiveUtils.getSkillsGridCols(context);

    final categories = <String, List<SkillModel>>{};
    for (final s in vm.skills) {
      categories.putIfAbsent(s.category, () => []).add(s);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 100, hPad, 100),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.darkSurface.withValues(alpha: 0.5),
                  AppTheme.darkBg,
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightCard.withValues(alpha: 0.5),
                  AppTheme.lightBg,
                ],
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            sectionKey: 'skills_header',
            child: const SectionHeader(
              tag: '// SKILLS',
              title: 'Tools & Technologies',
              subtitle: 'The stack I build and analyse with daily.',
            ),
          ),
          const SizedBox(height: 60),
          AnimatedSection(
            sectionKey: 'skills_grid',
            delay: const Duration(milliseconds: 200),
            child:
                _SkillsGrid(categories: categories, cols: cols, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  final Map<String, List<SkillModel>> categories;
  final int cols;
  final bool isDark;

  const _SkillsGrid({
    required this.categories,
    required this.cols,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final entries = categories.entries.toList();
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: entries.asMap().entries.map((e) {
        final colWidth = _calcColWidth(context, cols);
        return SizedBox(
          width: colWidth,
          child: AnimatedSection(
            sectionKey: 'skill_cat_${e.key}',
            delay: Duration(milliseconds: e.key * 100),
            child: _CategoryCard(
              category: e.value.key,
              skills: e.value.value,
              isDark: isDark,
            ),
          ),
        );
      }).toList(),
    );
  }

  double _calcColWidth(BuildContext context, int cols) {
    final width = MediaQuery.of(context).size.width;
    final hPad = ResponsiveUtils.getHorizontalPadding(context) * 2;
    final spacing = (cols - 1) * 24.0;
    return (width - hPad - spacing) / cols;
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final List<SkillModel> skills;
  final bool isDark;

  const _CategoryCard({
    required this.category,
    required this.skills,
    required this.isDark,
  });

  static const _categoryEmojis = {
    'Mobile': '📱',
    'Backend': '⚙️',
    'Web': '🌍',
    'Tools': '🛠️',
    'Data & BI': '📊',
    'Automation': '⚡',
  };

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _categoryEmojis[category] ?? '💡',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 10),
              Text(
                category,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...skills.map((s) => _SkillBar(skill: s, isDark: isDark)),
        ],
      ),
    );
  }
}

class _SkillBar extends StatefulWidget {
  final SkillModel skill;
  final bool isDark;

  const _SkillBar({required this.skill, required this.isDark});

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _visible = true);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.skill.emoji,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Text(
                    widget.skill.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
              Text(
                '${(widget.skill.level * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accent,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: widget.isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              borderRadius: BorderRadius.circular(3),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      _visible ? _animation.value * widget.skill.level : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, AppTheme.accentCoral],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
