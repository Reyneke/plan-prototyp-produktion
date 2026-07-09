import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class SubscribersAdminPage extends StatefulWidget {
  const SubscribersAdminPage({super.key});

  @override
  State<SubscribersAdminPage> createState() => _SubscribersAdminPageState();
}

class _SubscribersAdminPageState extends State<SubscribersAdminPage> {
  final _supabase = SupabaseService();
  List<Map<String, dynamic>> _subscribers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSubscribers();
  }

  Future<void> _loadSubscribers() async {
    setState(() => _loading = true);
    try {
      final subscribers = await _supabase.getSubscribers();
      setState(() {
        _subscribers = subscribers;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteSubscriber(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abonnent löschen'),
        content: const Text('Diesen Abonnenten wirklich entfernen?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Abbrechen')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Löschen'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white)),
        ],
      ),
    );
    if (confirm == true) {
      await _supabase.deleteSubscriber(id);
      _loadSubscribers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abonnenten verwalten'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _subscribers.isEmpty
              ? const Center(child: Text('Keine Abonnenten vorhanden'))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: theme.colorScheme.primaryContainer,
                      child: Row(
                        children: [
                          const Icon(Icons.people),
                          const SizedBox(width: 8),
                          Text('${_subscribers.length} Abonnenten insgesamt', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _subscribers.length,
                        itemBuilder: (context, index) {
                          final sub = _subscribers[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: sub['status'] == 'active' ? Colors.green : Colors.orange,
                                child: Text((sub['email'] as String)[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                              ),
                              title: Text(sub['email']),
                              subtitle: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: sub['status'] == 'active' ? Colors.green.shade100 : Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(sub['status'] ?? 'unknown', style: const TextStyle(fontSize: 11)),
                                  ),
                                  if (sub['name'] != null) ...[
                                    const SizedBox(width: 8),
                                    Text(sub['name'], style: const TextStyle(fontSize: 12)),
                                  ],
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteSubscriber(sub['id']),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}