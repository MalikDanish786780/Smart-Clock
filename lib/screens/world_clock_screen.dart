import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class WorldClockScreen extends StatefulWidget {
  const WorldClockScreen({super.key});
  @override State<WorldClockScreen> createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends State<WorldClockScreen> {
  final List<String> zones = ['UTC','America/New_York','Europe/London','Asia/Karachi','Asia/Kolkata','Asia/Tokyo','Australia/Sydney'];
  @override void initState(){ super.initState(); tzdata.initializeTimeZones(); }
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text('World Clock')), body: ListView.builder(itemCount: zones.length, itemBuilder: (_,i){
      final loc = tz.getLocation(zones[i]);
      final now = tz.TZDateTime.now(loc);
      final fmt = DateFormat('hh:mm a, dd MMM');
      return ListTile(title: Text(zones[i]), subtitle: Text(fmt.format(now)));
    }));
  }
}
