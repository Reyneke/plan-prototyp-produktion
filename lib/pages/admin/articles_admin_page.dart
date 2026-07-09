import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/article.dart';

class ArticlesAdminPage extends StatefulWidget {
  const ArticlesAdminPage({super.key});

  @override
  State<ArticlesAdminPage> createState() => _ArticlesAdminPageState();
}

class _ArticlesAdminPageState extends State<ArticlesAdminPage> {
  final _supabase = SupabaseService();
  List<Article> _articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _loading = true);
    try {
      final articles = await _supabase.getAllArticles();
      setState(() {
        _articles = articles;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteArticle(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Artikel löschen'),
        content: const Text('Diesen Artikel wirklich löschen?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Abbrechen')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Löschen'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white)),
        ],
      ),
    );
    if (confirm == true) {
      await _supabase.deleteArticle(id);
      _loadArticles();
    }
  }

  void _showEditor({Article? article}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _ArticleEditor(article: article)),
    ).then((_) => _loadArticles());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel verwalten'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEditor(),
            tooltip: 'Neuer Artikel',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _articles.isEmpty
              ? const Center(child: Text('Keine Artikel vorhanden'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    final article = _articles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: article.featuredImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(article.featuredImage!, width: 50, height: 50, fit: BoxFit.cover))
                            : const Icon(Icons.article),
                        title: Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: article.status == 'published' ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(article.status == 'published' ? 'Veröffentlicht' : 'Entwurf', style: const TextStyle(fontSize: 11)),
                            ),
                            const SizedBox(width: 8),
                            Text(article.createdAt.toString().substring(0, 10), style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _showEditor(article: article)),
                            IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _deleteArticle(article.id)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _ArticleEditor extends StatefulWidget {
  final Article? article;
  const _ArticleEditor({this.article});

  @override
  State<_ArticleEditor> createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<_ArticleEditor> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _slugCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _excerptCtrl = TextEditingController();
  bool _isPublished = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _titleCtrl.text = widget.article!.title;
      _slugCtrl.text = widget.article!.slug;
      _contentCtrl.text = widget.article!.content;
      _excerptCtrl.text = widget.article!.excerpt ?? '';
      _isPublished = widget.article!.status == 'published';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _slugCtrl.dispose();
    _contentCtrl.dispose();
    _excerptCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final supabase = SupabaseService();
      final data = {
        'title': _titleCtrl.text,
        'slug': _slugCtrl.text,
        'content': _contentCtrl.text,
        'excerpt': _excerptCtrl.text,
        'status': _isPublished ? 'published' : 'draft',
        'published_at': _isPublished ? DateTime.now().toIso8601String() : null,
        'author_id': supabase.currentUser!.id,
      };

      if (widget.article != null) {
        await supabase.updateArticle(widget.article!.id, data);
      } else {
        await supabase.createArticle(data);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article != null ? 'Artikel bearbeiten' : 'Neuer Artikel'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Speichern', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Titel', border: OutlineInputBorder()),
              validator: (v) => v?.isEmpty == true ? 'Titel erforderlich' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _slugCtrl,
              decoration: const InputDecoration(labelText: 'Slug (URL)', border: OutlineInputBorder()),
              validator: (v) => v?.isEmpty == true ? 'Slug erforderlich' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _excerptCtrl,
              decoration: const InputDecoration(labelText: 'Kurzbeschreibung', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contentCtrl,
              decoration: const InputDecoration(labelText: 'Inhalt (HTML)', border: OutlineInputBorder()),
              maxLines: 10,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Veröffentlicht'),
              value: _isPublished,
              onChanged: (v) => setState(() => _isPublished = v),
            ),
          ],
        ),
      ),
    );
  }
}