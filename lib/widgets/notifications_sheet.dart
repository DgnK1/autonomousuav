import 'package:flutter/material.dart';

Future<void> showNotificationsSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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
                Expanded(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _notifications.isEmpty
                      ? null
                      : () => setState(_notifications.clear),
                  icon: Icon(Icons.mark_email_read, color: scheme.onSurface),
                  label: Text('Mark all as read', style: TextStyle(color: scheme.onSurface)),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: scheme.onSurface),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
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
                          leading: Icon(Icons.notifications, color: scheme.onSurface),
                          title: Text(n.title, style: TextStyle(color: scheme.onSurface)),
                          subtitle: Text(n.time, style: TextStyle(color: scheme.onSurface.withOpacity(0.7))),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => Divider(height: 1, color: theme.dividerColor),
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
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mark_email_read, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            Text('All caught up!', style: TextStyle(fontSize: 16, color: scheme.onSurface)),
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
