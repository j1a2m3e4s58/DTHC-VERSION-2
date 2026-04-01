import 'package:flutter/material.dart';
import '../pages/home_page.dart';

class SuperFoodsApp extends StatelessWidget {
  const SuperFoodsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SuperFoods',
      home: const HomePage(),
    );
  }
}