import 'package:assesment_flutter/features/home/models/alarm.dart';
import 'package:assesment_flutter/helpers/location_helper.dart';
import 'package:assesment_flutter/helpers/notifications_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class HomeController extends GetxController {
  final storage = GetStorage();
  final selectedLocation = RxnString();
  final alarms = <Alarm>[].obs;
  final isAsking = false.obs;

  static const _kAlarms = 'alarms';
  static const _kCounter = 'alarm_id_counter';
  static const _kLocation = 'location';

  @override
  void onInit() {
    super.onInit();
    selectedLocation.value = storage.read<String>(_kLocation);
    _loadSaved();
    _rescheduleEnabledAlarms();
  }

  Future<void> useCurrentLocation() async {
    try {
      isAsking.value = true;
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location off', 'Turn on Location Services');
        return;
      }

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied) {
        Get.snackbar('Permission denied', 'Location access is required');
        return;
      }
      if (perm == LocationPermission.deniedForever) {
        Get.snackbar('Permission blocked', 'Enable permission in Settings');
        await Geolocator.openAppSettings();
        return;
      }
      final readable = await LocationHelper.getReadable();
      selectedLocation.value = readable;
      storage.write(_kLocation, readable);

      Get.snackbar('Location set', 'Using your current location');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isAsking.value = false;
    }
  }

  int _nextId() {
    final current = storage.read<int>(_kCounter) ?? 1000;
    final next = current + 1;
    storage.write(_kCounter, next);
    return next;
  }

  Future<void> addDailyAlarm(DateTime time, {String? label}) async {
    final id = _nextId();
    final alarm = Alarm(
      id: id,
      time: time,
      enabled: true,
      repeat: Repeat.daily,
      label: label,
    );
    alarms.add(alarm);

    await NotificationHelper.instance.scheduleDaily(
      id: id,
      when: time,
      title: 'Alarm',
      body: selectedLocation.value == null
          ? 'Your scheduled alarm'
          : 'Location: ${selectedLocation.value}',
    );
    _save();
  }

  Future<void> addOneShotAlarm(DateTime at, {String? label}) async {
    final id = _nextId();
    final alarm = Alarm(
      id: id,
      time: at,
      enabled: true,
      repeat: Repeat.none,
      label: label,
    );
    alarms.add(alarm);

    await NotificationHelper.instance.scheduleOneShot(
      id: id,
      at: at,
      title: 'Alarm',
      body: label ?? 'Your scheduled alarm',
    );
    _save();
  }

  Future<void> toggleAlarm(Alarm alarm, bool enable) async {
    final idx = alarms.indexWhere((a) => a.id == alarm.id);
    if (idx == -1) return;

    alarms[idx] = alarm.copyWith(enabled: enable);

    if (enable) {
      if (alarm.repeat == Repeat.daily) {
        await NotificationHelper.instance.scheduleDaily(
          id: alarm.id,
          when: alarm.time,
        );
      } else {
        final next = alarm.time.isAfter(DateTime.now())
            ? alarm.time
            : DateTime.now().add(const Duration(minutes: 1));
        await NotificationHelper.instance.scheduleOneShot(
          id: alarm.id,
          at: next,
        );
      }
    } else {
      await NotificationHelper.instance.cancel(alarm.id);
    }
    _save();
  }

  Future<void> removeAlarm(Alarm alarm) async {
    alarms.removeWhere((a) => a.id == alarm.id);
    await NotificationHelper.instance.cancel(alarm.id);
    _save();
  }

  void _save() {
    storage.write(_kAlarms, alarms.map((a) => a.toJson()).toList());
  }

  void _loadSaved() {
    final list = storage.read<List>(_kAlarms) ?? [];
    alarms.assignAll(
      list.map((e) => Alarm.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  Future<void> _rescheduleEnabledAlarms() async {
    for (final a in alarms.where((x) => x.enabled)) {
      if (a.repeat == Repeat.daily) {
        await NotificationHelper.instance.scheduleDaily(id: a.id, when: a.time);
      } else if (a.time.isAfter(DateTime.now())) {
        await NotificationHelper.instance.scheduleOneShot(id: a.id, at: a.time);
      }
    }
  }
}
