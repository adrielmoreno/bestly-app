import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExerciseEntry {
  final String name;
  final int minutes;
  final int calories;
  final DateTime date;

  ExerciseEntry({
    required this.name,
    required this.minutes,
    required this.calories,
    required this.date,
  });
}

class EjercicioNavigation extends StatefulWidget {
  const EjercicioNavigation({super.key});

  @override
  State<EjercicioNavigation> createState() => _EjercicioNavigationState();
}

enum FilterMode { day, week }

class _EjercicioNavigationState extends State<EjercicioNavigation> {
  final List<ExerciseEntry> _exercises = [];
  FilterMode _filterMode = FilterMode.day;
  DateTime _selectedDate = DateTime.now();

  List<ExerciseEntry> get _filteredExercises {
    if (_filterMode == FilterMode.day) {
      return _exercises
          .where((e) =>
              e.date.year == _selectedDate.year &&
              e.date.month == _selectedDate.month &&
              e.date.day == _selectedDate.day)
          .toList();
    } else {
      final weekStart =
          _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return _exercises
          .where((e) =>
              e.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
              e.date.isBefore(weekEnd.add(const Duration(days: 1))))
          .toList();
    }
  }

  int get totalMinutes =>
      _filteredExercises.fold(0, (sum, e) => sum + e.minutes);
  int get totalCalories =>
      _filteredExercises.fold(0, (sum, e) => sum + e.calories);

  List<BarChartGroupData> _generateWeeklyBars() {
    final weekStart =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    List<BarChartGroupData> bars = [];

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final totalMinutes = _exercises
          .where((e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day)
          .fold<int>(0, (sum, e) => sum + e.minutes);

      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: totalMinutes.toDouble(),
              color: Colors.green,
              width: 18,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      );
    }

    return bars;
  }

  void _addExercise() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String minutes = '';
        String calories = '';

        return AlertDialog(
          title: const Text('Agregar ejercicio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Minutos'),
                keyboardType: TextInputType.number,
                onChanged: (value) => minutes = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Calorías'),
                keyboardType: TextInputType.number,
                onChanged: (value) => calories = value,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty &&
                    int.tryParse(minutes) != null &&
                    int.tryParse(calories) != null) {
                  setState(() {
                    _exercises.add(ExerciseEntry(
                      name: name,
                      minutes: int.parse(minutes),
                      calories: int.parse(calories),
                      date: DateTime.now(),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  'https://tophealth.es/wp-content/uploads/2023/04/ejercicios-para-gluteos-en-gimnasio.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  'Ejercicios',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                          color: Colors.black54,
                          offset: Offset(1, 1),
                          blurRadius: 4)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Día'),
                selected: _filterMode == FilterMode.day,
                onSelected: (_) {
                  setState(() {
                    _filterMode = FilterMode.day;
                  });
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Semana'),
                selected: _filterMode == FilterMode.week,
                onSelected: (_) {
                  setState(() {
                    _filterMode = FilterMode.week;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _filterMode == FilterMode.day
                      ? 'Fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'
                      : 'Semana del ${_selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)).day}/${_selectedDate.month}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: const Text('Resumen del día'),
              subtitle:
                  Text('Minutos: $totalMinutes | Calorías: $totalCalories'),
              leading: const Icon(Icons.fitness_center),
            ),
          ),
          if (_filterMode == FilterMode.week)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                            return Text(days[value.toInt()]);
                          },
                          interval: 1,
                        ),
                      ),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barGroups: _generateWeeklyBars(),
                  ),
                ),
              ),
            ),
          Expanded(
            child: _filteredExercises.isEmpty
                ? const Center(child: Text('No hay ejercicios ese día.'))
                : ListView.builder(
                    itemCount: _filteredExercises.length,
                    itemBuilder: (context, index) {
                      final e = _filteredExercises[index];
                      return ListTile(
                        leading: const Icon(Icons.check),
                        title: Text(e.name),
                        subtitle: Text('${e.minutes} min | ${e.calories} kcal'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}
