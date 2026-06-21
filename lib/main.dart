import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

/// الـ Widget الجذري للتطبيق
/// = MainActivity + Theme setup في Compose
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Basics Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // = MaterialTheme في Compose
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
