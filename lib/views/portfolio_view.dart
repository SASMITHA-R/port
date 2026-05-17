import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/navigation_viewmodel.dart';

import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/home_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';
import 'widgets/footer.dart';
import 'widgets/navbar.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({super.key});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final navVM = context.read<NavigationViewModel>();
    navVM.setScrolled(_scrollController.offset > 50);

    // Determine active section by checking which key is most visible
    int newActive = 0;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null) {
          final pos = box.localToGlobal(Offset.zero);
          if (pos.dy <= 120) {
            newActive = i;
          }
        }
      }
    }
    navVM.setActiveSection(newActive);
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PortfolioNavBar(
        sectionKeys: _sectionKeys,
        scrollController: _scrollController,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              KeyedSubtree(
                key: _sectionKeys[0],
                child: HomeSection(
                  onViewProjects: () => _scrollToSection(3),
                ),
              ),
              KeyedSubtree(
                key: _sectionKeys[1],
                child: const AboutSection(),
              ),
              KeyedSubtree(
                key: _sectionKeys[2],
                child: const SkillsSection(),
              ),
              KeyedSubtree(
                key: _sectionKeys[3],
                child: const ProjectsSection(),
              ),
              KeyedSubtree(
                key: _sectionKeys[4],
                child: const ContactSection(),
              ),
              const PortfolioFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
