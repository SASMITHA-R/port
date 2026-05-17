import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/resume_service.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/animated_particles.dart';
import '../widgets/gradient_button.dart';

class HomeSection extends StatefulWidget {
  final VoidCallback onViewProjects;

  const HomeSection({super.key, required this.onViewProjects});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final heroFontSize = ResponsiveUtils.getHeroFontSize(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    final hPad = ResponsiveUtils.getHorizontalPadding(context);

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.5, -0.3),
                radius: 1.2,
                colors: isDark
                    ? [
                        AppTheme.accentCoral.withValues(alpha: 0.15),
                        AppTheme.darkBg,
                        AppTheme.darkBg,
                      ]
                    : [
                        AppTheme.accentTeal.withValues(alpha: 0.08),
                        AppTheme.lightBg,
                      ],
              ),
            ),
          ),

          // Second gradient orb
          Positioned(
            right: -100,
            bottom: 0,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentTeal.withValues(alpha: isDark ? 0.08 : 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Particles
          const Positioned.fill(child: AnimatedParticles()),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 100, hPad, 80),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Greeting pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppTheme.accentTeal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppTheme.accentTeal.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Available for opportunities',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              color: AppTheme.accentTeal,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Main heading
                    Text(
                      "Hi, I'm",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: heroFontSize * 0.6,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppTheme.textSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          AppTheme.accentTeal,
                          AppTheme.accentCoral,
                          AppTheme.accentAmber,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        AppConstants.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: heroFontSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Typing animation
                    Row(
                      children: [
                        Text(
                          '< ',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: isMobile ? 18 : 24,
                            color: AppTheme.accentCoral,
                          ),
                        ),
                        AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Flutter Developer',
                              textStyle: GoogleFonts.jetBrainsMono(
                                fontSize: isMobile ? 18 : 24,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary,
                              ),
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Mobile App Developer',
                              textStyle: GoogleFonts.jetBrainsMono(
                                fontSize: isMobile ? 18 : 24,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary,
                              ),
                              speed: const Duration(milliseconds: 80),
                            ),
                            TypewriterAnimatedText(
                              'Firebase Expert',
                              textStyle: GoogleFonts.jetBrainsMono(
                                fontSize: isMobile ? 18 : 24,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary,
                              ),
                              speed: const Duration(milliseconds: 80),
                            ),
                          ],
                        ),
                        Text(
                          ' />',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: isMobile ? 18 : 24,
                            color: AppTheme.accentCoral,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bio
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Text(
                        AppConstants.bioShort,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: isMobile ? 15 : 17,
                              height: 1.8,
                            ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // CTAs
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        GradientButton(
                          label: 'View Projects',
                          icon: Icons.rocket_launch_rounded,
                          onPressed: widget.onViewProjects,
                        ),
                        GradientButton(
                          label: 'Download Resume',
                          icon: Icons.download_rounded,
                          outlined: true,
                          gradientColors: [
                            AppTheme.accentTeal,
                            AppTheme.accentCoral
                          ],
                          onPressed: () => ResumeService.downloadResume(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),

                    // Stats
                    if (!isMobile) _buildStats(context, isDark),
                  ],
                ),
              ),
            ),
          ),

          // Scroll indicator
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: const _ScrollIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, bool isDark) {
    final stats = [
      ('2+', 'Years Coding'),
      ('4+', 'Apps Built'),
      ('3', 'Tech Stacks'),
    ];
    return Row(
      children: stats.map((s) {
        return Container(
          margin: const EdgeInsets.only(right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [AppTheme.accentTeal, AppTheme.accentCoral],
                ).createShader(b),
                child: Text(
                  s.$1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                s.$2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ScrollIndicator extends StatefulWidget {
  const _ScrollIndicator();

  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Opacity(
          opacity: 0.4 + _anim.value * 0.6,
          child: Transform.translate(
            offset: Offset(0, _anim.value * 6),
            child: Column(
              children: [
                Text(
                  'scroll',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
