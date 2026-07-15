import 'package:supabase_flutter/supabase_flutter.dart';
import '../env/supabase_key.dart' as env;
import '../models/article.dart';
import '../models/product.dart';
import '../models/category.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // ============================================================
  // Initialisierung
  // ============================================================
  Future<void> initialize() async {
    await Supabase.initialize(
      url: env.url,
      anonKey: env.anonKey,
    );
  }

  // ============================================================
  // Auth
  // ============================================================
  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;
  Stream<AuthState> get authState => client.auth.onAuthStateChange;

  bool get isAdmin {
    final user = currentUser;
    if (user == null) return false;
    return user.email == 'fran@pepe-et-urinal.de'; // Vereinfachte Admin-Prüfung
  }

  // ============================================================
  // Articles (CMS)
  // ============================================================
  Future<List<Article>> getPublishedArticles() async {
    final response = await client
        .from('articles')
        .select()
        .eq('status', 'published')
        .order('published_at', ascending: false);
    return (response as List).map((json) => Article.fromJson(json)).toList();
  }

  Future<List<Article>> getAllArticles() async {
    final response = await client
        .from('articles')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((json) => Article.fromJson(json)).toList();
  }

  Future<Article> getArticleBySlug(String slug) async {
    final response = await client
        .from('articles')
        .select()
        .eq('slug', slug)
        .single();
    return Article.fromJson(response);
  }

  Future<void> createArticle(Map<String, dynamic> data) async {
    await client.from('articles').insert(data);
  }

  Future<void> updateArticle(int id, Map<String, dynamic> data) async {
    await client.from('articles').update(data).eq('id', id);
  }

  Future<void> deleteArticle(int id) async {
    await client.from('articles').delete().eq('id', id);
  }

  // ============================================================
  // Products (Shop)
  // ============================================================
  Future<List<Product>> getAvailableProducts() async {
    final response = await client
        .from('products')
        .select()
        .eq('is_available', true)
        .order('sort_order', ascending: true);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> getAllProducts() async {
    final response = await client
        .from('products')
        .select()
        .order('sort_order', ascending: true);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response = await client
        .from('products')
        .select()
        .eq('category_id', categoryId)
        .eq('is_available', true)
        .order('sort_order', ascending: true);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> getProductBySlug(String slug) async {
    final response = await client
        .from('products')
        .select()
        .eq('slug', slug)
        .single();
    return Product.fromJson(response);
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    await client.from('products').insert(data);
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    await client.from('products').update(data).eq('id', id);
  }

  Future<void> deleteProduct(int id) async {
    await client.from('products').delete().eq('id', id);
  }

  // ============================================================
  // Categories
  // ============================================================
  Future<List<Category>> getCategories() async {
    final response = await client
        .from('categories')
        .select()
        .order('sort_order', ascending: true);
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  // ============================================================
  // Subscribers (CRM)
  // ============================================================
  Future<void> addSubscriber(String email, {String? name}) async {
    await client.from('subscribers').insert({
      'email': email,
      'name': name,
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> getSubscribers() async {
    final response = await client
        .from('subscribers')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<int> getActiveSubscriberCount() async {
    final response = await client
        .from('subscribers')
        .select('id')
        .eq('status', 'active');
    return (response as List).length;
  }

  Future<void> deleteSubscriber(int id) async {
    await client.from('subscribers').delete().eq('id', id);
  }

  // ============================================================
  // Orders
  // ============================================================
  Future<void> createOrder(Map<String, dynamic> orderData, List<Map<String, dynamic>> items) async {
    await client.rpc('create_order', params: {
      'p_order_data': orderData,
      'p_items': items,
    });
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await client
        .from('orders')
        .select('*, order_items(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateOrderStatus(int id, String status) async {
    await client.from('orders').update({'status': status}).eq('id', id);
  }

  // ============================================================
  // Newsletter Campaigns
  // ============================================================
  Future<void> createCampaign(Map<String, dynamic> data) async {
    await client.from('newsletter_campaigns').insert(data);
  }

  Future<List<Map<String, dynamic>>> getCampaigns() async {
    final response = await client
        .from('newsletter_campaigns')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}