import 'package:assesment_flutter/features/home/pages/alarm_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assesment_flutter/common_widgets/background_color.dart';
import 'package:assesment_flutter/constants/app_colors.dart';
import 'package:assesment_flutter/features/home/contoller/home_controller.dart';
import 'package:assesment_flutter/features/home/pages/pick_time_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController(), permanent: true);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          final when = await Get.to<DateTime>(() => const PickTimePage());
          if (when != null) await c.addDailyAlarm(when);
        },
        child: const Icon(Icons.add),
      ),
      body: BackgroundColor(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              final loc = c.selectedLocation.value;
              final alarms = c.alarms;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // location pill
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.card.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loc ?? 'Add your location',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: c.isAsking.value
                              ? null
                              : c.useCurrentLocation,
                          child: c.isAsking.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Update'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Alarms',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.separated(
                      itemCount: alarms.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final a = alarms[i];
                        return AlarmTile(
                          alarm: a,
                          onDelete: () => c.removeAlarm(a),
                          onToggle: (v) => c.toggleAlarm(a, v),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
