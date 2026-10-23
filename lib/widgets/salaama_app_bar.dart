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
      title: Text(title),
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

// Old name - keep for compatibility so dashboard doesn't break
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
      title: Text("$role - Salaama"),
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
