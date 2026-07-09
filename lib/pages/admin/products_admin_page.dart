import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/product.dart';
import '../../models/category.dart';

class ProductsAdminPage extends StatefulWidget {
  const ProductsAdminPage({super.key});

  @override
  State<ProductsAdminPage> createState() => _ProductsAdminPageState();
}

class _ProductsAdminPageState extends State<ProductsAdminPage> {
  final _supabase = SupabaseService();
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final products = await _supabase.getAllProducts();
      final categories = await _supabase.getCategories();
      setState(() {
        _products = products;
        _categories = categories;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  String? _categoryName(int? id) {
    if (id == null) return null;
    return _categories.where((c) => c.id == id).firstOrNull?.name;
  }

  Future<void> _deleteProduct(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Produkt löschen'),
        content: const Text('Dieses Produkt wirklich löschen?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Abbrechen')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Löschen'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white)),
        ],
      ),
    );
    if (confirm == true) {
      await _supabase.deleteProduct(id);
      _loadData();
    }
  }

  void _showEditor({Product? product}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _ProductEditor(product: product, categories: _categories)),
    ).then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produkte verwalten'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showEditor(), tooltip: 'Neues Produkt'),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('Keine Produkte vorhanden'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.restaurant),
                        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${product.formattedPrice} · ${_categoryName(product.categoryId) ?? 'Ohne Kategorie'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _showEditor(product: product)),
                            IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _deleteProduct(product.id)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _ProductEditor extends StatefulWidget {
  final Product? product;
  final List<Category> categories;
  const _ProductEditor({this.product, required this.categories});

  @override
  State<_ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<_ProductEditor> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _slugCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  int? _categoryId;
  bool _isAvailable = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameCtrl.text = widget.product!.name;
      _slugCtrl.text = widget.product!.slug;
      _descCtrl.text = widget.product!.description ?? '';
      _priceCtrl.text = widget.product!.price.toStringAsFixed(2);
      _categoryId = widget.product!.categoryId;
      _isAvailable = widget.product!.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _slugCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final supabase = SupabaseService();
      final data = {
        'name': _nameCtrl.text,
        'slug': _slugCtrl.text,
        'description': _descCtrl.text,
        'price': double.parse(_priceCtrl.text.replaceAll(',', '.')),
        'category_id': _categoryId,
        'is_available': _isAvailable,
      };

      if (widget.product != null) {
        await supabase.updateProduct(widget.product!.id, data);
      } else {
        await supabase.createProduct(data);
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
        title: Text(widget.product != null ? 'Produkt bearbeiten' : 'Neues Produkt'),
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
            TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()), validator: (v) => v?.isEmpty == true ? 'Name erforderlich' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _slugCtrl, decoration: const InputDecoration(labelText: 'Slug (URL)', border: OutlineInputBorder()), validator: (v) => v?.isEmpty == true ? 'Slug erforderlich' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Beschreibung', border: OutlineInputBorder()), maxLines: 3),
            const SizedBox(height: 12),
            TextFormField(controller: _priceCtrl, decoration: const InputDecoration(labelText: 'Preis (€)', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) {
              if (v?.isEmpty == true) return 'Preis erforderlich';
              if (double.tryParse(v!.replaceAll(',', '.')) == null) return 'Ungültiger Preis';
              return null;
            }),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: _categoryId,
              decoration: const InputDecoration(labelText: 'Kategorie', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem(value: null, child: Text('Ohne Kategorie')),
                ...widget.categories.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name))),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
            ),
            const SizedBox(height: 12),
            SwitchListTile(title: const Text('Verfügbar'), value: _isAvailable, onChanged: (v) => setState(() => _isAvailable = v)),
          ],
        ),
      ),
    );
  }
}