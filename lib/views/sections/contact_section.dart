import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/url_service.dart';
import '../../services/resume_service.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/animated_section.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/section_header.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveUtils.isMobile(context);
    final hPad = ResponsiveUtils.getHorizontalPadding(context);

    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 100, hPad, 100),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.darkBg,
                  AppTheme.accentCoral.withValues(alpha: 0.05),
                  AppTheme.darkBg,
                ],
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            sectionKey: 'contact_header',
            child: const SectionHeader(
              tag: '// CONTACT',
              title: "Let's Work Together",
              subtitle:
                  "Have a project or opportunity? I'd love to hear from you.",
            ),
          ),
          const SizedBox(height: 60),
          if (isMobile)
            _buildMobileLayout(context, isDark)
          else
            _buildDesktopLayout(context, isDark),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: AnimatedSection(
            sectionKey: 'contact_info',
            child: _ContactInfo(isDark: isDark),
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 6,
          child: AnimatedSection(
            sectionKey: 'contact_form',
            delay: const Duration(milliseconds: 200),
            child: _ContactForm(
              nameController: _nameController,
              emailController: _emailController,
              messageController: _messageController,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return Column(
      children: [
        AnimatedSection(
          sectionKey: 'contact_info_m',
          child: _ContactInfo(isDark: isDark),
        ),
        const SizedBox(height: 32),
        AnimatedSection(
          sectionKey: 'contact_form_m',
          delay: const Duration(milliseconds: 200),
          child: _ContactForm(
            nameController: _nameController,
            emailController: _emailController,
            messageController: _messageController,
          ),
        ),
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final bool isDark;

  const _ContactInfo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I'm always open to discussing new projects, freelance work, or full-time opportunities.",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8),
        ),
        const SizedBox(height: 32),
        _ContactLink(
          icon: Icons.email_outlined,
          label: 'Email',
          value: AppConstants.email,
          color: AppTheme.accentTeal,
          onTap: () => UrlService.sendEmail(
            AppConstants.email,
            subject: "Hey Sasmitha! Let's connect",
          ),
        ),
        const SizedBox(height: 12),
        _ContactLink(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: AppConstants.phone,
          color: AppTheme.accentGreen,
          onTap: () => UrlService.openUrl('tel:${AppConstants.phone}'),
        ),
        const SizedBox(height: 12),
        _ContactLink(
          icon: Icons.work_outline_rounded,
          label: 'LinkedIn',
          value: 'linkedin.com/in/sasmitha-r-3aa062228',
          color: const Color(0xFF0A66C2),
          onTap: () => UrlService.openUrl(AppConstants.linkedin),
        ),
        const SizedBox(height: 12),
        _ContactLink(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: 'github.com/sasmitha',
          color: isDark ? Colors.white70 : Colors.black87,
          onTap: () => UrlService.openUrl(AppConstants.github),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            GradientButton(
              label: 'Send Email',
              icon: Icons.send_rounded,
              onPressed: () => UrlService.sendEmail(AppConstants.email),
            ),
            GradientButton(
              label: 'Download CV',
              icon: Icons.download_rounded,
              outlined: true,
              gradientColors: [AppTheme.accentTeal, AppTheme.accentCoral],
              onPressed: () => ResumeService.downloadResume(),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _ContactLink({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ContactLink> createState() => _ContactLinkState();
}

class _ContactLinkState extends State<_ContactLink> {
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                _hovered ? widget.color.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _hovered ? widget.color.withValues(alpha: 0.3) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: widget.color.withValues(alpha: 0.2)),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: widget.color,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              if (_hovered)
                Icon(Icons.arrow_forward_rounded,
                    size: 16, color: widget.color),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;

  const _ContactForm({
    required this.nameController,
    required this.emailController,
    required this.messageController,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send a Message',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: _FormField(
                      controller: nameController,
                      label: 'Name',
                      hint: 'Your name')),
              const SizedBox(width: 16),
              Expanded(
                  child: _FormField(
                      controller: emailController,
                      label: 'Email',
                      hint: 'your@email.com')),
            ],
          ),
          _FormField(
            controller: messageController,
            label: 'Message',
            hint: 'Tell me about your project...',
            maxLines: 5,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: 'Send Message',
              icon: Icons.send_rounded,
              onPressed: () {
                final subject = 'Message from ${nameController.text}';
                final body =
                    '${messageController.text}\n\nFrom: ${nameController.text}\nEmail: ${emailController.text}';
                UrlService.sendEmail(AppConstants.email,
                    subject: subject, body: body);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            color:
                isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
              fontSize: 14,
            ),
            filled: true,
            fillColor: isDark
                ? AppTheme.darkBorder.withValues(alpha: 0.3)
                : AppTheme.lightCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
