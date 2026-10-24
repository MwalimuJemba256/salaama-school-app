import 'package:flutter/material.dart';

class SalaamaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const SalaamaAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.bottom,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // Logo - if you don't have logo yet, it shows Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Icon(Icons.school, color: backgroundColor),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        ],
      ),
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      bottom: bottom,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

class SalaamaDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String role;
  final Color backgroundColor;
  final List<Widget>? actions;

  const SalaamaDashboardAppBar({
    super.key,
    required this.role,
    required this.backgroundColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Icon(Icons.school, color: backgroundColor),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text("$role - Salaama", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
