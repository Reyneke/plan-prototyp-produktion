import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class NewsletterAdminPage extends StatefulWidget {
  const NewsletterAdminPage({super.key});

  @override
  State<NewsletterAdminPage> createState() => _NewsletterAdminPageState();
}

class _NewsletterAdminPageState extends State<NewsletterAdminPage> {
  final _supabase = SupabaseService();
  List<Map<String, dynamic>> _campaigns = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    setState(() => _loading = true);
    try {
      final campaigns = await _supabase.getCampaigns();
      setState(() {
        _campaigns = campaigns;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _showComposer() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _NewsletterComposer())).then((_) => _loadCampaigns());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newsletter'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showComposer, tooltip: 'Neuer Newsletter'),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _campaigns.isEmpty
              ? const Center(child: Text('Noch keine Newsletter-Kampagnen'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = _campaigns[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.campaign),
                        title: Text(campaign['subject'] ?? 'Ohne Betreff', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          campaign['sent_at'] != null
                              ? 'Gesendet am ${campaign['sent_at'].toString().substring(0, 10)} · ${campaign['recipient_count'] ?? 0} Empfänger'
                              : 'Noch nicht gesendet',
                        ),
                        trailing: campaign['sent_at'] == null ? const Icon(Icons.schedule, color: Colors.orange) : const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    );
                  },
                ),
    );
  }
}

class _NewsletterComposer extends StatefulWidget {
  const _NewsletterComposer();

  @override
  State<_NewsletterComposer> createState() => _NewsletterComposerState();
}

class _NewsletterComposerState extends State<_NewsletterComposer> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final supabase = SupabaseService();
      final subscriberCount = await supabase.getActiveSubscriberCount();

      await supabase.createCampaign({
        'subject': _subjectCtrl.text,
        'content': _contentCtrl.text,
        'sent_at': DateTime.now().toIso8601String(),
        'recipient_count': subscriberCount,
        'created_by': supabase.currentUser!.id,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Newsletter wird an $subscriberCount Abonnenten gesendet! (Demo – Brevo-Integration folgt)')),
        );
        Navigator.pop(context);
      }
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
        title: const Text('Newsletter verfassen'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _send,
            child: _saving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Senden', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _subjectCtrl, decoration: const InputDecoration(labelText: 'Betreff', border: OutlineInputBorder()), validator: (v) => v?.isEmpty == true ? 'Betreff erforderlich' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _contentCtrl, decoration: const InputDecoration(labelText: 'Inhalt (HTML)', border: OutlineInputBorder()), maxLines: 15, validator: (v) => v?.isEmpty == true ? 'Inhalt erforderlich' : null),
          ],
        ),
      ),
    );
  }
}