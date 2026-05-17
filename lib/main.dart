import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/navigation_viewmodel.dart';
import 'viewmodels/portfolio_viewmodel.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'views/portfolio_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => PortfolioViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (_, themeVM, __) {
          return MaterialApp(
            title: 'Sasmitha R — Flutter Developer',
            debugShowCheckedModeBanner: false,
            themeMode: themeVM.themeMode,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            home: const PortfolioView(),
          );
        },
      ),
    );
  }
}
