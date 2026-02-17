import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ---------------------------------------------------------------------------
// 1. MAIN SHELL (Handles Tab Navigation)
// ---------------------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Define your screens here
  final List<Widget> _screens = [
    const HomeDashboard(), // Tab 0: Home
    const PlaceholderScreen(title: "Inventory"), // Tab 1: Inventory
    const NotificationsScreen(), // Tab 2: Notifications
    const SettingsScreen(), // Tab 3: Settings
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color assistantCardColor = const Color(0xFF5B2C5F);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: assistantCardColor,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. HOME DASHBOARD (Your Main Content)
// ---------------------------------------------------------------------------

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFF5F7FA);
    final Color cardColor = Colors.white;
    final Color assistantCardColor = const Color(0xFF5B2C5F);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Nazifa',
                style: GoogleFonts.caprasimo(
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Scanner Buttons ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ScannerCard(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Barcode Scan',
                      iconColor: const Color(0xFF0057D9),
                      backgroundColor: cardColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ScannerCard(
                      icon: Icons.search_rounded,
                      label: 'Ingredient Scan',
                      iconColor: const Color(0xFF9C27B0),
                      backgroundColor: cardColor,
                    ),
                  ),
                ],
              ),
            ),

            // --- Skincare Stats ---
            SectionHeader(title: 'Your Skincare', onSeeAll: () {}),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const StatItem(count: '20', label: 'Products'),
                  _buildDivider(),
                  const StatItem(count: '5', label: 'Favourites'),
                  _buildDivider(),
                  const StatItem(count: '10', label: 'Key Benefits'),
                ],
              ),
            ),

            // --- Reminders ---
            const SizedBox(height: 10),
            SectionHeader(title: 'Reminders', onSeeAll: () {}),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: const [
                  Expanded(
                    child: ReminderCard(
                      count: '7',
                      label: 'Expiring Soon',
                      icon: Icons.access_time_filled_rounded,
                      accentColor: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ReminderCard(
                      count: '5',
                      label: 'To Repurchase',
                      icon: Icons.shopping_bag_rounded,
                      accentColor: Color(0xFF0057D9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Ingredient Assistant ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    assistantCardColor,
                    assistantCardColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: assistantCardColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'AI Assistant',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Can I use Vitamin C with Niacinamide?',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: assistantCardColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Ask Skintellect',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- TEST BUTTON (You can remove this later) ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  print("🟢 Attempting connection...");
                  try {
                    await FirebaseFirestore.instance
                        .collection('test_connection')
                        .add({
                          'timestamp': DateTime.now(),
                          'message': 'Hello from SkinSync Web!',
                        });
                    print("✅ SUCCESS: Database connected!");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ Connection Successful!"),
                        ),
                      );
                    }
                  } catch (e) {
                    print("❌ ERROR: $e");
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
                    }
                  }
                },
                child: const Text(
                  "TEST DATABASE CONNECTION",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.2));
  }
}

// ---------------------------------------------------------------------------
// 3. SETTINGS SCREEN (Fixed and Integrated)
// ---------------------------------------------------------------------------

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserSettingsService _settingsService = UserSettingsService();
  bool _isLoading = true;

  bool _lowStockAlert = true;
  bool _nearExpiryAlert = true;
  bool _expiredAlert = true;
  double _lowStockThreshold = 10.0;
  double _expiryDateThreshold = 7.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final settings = await _settingsService.getUserSettings();
    if (mounted) {
      setState(() {
        _lowStockAlert = settings['lowStockAlert'] ?? true;
        _nearExpiryAlert = settings['nearExpiryAlert'] ?? true;
        _expiredAlert = settings['expiredAlert'] ?? true;
        _lowStockThreshold = (settings['lowStockThreshold'] ?? 10).toDouble();
        _expiryDateThreshold = (settings['expiryDateThreshold'] ?? 7)
            .toDouble();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    setState(() {
      if (key == 'lowStockAlert') _lowStockAlert = value;
      if (key == 'nearExpiryAlert') _nearExpiryAlert = value;
      if (key == 'expiredAlert') _expiredAlert = value;
      if (key == 'lowStockThreshold') _lowStockThreshold = value;
      if (key == 'expiryDateThreshold') _expiryDateThreshold = value;
    });

    try {
      await _settingsService.updateSetting(key, value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to save: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF5B2C5F);
    final Color backgroundColor = const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: GoogleFonts.caprasimo(color: primaryColor, fontSize: 24),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(primaryColor),
                  const SizedBox(height: 24),
                  _buildSectionHeader("Notifications"),
                  Container(
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          "Low Stock Alerts",
                          "Get notified when stock is low",
                          _lowStockAlert,
                          (val) => _updateSetting('lowStockAlert', val),
                          primaryColor,
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          "Near Expiry Alerts",
                          "Get notified before items expire",
                          _nearExpiryAlert,
                          (val) => _updateSetting('nearExpiryAlert', val),
                          primaryColor,
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          "Expiration Alerts",
                          "Get notified on expiration day",
                          _expiredAlert,
                          (val) => _updateSetting('expiredAlert', val),
                          primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader("Thresholds"),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        _buildSliderGroup(
                          "Low Stock Threshold",
                          "Alert below quantity:",
                          _lowStockThreshold,
                          1,
                          20,
                          "items",
                          (val) => _updateSetting('lowStockThreshold', val),
                          primaryColor,
                        ),
                        const SizedBox(height: 24),
                        _buildSliderGroup(
                          "Expiry Warning",
                          "Alert days before:",
                          _expiryDateThreshold,
                          1,
                          30,
                          "days",
                          (val) => _updateSetting('expiryDateThreshold', val),
                          primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // --- UI Helpers for Settings ---
  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12, left: 4),
    child: Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
      ),
    ),
  );
  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
  Widget _buildDivider() =>
      Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1));

  Widget _buildProfileCard(Color primary) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "Guest Mode";
    final name = user?.displayName ?? "User";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: primary, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                email,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    Color activeColor,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildSliderGroup(
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    String unit,
    Function(double) onChanged,
    Color primary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${value.round()} $unit",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4. USER SETTINGS SERVICE (Database Logic)
// ---------------------------------------------------------------------------

class UserSettingsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get _userPath => 'users/${_auth.currentUser?.uid}';

  Future<Map<String, dynamic>> getUserSettings() async {
    try {
      if (_auth.currentUser == null) return _getDefaultSettings();
      DocumentSnapshot userDoc = await _firestore.doc(_userPath).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('settings') && userData['settings'] is List) {
          List<dynamic> list = userData['settings'];
          if (list.isNotEmpty) return Map<String, dynamic>.from(list[0]);
        }
      }
      await _initializeDefaultSettings();
      return _getDefaultSettings();
    } catch (e) {
      return _getDefaultSettings();
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    if (_auth.currentUser == null) return;
    DocumentReference docRef = _firestore.doc(_userPath);
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) {
      await _initializeDefaultSettings();
      doc = await docRef.get();
    }

    final data = doc.data() as Map<String, dynamic>;
    List<dynamic> settingsList =
        (data.containsKey('settings') && data['settings'] is List)
        ? List.from(data['settings'])
        : [_getDefaultSettings()];

    Map<String, dynamic> currentSettings = Map<String, dynamic>.from(
      settingsList[0],
    );
    currentSettings[key] = value;
    settingsList[0] = currentSettings;

    await docRef.update({
      'settings': settingsList,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _initializeDefaultSettings() async {
    await _firestore.doc(_userPath).set({
      'settings': [_getDefaultSettings()],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Map<String, dynamic> _getDefaultSettings() => {
    'lowStockAlert': true,
    'nearExpiryAlert': true,
    'expiredAlert': true,
    'lowStockThreshold': 10,
    'expiryDateThreshold': 7,
  };
}

// ---------------------------------------------------------------------------
// 5. NOTIFICATIONS SCREEN & HELPERS
// ---------------------------------------------------------------------------

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  static const primary = Color(0xFF5B2C5F);
  static const background = Color(0xFFF7F4F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: const [
                _FilterChip(label: "Expiring Soon", selected: true),
                SizedBox(width: 8),
                _FilterChip(label: "Repurchase"),
                SizedBox(width: 8),
                _FilterChip(label: "Summary"),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Today",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  _NotificationItem(
                    title: "Deep Vita C Pads is Expiring",
                    subtitle: "Action Recommended in 5 days",
                    buttonText: "Notify Me",
                  ),
                  _NotificationItem(
                    title: "Deep Vita C Pads is Expiring",
                    subtitle: "Action Recommended in 5 days",
                    buttonText: "Notify Me",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        "$title Screen",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const SectionHeader({super.key, required this.title, required this.onSeeAll});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2D3436),
        ),
      ),
      TextButton(
        onPressed: onSeeAll,
        child: Text(
          'See All',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0057D9),
          ),
        ),
      ),
    ],
  );
}

class ScannerCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color backgroundColor;
  const ScannerCard({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
  });
  @override
  Widget build(BuildContext context) => Container(
    height: 110,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

class StatItem extends StatelessWidget {
  final String count;
  final String label;
  const StatItem({super.key, required this.count, required this.label});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        count,
        style: GoogleFonts.interTight(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF2D3436),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey[500],
        ),
      ),
    ],
  );
}

class ReminderCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color accentColor;
  const ReminderCard({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    required this.accentColor,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: accentColor),
            ),
            Text(
              count,
              style: GoogleFonts.interTight(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: selected ? NotificationsScreen.primary : Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: selected ? Colors.white : Colors.black87,
      ),
    ),
  );
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final bool isSummary;
  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.isSummary = false,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF1ECF3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            size: 26,
            color: Color(0xFF5B2C5F),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSummary
                ? const Color(0xFFF1ECF3)
                : const Color(0xFFEBD6EC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: NotificationsScreen.primary,
            ),
          ),
        ),
      ],
    ),
  );
}
