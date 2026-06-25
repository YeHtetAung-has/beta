import 'package:beta/navbar.dart';
import 'package:flutter/material.dart';

class BetaApp extends StatelessWidget {
  const BetaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beta App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
      home: const NavBarScreen(),
    );
  }
}
