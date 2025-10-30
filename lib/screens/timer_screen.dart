import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});
  @override State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration duration = Duration.zero;
  Timer? timer;
  bool running=false;

  void startTimer(){ timer = Timer.periodic(const Duration(seconds:1),(t){ setState(()=>duration += const Duration(seconds:1)); }); running=true; }
  void stopTimer(){ timer?.cancel(); running=false; }
  void resetTimer(){ timer?.cancel(); setState(()=>duration=Duration.zero); running=false; }

  @override Widget build(BuildContext context){
    String two(int n)=>n.toString().padLeft(2,'0');
    final h=two(duration.inHours.remainder(100));
    final m=two(duration.inMinutes.remainder(60));
    final s=two(duration.inSeconds.remainder(60));
    return Scaffold(
      appBar: AppBar(title: const Text('Timer/Stopwatch')),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(children:[
        Text('$h:$m:$s', style: const TextStyle(fontSize:48,fontWeight: FontWeight.bold)),
        const SizedBox(height:20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(onPressed: running? stopTimer: startTimer, child: Text(running? 'Stop':'Start')),
          const SizedBox(width:12),
          ElevatedButton(onPressed: resetTimer, child: const Text('Reset')),
        ])
      ])),
    );
  }
}
