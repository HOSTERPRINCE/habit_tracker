import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int> dataSets;

  const MyHeatMap({super.key, required this.startDate, required this.dataSets});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: HeatMap(
        startDate: startDate,
        endDate: DateTime.now(),
        datasets: dataSets,
        colorMode: ColorMode.color,
        defaultColor: Theme.of(context).colorScheme.secondary, // Theme-based default color
        textColor: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 24, // Increased size for better visibility
        colorsets: {
          1: Colors.green.shade200,
          2: Colors.green.shade300,
          3: Colors.green.shade400,
          4: Colors.green.shade500,
          5: Colors.green.shade600,
        },
      ),
    );
  }
}
