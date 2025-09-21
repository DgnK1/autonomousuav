import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/schedule_card.dart';
import '../widgets/simple_search_delegate.dart';
import '../widgets/notifications_sheet.dart';

// Default schedule items displayed on the Activity page
const List<ScheduleItem> _defaultSchedule = [
  ScheduleItem('09:00 AM', 'System Initialization'),
  ScheduleItem('09:30 AM', 'Pre-flight Check'),
  ScheduleItem('09:45 AM', 'Mission Planning'),
  ScheduleItem('10:00 AM', 'Takeoff Sequence'),
  ScheduleItem('10:30 AM', 'Navigation Active'),
];

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF2F2F2),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (shared)
            AppHeader(
              title: 'Activity',
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () async {
                    final tasks = _defaultSchedule.map((e) => e.task).toList();
                    final selected = await showSearch<String>(
                      context: context,
                      delegate: SimpleSearchDelegate(data: tasks),
                    );
                    if (selected != null && selected.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: $selected')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () => showNotificationsSheet(context),
                ),
              ],
            ),

            // Page content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Drone Footage',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Animated GIF (unchanged) inside rounded container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/gifs/droneflyby.gif',
                          height: 240,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Schedule card (data-driven)
                      ScheduleCard(items: _defaultSchedule),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
