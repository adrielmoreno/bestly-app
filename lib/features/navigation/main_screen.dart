import 'package:flutter/material.dart';

import '../home/home_page.dart';
import 'ejercicios/ejercicio_navigation.dart';
import 'food/food_navigation.dart';
import 'menu/menu_navigation.dart';
import 'resumen/resumen_navigation.dart';
import 'sueño/sueno_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const EjercicioNavigation(),
    const FoodNavigation(),
    const SuenoNavigation(),
    const ResumenNavigation(
        totalExerciseMinutes: 140, totalCalories: 2100, totalSleepHours: 45),
    const MenuNavigation(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Ejefrcicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant), label: 'Comida'),
          BottomNavigationBarItem(icon: Icon(Icons.bed), label: 'Sueño'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: 'Resumen'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}
