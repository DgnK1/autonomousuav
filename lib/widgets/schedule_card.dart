import 'package:flutter/material.dart';

class ScheduleItem {
  final String time;
  final String task;

  const ScheduleItem(this.time, this.task);
}

class ScheduleCard extends StatelessWidget {
  final List<ScheduleItem> items;

  const ScheduleCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor, // dark: #3B3B3B, light: default
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  'Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: theme.dividerColor),
          const SizedBox(height: 8),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        e.time,
                        style: TextStyle(color: scheme.onSurface),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(
                        e.task,
                        style: TextStyle(color: scheme.onSurface),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
