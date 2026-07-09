import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _supabase = SupabaseService();
  int _subscriberCount = 0;
  bool _loading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final user = _supabase.currentUser;
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
      });
      await _loadStats();
    } else {
      setState(() {
        _loading = false;
        _isLoggedIn = false;
      });
    }
  }

  Future<void> _loadStats() async {
    try {
      final count = await _supabase.getActiveSubscriberCount();
      setState(() {
        _subscriberCount = count;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin-Bereich'),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Zugang nur für Administratoren',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Zum Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin-Dashboard'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _supabase.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            tooltip: 'Abmelden',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Willkommen
                  Text(
                    'Hallo, ${_supabase.currentUser?.email ?? 'Admin'}',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Statistiken
                  Text(
                    'Dashboard',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.people,
                          title: 'Abonnenten',
                          value: '$_subscriberCount',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.article,
                          title: 'Funktionen',
                          value: 'CMS + CRM + Shop',
                          color: Colors.green,
                          small: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Admin Menü
                  Text(
                    'Verwaltung',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _AdminMenuItem(
                    icon: Icons.article,
                    title: 'Artikel verwalten (CMS)',
                    subtitle: 'Blog-Artikel erstellen, bearbeiten und löschen',
                    onTap: () {},
                  ),
                  _AdminMenuItem(
                    icon: Icons.restaurant_menu,
                    title: 'Produkte verwalten (Shop)',
                    subtitle: 'Speisekarte und Produkte pflegen',
                    onTap: () {},
                  ),
                  _AdminMenuItem(
                    icon: Icons.people,
                    title: 'Abonnenten (CRM)',
                    subtitle: 'Newsletter-Abonnenten verwalten',
                    onTap: () {},
                  ),
                  _AdminMenuItem(
                    icon: Icons.campaign,
                    title: 'Newsletter versenden',
                    subtitle: 'Kampagnen erstellen und versenden',
                    onTap: () {},
                  ),
                  _AdminMenuItem(
                    icon: Icons.receipt_long,
                    title: 'Bestellungen',
                    subtitle: 'Eingehende Bestellungen anzeigen',
                    onTap: () {},
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool small;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: small ? 14 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}