import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
import 'pages/public/home_page.dart';
import 'pages/public/shop_page.dart';
import 'pages/public/article_detail_page.dart';
import 'pages/public/login_page.dart';
import 'pages/public/imprint_page.dart';
import 'pages/public/privacy_page.dart';
import 'pages/public/terms_page.dart';
import 'pages/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService().initialize();
  runApp(const PepeEtUrinalApp());
}

class PepeEtUrinalApp extends StatelessWidget {
  const PepeEtUrinalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzeria Pepe et Urinal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F), // Rot – klassische Pizzeria-Farbe
          primary: const Color(0xFFD32F2F),
          secondary: const Color(0xFFFFC107),
          surface: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/shop':
            return MaterialPageRoute(builder: (_) => const ShopPage());
          case '/article':
            final slug = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ArticleDetailPage(slug: slug),
            );
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/admin':
            return MaterialPageRoute(builder: (_) => const AdminDashboard());
          case '/imprint':
            return MaterialPageRoute(builder: (_) => const ImprintPage());
          case '/privacy':
            return MaterialPageRoute(builder: (_) => const PrivacyPage());
          case '/terms':
            return MaterialPageRoute(builder: (_) => const TermsPage());
          default:
            return MaterialPageRoute(builder: (_) => const HomePage());
        }
      },
    );
  }
}
