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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text(
                  'Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  'Task',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text(e.time)),
                    Expanded(flex: 7, child: Text(e.task)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
