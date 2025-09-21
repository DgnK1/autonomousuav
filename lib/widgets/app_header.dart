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
    return Container(
      padding: padding,
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          ..._buildActions(),
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    if (actions != null && actions!.isNotEmpty) {
      return actions!;
    }
    // Default actions if none are provided
    return const [
      Icon(Icons.notifications, color: Colors.white),
      SizedBox(width: 12),
      Icon(Icons.account_circle, color: Colors.white),
    ];
  }
}
