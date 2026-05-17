import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../models/skill_model.dart';
import '../models/timeline_model.dart';

class PortfolioViewModel extends ChangeNotifier {
  // ── Projects ──────────────────────────────────────────────────
  final List<ProjectModel> projects = const [
    ProjectModel(
      title: 'BMI Calculator App',
      description: 'Responsive BMI Calculator mobile app built with Flutter. '
          'Features real-time BMI calculation with height & weight inputs, '
          'clean reusable widget architecture, and enhanced UI using Font Awesome Flutter package.',
      techStack: [
        'Flutter',
        'Dart',
        'State Management',
        'Font Awesome',
        'UI/UX'
      ],
      githubUrl: 'https://github.com/SASMITHA-R/BMI',
      liveUrl: null,
      emoji: '⚖️',
      gradientStart: '#2DD4BF',
      gradientEnd: '#34D399',
    ),
    ProjectModel(
      title: 'AI Radio App',
      description:
          'Voice-controlled Radio Streaming app built with Flutter and Alan AI. '
          'AI voice commands to play/stop music and search by category. '
          'Integrated Radio API for live streaming with async API calls and voice assistant workflows.',
      techStack: ['Flutter', 'Dart', 'Alan AI', 'REST API', 'Async/Await'],
      githubUrl: 'https://github.com/SASMITHA-R/airadio',
      liveUrl: null,
      emoji: '🎙️',
      gradientStart: '#FF6B6B',
      gradientEnd: '#FBBF24',
    ),
    ProjectModel(
      title: 'Photo Upload & Gallery App',
      description:
          'Full-featured image upload and gallery app with Flutter and Firebase. '
          'Image picker, Firebase Storage upload, grid gallery display, '
          'preview and download functionality with cloud-based media handling.',
      techStack: ['Flutter', 'Firebase', 'Firestore', 'Storage', 'Dart'],
      githubUrl: 'https://github.com/SASMITHA-R/photo',
      liveUrl: null,
      emoji: '🖼️',
      gradientStart: '#FBBF24',
      gradientEnd: '#FF6B6B',
    ),
  ];

  // ── Skills ────────────────────────────────────────────────────
  final List<SkillModel> skills = const [
    // Mobile
    SkillModel(
        name: 'Flutter / Dart', level: 0.88, category: 'Mobile', emoji: '💙'),
    SkillModel(
        name: 'MVVM / BLoC', level: 0.82, category: 'Mobile', emoji: '🏗️'),
    SkillModel(
        name: 'Firebase (Auth / FCM)',
        level: 0.85,
        category: 'Mobile',
        emoji: '🔥'),
    // Backend & APIs
    SkillModel(
        name: 'REST API / JSON', level: 0.83, category: 'Backend', emoji: '🌐'),
    SkillModel(
        name: 'Java (OOP)', level: 0.72, category: 'Backend', emoji: '☕'),
    SkillModel(
        name: 'SQL', level: 0.70, category: 'Backend', emoji: '🗄️'),
    // Web
    SkillModel(
        name: 'HTML / CSS / JS', level: 0.75, category: 'Web', emoji: '🌍'),
   
    // Tools
  
    SkillModel(
        name: 'Git / GitHub', level: 0.80, category: 'Tools', emoji: '🐙'),
  ];

  // ── Timeline ──────────────────────────────────────────────────
  final List<TimelineItem> timeline = const [
    TimelineItem(
      year: 'Present',
      title: 'Flutter Developer',
      subtitle: 'Building Mobile Apps',
      description:
          'Developing real-world Flutter applications including AI-powered radio streaming, '
          'gallery apps with Firebase, and BMI calculators — focused on clean architecture and great UX.',
      emoji: '🚀',
    ),
    TimelineItem(
      year: '6 Months',
      title: 'Java Fullstack Intern',
      subtitle: 'Tap Academy, Chennai',
      description:
          'Applied Core Java OOP and Collections Framework. Built frontend with HTML, CSS, '
          'JavaScript. Developed a responsive online food delivery web page with '
          'cart and menu features.',
      emoji: '💻',
    ),
    TimelineItem(
      year: '2021–2025',
      title: 'B.E. Electronics & Communication',
      subtitle: 'Anna University Regional Campus, Coimbatore',
      description:
          'Graduated with CGPA 7.9. Coursework in electronics, communication systems, '
          'programming fundamentals, and software engineering.',
      emoji: '🎓',
    ),
  ];
}
