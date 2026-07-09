import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _supabase = SupabaseService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _isLogin = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        await _supabase.signIn(_emailController.text.trim(), _passwordController.text);
      } else {
        await _supabase.signUp(_emailController.text.trim(), _passwordController.text);
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Anmelden' : 'Registrieren'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 64, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    _isLogin ? 'Willkommen zurück!' : 'Neues Konto erstellen',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_error!, style: const TextStyle(color: Colors.red)),
                    ),

                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-Mail',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Passwort',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _loading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(_isLogin ? 'Anmelden' : 'Registrieren', style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(_isLogin
                        ? 'Noch kein Konto? Registrieren'
                        : 'Bereits registriert? Anmelden'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}