import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});
  @override State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Duration elapsed = Duration.zero;
  Timer? timer;
  bool running=false;

  void start(){ timer = Timer.periodic(const Duration(milliseconds:100),(t){ setState(()=> elapsed += const Duration(milliseconds:100)); }); running=true; }
  void pause(){ timer?.cancel(); running=false; }
  void reset(){ timer?.cancel(); setState(()=> elapsed=Duration.zero); running=false; }

  @override Widget build(BuildContext context){
    String two(int n)=>n.toString().padLeft(2,'0');
    final h=two(elapsed.inHours.remainder(100));
    final m=two(elapsed.inMinutes.remainder(60));
    final s=two(elapsed.inSeconds.remainder(60));
    final ms=(elapsed.inMilliseconds.remainder(1000)/100).floor();
    return Scaffold(appBar: AppBar(title: const Text('Stopwatch')), body: Padding(padding: const EdgeInsets.all(24), child: Column(children:[
      Text('$h:$m:$s.$ms', style: const TextStyle(fontSize:42,fontWeight: FontWeight.bold)),
      const SizedBox(height:20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(onPressed: running? pause: start, child: Text(running? 'Pause':'Start')),
        const SizedBox(width:12),
        ElevatedButton(onPressed: reset, child: const Text('Reset')),
      ])
    ])),);
  }
}
