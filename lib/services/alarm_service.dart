import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

class AlarmService {
  static final AlarmService _inst = AlarmService._internal();
  factory AlarmService() => _inst;
  AlarmService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FlutterTts flutterTts = FlutterTts();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    final String tzName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzName));

    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (payload) { });

    await AndroidAlarmManager.initialize();

    // TTS default settings
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> scheduleAlarm({ required int id, required DateTime dateTime, String? title, String? body, String? ringtone }) async {
    final alarmTime = tz.TZDateTime.from(dateTime, tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title ?? 'Alarm',
      body ?? 'Time to wake up',
      alarmTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Channel',
          channelDescription: 'Alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('ring1'),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    await AndroidAlarmManager.oneShotAt(dateTime, id, _alarmCallback, exact: true, wakeup: true, rescheduleOnReboot: true);
  }

  static Future<void> _alarmCallback() async {
    final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await fln.initialize(const InitializationSettings(android: androidInit));
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails('alarm_channel', 'Alarm Channel', channelDescription: 'Alarm notifications', importance: Importance.max, priority: Priority.high, fullScreenIntent: true);
    const NotificationDetails nd = NotificationDetails(android: androidDetails);
    await fln.show(Random().nextInt(100000), 'Alarm', 'Time to wake up', nd);

    // Voice + vibration - best-effort: initialize TTS and vibrate
    try {
      final FlutterTts tts = FlutterTts();
      await tts.setLanguage("en-US");
      await tts.setSpeechRate(0.5);
      await tts.speak("Good morning! Time to wake up");
    } catch (e) {
      // ignore
    }
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 500, 200, 500]);
      }
    } catch (e) {}
  }

  Future<void> cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    await AndroidAlarmManager.cancel(id);
  }
}
