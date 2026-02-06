import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();

  final _registerName = TextEditingController();
  final _registerEmail = TextEditingController();
  final _registerPassword = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    _loginEmail.dispose();
    _loginPassword.dispose();

    _registerName.dispose();
    _registerEmail.dispose();
    _registerPassword.dispose();

    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 1));

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> _handleRegister() async {
    if (_registerFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 1));

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFF6FF), // Tailwind blue-50
              Colors.white,
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 80,
                    color: const Color.fromARGB(255, 27, 43, 163),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'SkinSync',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Your intelligent skincare companion',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text(
                              'Welcome',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Sign in to your account or create a new one',
                            ),
                          ),

                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Login'),
                              Tab(text: 'Register'),
                            ],
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            height: 360,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                Form(
                                  key: _loginFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _loginEmail,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                        ),
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Enter email'
                                            : null,
                                      ),

                                      const SizedBox(height: 16),

                                      TextFormField(
                                        controller: _loginPassword,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (v) =>
                                            v == null || v.length < 6
                                            ? 'Password too short'
                                            : null,
                                      ),

                                      const SizedBox(height: 24),

                                      FilledButton(
                                        onPressed: _isLoading
                                            ? null
                                            : _handleLogin,
                                        child: _isLoading
                                            ? const CircularProgressIndicator()
                                            : const Text('Sign In'),
                                      ),
                                    ],
                                  ),
                                ),

                                Form(
                                  key: _registerFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _registerName,
                                        decoration: const InputDecoration(
                                          labelText: 'Full Name',
                                        ),
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Enter name'
                                            : null,
                                      ),

                                      const SizedBox(height: 16),

                                      TextFormField(
                                        controller: _registerEmail,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                        ),
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Enter email'
                                            : null,
                                      ),

                                      const SizedBox(height: 16),

                                      TextFormField(
                                        controller: _registerPassword,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Password',
                                        ),
                                        validator: (v) =>
                                            v == null || v.length < 6
                                            ? 'Password too short'
                                            : null,
                                      ),

                                      const SizedBox(height: 12),

                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'By registering, you agree that your data will be stored securely and used in accordance with GDPR regulations.',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      FilledButton(
                                        onPressed: _isLoading
                                            ? null
                                            : _handleRegister,
                                        child: const Text('Create Account'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
