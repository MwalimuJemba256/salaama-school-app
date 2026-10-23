import 'package:flutter/material.dart';

class SalaamaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  final Widget? bottom;

  const SalaamaAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFF0D47A1),
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      elevation: 2,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if logo not found - Show Salaama Icon
                  return Container(
                    color: Colors.white,
                    child: const Icon(Icons.school, color: Color(0xFF0D47A1), size: 24),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SALAAMA MUSLIM",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white, letterSpacing: 0.5),
                ),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.w600, letterSpacing: 0.8),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: actions,
      bottom: bottom != null ? PreferredSize(preferredSize: const Size.fromHeight(48), child: bottom!) : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom != null ? 104 : 56);
}

// Second version - With Full School Name for Dashboard
class SalaamaDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String role;
  final Color backgroundColor;
  final List<Widget>? actions;

  const SalaamaDashboardAppBar({
    super.key,
    required this.role,
    this.backgroundColor = const Color(0xFF0D47A1),
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.school, color: Color(0xFF0D47A1), size: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SALAAMA $role",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                const Text(
                  "SALAAMA MUSLIM JUNIOR SCHOOL",
                  style: TextStyle(fontSize: 8, color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                Text(
                  "DESTINED TO SUCCEED",
                  style: TextStyle(fontSize: 7, color: Colors.amber.shade200, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
