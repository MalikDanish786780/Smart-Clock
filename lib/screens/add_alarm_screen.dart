import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alarm_model.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});
  @override State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  TimeOfDay selected = TimeOfDay.now();
  String label = '';
  bool recurring = false;
  bool smartWake = true;
  String challenge = 'math';
  String ringtone = 'assets/sounds/ring1.mp3';
  int genId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Alarm')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ListTile(
            title: Text('Time: ${selected.format(context)}'),
            trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () async {
              final t = await showTimePicker(context: context, initialTime: selected);
              if (t!=null) setState(()=>selected=t);
            }),
          ),
          TextField(decoration: const InputDecoration(labelText: 'Label'), onChanged: (v)=>label=v),
          SwitchListTile(title: const Text('Recurring (Daily)'), value: recurring, onChanged: (v)=>setState(()=>recurring=v)),
          SwitchListTile(title: const Text('Smart Wake (gradual)'), value: smartWake, onChanged: (v)=>setState(()=>smartWake=v)),
          DropdownButtonFormField<String>(
            value: challenge,
            items: const [
              DropdownMenuItem(value: 'math', child: Text('Math Challenge')),
              DropdownMenuItem(value: 'shake', child: Text('Shake Phone')),
              DropdownMenuItem(value: 'none', child: Text('No Challenge')),
            ],
            onChanged: (v) => setState(()=>challenge=v ?? 'math'),
            decoration: const InputDecoration(labelText: 'Stop Challenge'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: ringtone,
            items: List.generate(15, (i)=>DropdownMenuItem(value: 'assets/sounds/ring${i+1}.mp3', child: Text('Ringtone ${i+1}'))),
            onChanged: (v) => setState(()=>ringtone=v ?? 'assets/sounds/ring1.mp3'),
            decoration: const InputDecoration(labelText: 'Ringtone'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {
            final now = DateTime.now();
            final dt = DateTime(now.year, now.month, now.day, selected.hour, selected.minute);
            final item = AlarmItem(id: genId(), time: dt, label: label, recurring: recurring, smartWake: smartWake, challenge: challenge, ringtone: ringtone);
            Navigator.pop(context, item);
          }, child: const Text('Save Alarm'))
        ]),
      ),
    );
  }
}
