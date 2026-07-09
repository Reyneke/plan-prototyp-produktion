import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/article.dart';

class ArticleDetailPage extends StatefulWidget {
  final String slug;

  const ArticleDetailPage({super.key, required this.slug});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final _supabase = SupabaseService();
  Article? _article;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadArticle();
  }

  Future<void> _loadArticle() async {
    try {
      final article = await _supabase.getArticleBySlug(widget.slug);
      setState(() {
        _article = article;
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
        title: Text(_article?.title ?? 'Artikel'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _article == null
              ? const Center(child: Text('Artikel nicht gefunden'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_article!.featuredImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _article!.featuredImage!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (_article!.featuredImage != null) const SizedBox(height: 24),
                      Text(
                        _article!.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Veröffentlicht am ${_article!.publishedAt != null ? '${_article!.publishedAt!.day}.${_article!.publishedAt!.month}.${_article!.publishedAt!.year}' : '???'}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Divider(height: 32),
                      Text(
                        _article!.content,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
    );
  }
}