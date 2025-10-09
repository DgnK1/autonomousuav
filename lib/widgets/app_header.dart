import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;

  const AppHeader({
    super.key,
    required this.title,
    this.actions,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? Colors.white : Colors.black;
    final fg = isLight ? Colors.black : Colors.white;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000), // subtle outer glow
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: IconTheme(
        data: IconThemeData(color: fg),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            ..._buildActions(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (actions != null && actions!.isNotEmpty) {
      return actions!;
    }
    // Default actions if none are provided
    return const [
      Icon(Icons.notifications),
      SizedBox(width: 12),
      Icon(Icons.account_circle),
    ];
  }
}
