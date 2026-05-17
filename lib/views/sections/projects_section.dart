import 'dart:ui';
import 'package:vector_math/vector_math_64.dart' as vmath;


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/project_model.dart';
import '../../services/url_service.dart';
import '../../utils/responsive_utils.dart';
import '../../viewmodels/portfolio_viewmodel.dart';
import '../widgets/animated_section.dart';
import '../widgets/section_header.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<PortfolioViewModel>();
    final hPad = ResponsiveUtils.getHorizontalPadding(context);
    final cols = ResponsiveUtils.getProjectGridCols(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 100, hPad, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            sectionKey: 'projects_header',
            child: const SectionHeader(
              tag: '// PROJECTS',
              title: "Things I've Built",
              subtitle: 'Real-world apps and dashboards I\'m proud of.',
            ),
          ),
          const SizedBox(height: 60),
          _ProjectsGrid(projects: vm.projects, cols: cols, isDark: isDark),
        ],
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  final List<ProjectModel> projects;
  final int cols;
  final bool isDark;

  const _ProjectsGrid({
    required this.projects,
    required this.cols,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: projects.asMap().entries.map((e) {
        final width = _cardWidth(context, cols);
        return SizedBox(
          width: width,
          child: AnimatedSection(
            sectionKey: 'project_${e.key}',
            delay: Duration(milliseconds: e.key * 120),
            child: _ProjectCard(project: e.value, isDark: isDark),
          ),
        );
      }).toList(),
    );
  }

  double _cardWidth(BuildContext context, int cols) {
    final width = MediaQuery.of(context).size.width;
    final hPad = ResponsiveUtils.getHorizontalPadding(context) * 2;
    return (width - hPad - (cols - 1) * 24) / cols;
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final bool isDark;

  const _ProjectCard({required this.project, required this.isDark});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  Color _parseHex(String hex) {
    hex = hex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final c1 = _parseHex(widget.project.gradientStart);
    final c2 = _parseHex(widget.project.gradientEnd);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translateByVector3(
              vmath.Vector3(0.0, _hovered ? -8.0 : 0.0, 0.0),
            ),


        transformAlignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: c1.withValues(alpha: 0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    )
                  ]
                : [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: widget.isDark ? 0.3 : 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.85),
                  border: Border.all(
                    color: widget.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : AppTheme.lightBorder,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gradient banner
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [c1, c2]),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    c1.withValues(alpha: 0.2),
                                    c2.withValues(alpha: 0.2)
                                  ]),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: c1.withValues(alpha: 0.3)),
                                ),
                                child: Center(
                                  child: Text(widget.project.emoji,
                                      style: const TextStyle(fontSize: 22)),
                                ),
                              ),
                              const Spacer(),
                              // BI Dashboard badge
                              if (widget.project.isBiDashboard)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: c1.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: c1.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    'BI Dashboard',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10,
                                      color: c1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if (widget.project.liveUrl != null)
                                _IconBtn(
                                  icon: Icons.open_in_new_rounded,
                                  onTap: () => UrlService.openUrl(
                                      widget.project.liveUrl!),
                                  color: c1,
                                ),
                              if (widget.project.githubUrl != null)
                                _IconBtn(
                                  icon: Icons.code_rounded,
                                  onTap: () => UrlService.openUrl(
                                      widget.project.githubUrl!),
                                  color: c2,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.project.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.project.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(height: 1.7, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: widget.project.techStack
                                .map((t) => _TechChip(
                                    label: t, color: c1, isDark: widget.isDark))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              if (widget.project.githubUrl != null)
                                _LinkButton(
                                  label: 'GitHub',
                                  icon: Icons.code,
                                  color: c1,
                                  onTap: () => UrlService.openUrl(
                                      widget.project.githubUrl!),
                                ),
                              if (widget.project.liveUrl != null) ...[
                                const SizedBox(width: 12),
                                _LinkButton(
                                  label: 'Live Demo',
                                  icon: Icons.open_in_new,
                                  color: c2,
                                  onTap: () => UrlService.openUrl(
                                      widget.project.liveUrl!),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _IconBtn(
      {required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _TechChip(
      {required this.label, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _LinkButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _LinkButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withValues(alpha: 0.15)
                : widget.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.color.withValues(alpha: _hovered ? 0.5 : 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 14, color: widget.color),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
