import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FoodEntry {
  final String name;
  final String type; // desayuno, almuerzo, cena, snack
  final int calories;
  final DateTime date;

  FoodEntry({
    required this.name,
    required this.type,
    required this.calories,
    required this.date,
  });
}

enum FilterMode { day, week }

class FoodNavigation extends StatefulWidget {
  const FoodNavigation({super.key});

  @override
  State<FoodNavigation> createState() => _FoodNavigationState();
}

class _FoodNavigationState extends State<FoodNavigation> {
  final List<FoodEntry> _foods = [];
  FilterMode _filterMode = FilterMode.day;
  DateTime _selectedDate = DateTime.now();

  List<FoodEntry> get _filteredFoods {
    if (_filterMode == FilterMode.day) {
      return _foods
          .where((f) =>
              f.date.year == _selectedDate.year &&
              f.date.month == _selectedDate.month &&
              f.date.day == _selectedDate.day)
          .toList();
    } else {
      final weekStart =
          _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return _foods
          .where((f) =>
              f.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
              f.date.isBefore(weekEnd.add(const Duration(days: 1))))
          .toList();
    }
  }

  int get totalCalories => _filteredFoods.fold(0, (sum, f) => sum + f.calories);

  Map<int, int> get weeklyCalories {
    final Map<int, int> data = {for (var i = 1; i <= 7; i++) i: 0};
    final weekStart =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));

    for (var food in _foods) {
      final diff = food.date.difference(weekStart).inDays;
      if (diff >= 0 && diff < 7) {
        final weekday = food.date.weekday;
        data[weekday] = data[weekday]! + food.calories;
      }
    }

    return data;
  }

  void _addFood() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String type = 'Desayuno';
        String calories = '';

        return AlertDialog(
          title: const Text('Agregar comida'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => name = value,
              ),
              DropdownButton<String>(
                value: type,
                onChanged: (value) => setState(() => type = value!),
                items: ['Desayuno', 'Almuerzo', 'Cena', 'Snack']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
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
                if (name.isNotEmpty && int.tryParse(calories) != null) {
                  setState(() {
                    _foods.add(FoodEntry(
                      name: name,
                      type: type,
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

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(7, (index) {
      final weekday = index + 1;
      final calories = weeklyCalories[weekday] ?? 0;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: calories.toDouble(), width: 16, color: Colors.green)
      ]);
    });
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
                  'https://www.adherencia-cronicidad-pacientes.com/wp-content/uploads/2020/03/Recurso_comida_saludable-scaled.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  'Comida ',
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
              title: const Text('Resumen nutricional'),
              subtitle: Text('Calorías totales: $totalCalories kcal'),
              leading: const Icon(Icons.local_dining),
            ),
          ),
          if (_filterMode == FilterMode.week)
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                              return Text(days[value.toInt()]);
                            }),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 30),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _buildBarGroups(),
                  ),
                ),
              ),
            ),
          Expanded(
            child: _filteredFoods.isEmpty
                ? const Center(child: Text('No hay comidas registradas.'))
                : ListView.builder(
                    itemCount: _filteredFoods.length,
                    itemBuilder: (context, index) {
                      final f = _filteredFoods[index];
                      return ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text('${f.name} (${f.type})'),
                        subtitle: Text('${f.calories} kcal'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFood,
        child: const Icon(Icons.add),
      ),
    );
  }
}
