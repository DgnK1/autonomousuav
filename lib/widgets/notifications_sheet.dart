import 'package:flutter/material.dart';

Future<void> showNotificationsSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const _NotificationsSheet(),
  );
}

class _NotificationsSheet extends StatefulWidget {
  const _NotificationsSheet();

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem('Mission initialized', '09:00 AM'),
    _NotificationItem('Pre-flight check passed', '09:30 AM'),
    _NotificationItem('Mission planning complete', '09:45 AM'),
    _NotificationItem('Takeoff successful', '10:00 AM'),
    _NotificationItem('Navigation active', '10:30 AM'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: _notifications.isEmpty
                      ? null
                      : () => setState(_notifications.clear),
                  icon: const Icon(Icons.mark_email_read),
                  label: const Text('Mark all as read'),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: _notifications.isEmpty
                ? const _EmptyNotifications()
                : ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final n = _notifications[index];
                      return Dismissible(
                        key: Key('${n.title}-$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => setState(() {
                          _notifications.removeAt(index);
                        }),
                        child: ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(n.title),
                          subtitle: Text(n.time),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: _notifications.length,
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.mark_email_read, size: 48, color: Colors.green),
            SizedBox(height: 12),
            Text('All caught up!', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String time;
  _NotificationItem(this.title, this.time);
}
