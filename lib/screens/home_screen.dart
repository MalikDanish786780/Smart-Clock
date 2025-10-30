import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm_model.dart';
import 'add_alarm_screen.dart';
import 'timer_screen.dart';
import 'stopwatch_screen.dart';
import 'world_clock_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AlarmModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Alarm - Made by Danish')),
      body: Column(
        children: [
          Expanded(child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text('Alarms', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
              const SizedBox(height:8),
              for (var a in model.alarms)
                Card(child: ListTile(
                  title: Text(a.label.isEmpty ? 'Alarm' : a.label),
                  subtitle: Text('${a.time.hour.toString().padLeft(2,'0')}:${a.time.minute.toString().padLeft(2,'0')} - ${a.recurring? "Daily": "Once"}'),
                  trailing: Switch(value: a.enabled, onChanged: (v){ model.toggle(a.id); }),
                )),
              const SizedBox(height:12),
              ElevatedButton.icon(onPressed: () async {
                final added = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAlarmScreen()));
                if(added!=null){ model.addAlarm(added); }
              }, icon: const Icon(Icons.add), label: const Text('Add Alarm')),
              const Divider(),
              const SizedBox(height:8),
              ElevatedButton.icon(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const TimerScreen())); }, icon: const Icon(Icons.timer), label: const Text('Timer')),
              const SizedBox(height:8),
              ElevatedButton.icon(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const StopwatchScreen())); }, icon: const Icon(Icons.watch), label: const Text('Stopwatch')),
              const SizedBox(height:8),
              ElevatedButton.icon(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const WorldClockScreen())); }, icon: const Icon(Icons.public), label: const Text('World Clock')),
            ],
          )),
        ],
      ),
    );
  }
}
