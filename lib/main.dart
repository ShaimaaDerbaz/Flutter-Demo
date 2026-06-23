import 'dart:async';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'screens/home_screen.dart';
import 'features/share_receiver/presentation/screens/share_receiver_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _intentSub;

  @override
  void initState() {
    super.initState();

    // While app is already open — receive new shares
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      _openSharedFiles,
      onError: (e) => debugPrint('Sharing stream error: $e'),
    );

    // App was launched via share — handle the initial intent
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _openSharedFiles(files));
      }
    });
  }

  void _openSharedFiles(List<SharedMediaFile> files) {
    if (files.isEmpty) return;
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => ShareReceiverScreen(files: files)),
    );
    ReceiveSharingIntent.instance.reset();
  }

  @override
  void dispose() {
    _intentSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Basics Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
