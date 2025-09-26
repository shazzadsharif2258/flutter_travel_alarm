import 'package:assesment_flutter/constants/app_colors.dart';
import 'package:assesment_flutter/features/home/models/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AlarmTile extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const AlarmTile({
    super.key,
    required this.alarm,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('h:mm a').format(alarm.time);
    final date = DateFormat('EEE d MMM yyyy').format(alarm.time);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A244B).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(date, style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
          const SizedBox(width: 12),
          Switch(
            value: alarm.enabled,
            onChanged: onToggle,
            activeThumbColor: AppColors.primary,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
