import 'dart:async';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter PIP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyScreen(),
    );
  }
}

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with WidgetsBindingObserver {
  final floating = Floating();
  Color color = Colors.red;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        color = color == Colors.green ? Colors.red : Colors.green;
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      floating.enable(aspectRatio: const Rational.square());
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> enablePip() async {
    final status = floating.enable(
      aspectRatio: const Rational.landscape(),
    );
    debugPrint("Pip Status: $status");
  }

  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      floating: floating,
      childWhenEnabled: Material(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: color,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Floating",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
      ),
      childWhenDisabled: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          alignment: Alignment.center,
          child: const Text(
            "View",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => enablePip(),
          child: const Icon(Icons.picture_in_picture),
        ),
      ),
    );
  }
}
