import 'package:flutter/material.dart';

class AlarmItem {
  int id;
  DateTime time;
  String label;
  bool enabled;
  bool recurring;
  bool smartWake;
  String challenge;
  String ringtone; // path in assets or custom file path

  AlarmItem({
    required this.id,
    required this.time,
    this.label = '',
    this.enabled = true,
    this.recurring = false,
    this.smartWake = true,
    this.challenge = 'math',
    this.ringtone = 'assets/sounds/ring1.mp3',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time.toIso8601String(),
    'label': label,
    'enabled': enabled,
    'recurring': recurring,
    'smartWake': smartWake,
    'challenge': challenge,
    'ringtone': ringtone,
  };

  static AlarmItem fromJson(Map<String, dynamic> j) => AlarmItem(
    id: j['id'],
    time: DateTime.parse(j['time']),
    label: j['label'] ?? '',
    enabled: j['enabled'] ?? true,
    recurring: j['recurring'] ?? false,
    smartWake: j['smartWake'] ?? true,
    challenge: j['challenge'] ?? 'math',
    ringtone: j['ringtone'] ?? 'assets/sounds/ring1.mp3',
  );
}

class AlarmModel extends ChangeNotifier {
  List<AlarmItem> alarms = [];
  void addAlarm(AlarmItem a){ alarms.add(a); notifyListeners(); }
  void removeAlarm(int id){ alarms.removeWhere((e)=>e.id==id); notifyListeners(); }
  void toggle(int id){
    final i = alarms.indexWhere((e)=>e.id==id);
    if(i>=0){ alarms[i].enabled = !alarms[i].enabled; notifyListeners(); }
  }
}
