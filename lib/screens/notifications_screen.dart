import 'package:flutter/material.dart';

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
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// FILTER CHIPS
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

            /// TODAY
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

                  SizedBox(height: 24),

                  /// YESTERDAY
                  Text(
                    "Yesterday",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),

                  SizedBox(height: 16),

                  _NotificationItem(
                    title: "Weekly Skincare Summary is Ready",
                    subtitle: "View your progress and insights",
                    buttonText: "View",
                    isSummary: true,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PRODUCT IMAGE PLACEHOLDER
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

          /// TEXT
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

          /// ACTION BUTTON
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
}
