import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];
  static const String _storageKey = 'cart';

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;

  // ============================================================
  // Operationen
  // ============================================================
  void addItem(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    _save();
  }

  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      _save();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _save();
  }

  void clear() {
    _items.clear();
    _save();
  }

  // ============================================================
  // Persistenz (LocalStorage)
  // ============================================================
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _items.clear();
      _items.addAll(decoded.map((json) => CartItem.fromJson(json)));
    }
  }
}