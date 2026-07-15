import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/article.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _supabase = SupabaseService();
  List<Article> _articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      final articles = await _supabase.getPublishedArticles();
      setState(() {
        _articles = articles;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzeria Pepe et Urinal'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/shop'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/login'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ========================================
            // Hero Section
            // ========================================
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_pizza, size: 80, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Pizzeria Pepe et Urinal',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Berlin-Spandau •Ab 4,50 €',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            // ========================================
            // Services / Über uns
            // ========================================
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ServiceCard(
                          icon: Icons.local_pizza,
                          title: 'Frische Pizza',
                          description: 'Handgemacht mit besten Zutaten',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ServiceCard(
                          icon: Icons.timer,
                          title: 'Schnell & Günstig',
                          description: 'Abholung in 15 Minuten',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ServiceCard(
                          icon: Icons.euro_symbol,
                          title: 'Beste Preise',
                          description: 'Pizza schon ab 4,50 €',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ServiceCard(
                          icon: Icons.location_on,
                          title: 'In Spandau',
                          description: 'Falkenseer Chaussee 127',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ========================================
            // News Feed (dynamisch aus Supabase)
            // ========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Neuigkeiten',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_articles.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Noch keine Neuigkeiten – bald gibt\'s News!',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...List.generate(_articles.length, (index) {
                final article = _articles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  child: ListTile(
                    leading: article.featuredImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              article.featuredImage!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.article, size: 40),
                    title: Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      article.excerpt ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/article', arguments: article.slug),
                  ),
                );
              }),

            const SizedBox(height: 24),

            // ========================================
            // Newsletter-Anmeldung
            // ========================================
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Newsletter abonnieren',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Erhalte aktuelle Angebote und Neuigkeiten per E-Mail.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Deine E-Mail-Adresse',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Anmelden'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ========================================
            // Footer mit rechtlichen Links
            // ========================================
            Container(
              width: double.infinity,
              color: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                children: [
                  const Icon(Icons.local_pizza, size: 40, color: Colors.white54),
                  const SizedBox(height: 12),
                  const Text(
                    'Pizzeria Pepe et Urinal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Falkenseer Chaussee 127, 13589 Berlin',
                    style: TextStyle(fontSize: 14, color: Colors.white54),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tel: 030 / 12345678',
                    style: TextStyle(fontSize: 14, color: Colors.white54),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/imprint'),
                        child: const Text('Impressum', style: TextStyle(color: Colors.white70)),
                      ),
                      const Text('|', style: TextStyle(color: Colors.white30)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/privacy'),
                        child: const Text('Datenschutz', style: TextStyle(color: Colors.white70)),
                      ),
                      const Text('|', style: TextStyle(color: Colors.white30)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/terms'),
                        child: const Text('AGB', style: TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '© 2026 Fran Jatzek',
                    style: TextStyle(fontSize: 12, color: Colors.white38),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}