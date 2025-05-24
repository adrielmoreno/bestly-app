import 'package:flutter/material.dart';

class ResumenNavigation extends StatelessWidget {
  final double totalExerciseMinutes;
  final double totalCalories;
  final double totalSleepHours;

  const ResumenNavigation({
    super.key,
    required this.totalExerciseMinutes,
    required this.totalCalories,
    required this.totalSleepHours,
  });

  String getExerciseMessage(double minutes) {
    if (minutes >= 150)
      return "¡Excelente! Has cumplido tu meta de ejercicio semanal 💪";
    if (minutes >= 75)
      return "Vas bien, ¡sigue así! Un poco más de movimiento te hará bien 🚶‍♂️";
    return "Intenta moverte más durante la semana 🏃‍♀️";
  }

  String getFoodMessage(double calories) {
    if (calories < 1200)
      return "Podrías estar comiendo muy poco, revisa tu ingesta 🥗";
    if (calories > 2500)
      return "Atento a las calorías altas, busca un equilibrio 🍟🍎";
    return "¡Buena alimentación! Mantén esa energía 🍽️";
  }

  String getSleepMessage(double hours) {
    if (hours >= 49) return "Descanso adecuado esta semana 😴";
    if (hours >= 35)
      return "Podrías dormir un poco más para recuperar energías 🌙";
    return "Prioriza tu descanso. Dormir es clave para tu salud 🛌";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Salud'),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen Semanal 📈',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildStatCard(
                "Ejercicio",
                "$totalExerciseMinutes min",
                getExerciseMessage(totalExerciseMinutes),
                Icons.fitness_center,
                Colors.blue),
            const SizedBox(height: 8),
            _buildStatCard(
                "Alimentación",
                "${totalCalories.toStringAsFixed(0)} kcal",
                getFoodMessage(totalCalories),
                Icons.restaurant,
                Colors.orange),
            const SizedBox(height: 8),
            _buildStatCard("Sueño", "${totalSleepHours.toStringAsFixed(1)} h",
                getSleepMessage(totalSleepHours), Icons.bedtime, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String recommendation,
      IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(recommendation,
                      style: const TextStyle(color: Colors.black87)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
