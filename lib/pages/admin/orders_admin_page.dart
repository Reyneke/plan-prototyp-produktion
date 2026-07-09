import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class OrdersAdminPage extends StatefulWidget {
  const OrdersAdminPage({super.key});

  @override
  State<OrdersAdminPage> createState() => _OrdersAdminPageState();
}

class _OrdersAdminPageState extends State<OrdersAdminPage> {
  final _supabase = SupabaseService();
  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _loading = true);
    try {
      final orders = await _supabase.getOrders();
      setState(() {
        _orders = orders;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateStatus(int id, String status) async {
    await _supabase.updateOrderStatus(id, status);
    _loadOrders();
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending': return 'Ausstehend';
      case 'confirmed': return 'Bestätigt';
      case 'preparing': return 'In Zubereitung';
      case 'ready': return 'Bereit zur Abholung';
      case 'completed': return 'Abgeschlossen';
      case 'cancelled': return 'Storniert';
      default: return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'preparing': return Colors.purple;
      case 'ready': return Colors.green;
      case 'completed': return Colors.grey;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bestellungen'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('Keine Bestellungen vorhanden'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    final items = order['order_items'] as List? ?? [];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: _statusColor(order['status'] ?? 'pending'),
                          child: Text('#${order['id']}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        title: Text(order['customer_name'] ?? 'Unbekannt', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order['customer_email'] ?? ''),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _statusColor(order['status'] ?? 'pending').withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(_statusLabel(order['status'] ?? 'pending'), style: TextStyle(fontSize: 11, color: _statusColor(order['status'] ?? 'pending'))),
                                ),
                                const SizedBox(width: 8),
                                Text('${order['total_amount']?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        children: [
                          if (items.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Bestellte Artikel:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            ...items.map((item) => ListTile(
                              dense: true,
                              title: Text(item['product_name'] ?? ''),
                              trailing: Text('${item['quantity']} × ${item['unit_price']?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'} €'),
                            )),
                          ],
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatusButton(label: 'Bestätigen', status: 'confirmed', color: Colors.blue, orderId: order['id'], currentStatus: order['status']),
                                _StatusButton(label: 'Zubereitung', status: 'preparing', color: Colors.purple, orderId: order['id'], currentStatus: order['status']),
                                _StatusButton(label: 'Bereit', status: 'ready', color: Colors.green, orderId: order['id'], currentStatus: order['status']),
                                _StatusButton(label: 'Stornieren', status: 'cancelled', color: Colors.red, orderId: order['id'], currentStatus: order['status']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final String status;
  final Color color;
  final int orderId;
  final String currentStatus;

  const _StatusButton({required this.label, required this.status, required this.color, required this.orderId, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final isActive = currentStatus == status;
    return TextButton(
      onPressed: isActive ? null : () {
        final supabase = SupabaseService();
        supabase.updateOrderStatus(orderId, status).then((_) {
          if (context.mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrdersAdminPage()));
          }
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: isActive ? color : color.withOpacity(0.5),
        backgroundColor: isActive ? color.withOpacity(0.1) : null,
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}