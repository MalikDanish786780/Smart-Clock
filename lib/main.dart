import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'models/alarm_model.dart';
import 'services/alarm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AlarmService().init(); // init notifications + alarm manager
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlarmModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Alarm',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.cyan),
        home: const HomeScreen(),
      ),
    );
  }
}
