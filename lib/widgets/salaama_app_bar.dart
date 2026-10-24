import 'package:flutter/material.dart';

class SalaamaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

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
      title: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          padding: const EdgeInsets.all(2),
          child: ClipOval(
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(Icons.school, color: backgroundColor, size: 20)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis)),
      ]),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

// Dashboard AppBar with Role Color
class SalaamaDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String role;
  final Color backgroundColor;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const SalaamaDashboardAppBar({
    super.key,
    required this.role,
    this.backgroundColor = const Color(0xFF0D47A1),
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return SalaamaAppBar(title: "$role Dashboard", backgroundColor: backgroundColor, actions: actions, bottom: bottom);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
