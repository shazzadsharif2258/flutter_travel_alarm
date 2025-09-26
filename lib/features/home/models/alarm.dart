enum Repeat { none, daily }

class Alarm {
  final int id; 
  final DateTime
  time; 
  final bool enabled;
  final Repeat repeat;
  final String? label;

  Alarm({
    required this.id,
    required this.time,
    required this.enabled,
    this.repeat = Repeat.daily,
    this.label,
  });

  Alarm copyWith({
    int? id,
    DateTime? time,
    bool? enabled,
    Repeat? repeat,
    String? label,
  }) => Alarm(
    id: id ?? this.id,
    time: time ?? this.time,
    enabled: enabled ?? this.enabled,
    repeat: repeat ?? this.repeat,
    label: label ?? this.label,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time.toIso8601String(),
    'enabled': enabled,
    'repeat': repeat.name,
    'label': label,
  };

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
    id: json['id'] as int,
    time: DateTime.parse(json['time'] as String),
    enabled: json['enabled'] as bool,
    repeat: Repeat.values.firstWhere(
      (e) => e.name == (json['repeat'] as String? ?? 'daily'),
      orElse: () => Repeat.daily,
    ),
    label: json['label'] as String?,
  );

  DateTime nextFireFrom(DateTime now) {
    if (repeat == Repeat.none) return time;
    final candidate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return candidate.isAfter(now)
        ? candidate
        : candidate.add(const Duration(days: 1));
  }
}
