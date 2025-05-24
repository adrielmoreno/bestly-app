import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SleepEntry {
  final DateTime date;
  final double hours;

  SleepEntry({required this.date, required this.hours});
}

enum FilterMode { day, week }

class SuenoNavigation extends StatefulWidget {
  const SuenoNavigation({super.key});

  @override
  State<SuenoNavigation> createState() => _SuenoNavigationState();
}

class _SuenoNavigationState extends State<SuenoNavigation> {
  final List<SleepEntry> _entries = [];
  final DateTime _selectedDate = DateTime.now();
  FilterMode _filterMode = FilterMode.day;

  void _addSleepEntry(double hours) {
    setState(() {
      _entries.add(SleepEntry(date: DateTime.now(), hours: hours));
    });
  }

  void _showAddSleepDialog() {
    final hoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar horas dormidas'),
        content: TextField(
          controller: hoursController,
          decoration: const InputDecoration(labelText: 'Horas'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (hoursController.text.isNotEmpty) {
                final value = double.tryParse(hoursController.text);
                if (value != null) {
                  _addSleepEntry(value);
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  List<SleepEntry> get _filteredEntries {
    if (_filterMode == FilterMode.day) {
      return _entries
          .where((e) =>
              e.date.year == _selectedDate.year &&
              e.date.month == _selectedDate.month &&
              e.date.day == _selectedDate.day)
          .toList();
    } else {
      final start =
          _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      final end = start.add(const Duration(days: 6));
      return _entries
          .where((e) =>
              e.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
              e.date.isBefore(end.add(const Duration(days: 1))))
          .toList();
    }
  }

  double get totalHours => _filteredEntries.fold(0, (sum, e) => sum + e.hours);

  List<BarChartGroupData> get _weeklyBarData {
    final Map<int, double> dailyData = {};
    for (var i = 1; i <= 7; i++) {
      dailyData[i] = 0;
    }

    for (var entry in _filteredEntries) {
      int weekday = entry.date.weekday;
      dailyData[weekday] = (dailyData[weekday] ?? 0) + entry.hours;
    }

    return List.generate(7, (i) {
      final day = i + 1;
      final hours = dailyData[day] ?? 0;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: hours, width: 16, color: Colors.blueAccent),
        ],
      );
    });
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: Image.asset(
            'assets/img/sueno.png',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Text(
            'Habito de Sueño',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                const Shadow(
                    color: Colors.black54, offset: Offset(1, 1), blurRadius: 4)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                    return Text(days[value.toInt()]);
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, _) => Text('${value.toInt()}h'),
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: _weeklyBarData,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSleepDialog,
        child: const Icon(Icons.nightlight_round),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Día'),
                selected: _filterMode == FilterMode.day,
                onSelected: (_) => setState(() => _filterMode = FilterMode.day),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Semana'),
                selected: _filterMode == FilterMode.week,
                onSelected: (_) =>
                    setState(() => _filterMode = FilterMode.week),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Text(
              'Total de horas: ${totalHours.toStringAsFixed(1)} h',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (_filterMode == FilterMode.week) _buildChart(),
          Expanded(
            child: _filteredEntries.isEmpty
                ? const Center(child: Text('No hay registros de sueño.'))
                : ListView.builder(
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _filteredEntries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.bed),
                          title: Text('${entry.hours} h'),
                          subtitle: Text(
                              '${entry.date.day}/${entry.date.month}/${entry.date.year}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
