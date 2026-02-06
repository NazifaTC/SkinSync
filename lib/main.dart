import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/ai_assistant_screen.dart';

void main() {
  runApp(const SkinSyncApp());
}

class SkinSyncApp extends StatelessWidget {
  const SkinSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color starBlue = Color(0xFF2563EB);

    return MaterialApp(
      title: 'SkinSync',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 27, 43, 163),
          brightness: Brightness.light,
        ),
        useMaterial3: true,

        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),

        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 27, 43, 163)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 27, 43, 163)),
          ),
          labelStyle: TextStyle(color: Color.fromARGB(255, 27, 43, 163)),
          prefixIconColor: Color.fromARGB(255, 27, 43, 163),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(backgroundColor: starBlue),
        ),
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const AuthScreen(),
        //'/home': (context) => const HomeScreen(),
        //'/scanner': (context) => const ScannerScreen(),
        //'/inventory': (context) => const InventoryScreen(),
        //'/ai-assistant': (context) => const AIAssistantScreen(),
      },
    );
  }
}

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
            colors: [Color(0xFFE3F2FD), Colors.white],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 60,
                    color: Color(0xFF2563EB),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'SkinSync',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Your intelligent skincare companion',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 32),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

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
