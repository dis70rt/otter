import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

String formatMarketCap(num marketCap) {
  return marketCap / 1e9 >= 1
      ? '${(marketCap / 1e9).toStringAsFixed(1)}B'
      : '${(marketCap / 1e6).toStringAsFixed(1)}M';
}

Widget lineChart(Map<String, num?> data, String label) {
  final sortedData = _sortDataByYears(data);
  final spots = _generateLineChartSpots(sortedData);

  if (spots.isEmpty) {
    return const Center(
      child: Text(
        'No Data Available',
        style: TextStyle(color: Colors.white60, fontSize: 12),
      ),
    );
  }

  final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
  final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);

  // Increase maxY by a certain percentage (e.g., 10%)
  final adjustedMaxY = maxY * 1.1; // Adjust this value as needed

  return Padding(
    padding: const EdgeInsets.only(right: 10),
    child: SizedBox(
      height: 200,
      width: 600,
      child: LineChart(
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
        LineChartData(
          gridData: FlGridData(
            show: false,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: Colors.white10,
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => const FlLine(
              color: Colors.white10,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < sortedData.length) {
                    final key = sortedData.keys.toList()[index];
                    return Text(
                      key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  // Format the left labels into millions and billions
                  return Text(
                    formatMarketCap(value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8, // Reduced text size for left labels
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white10, width: 1),
          ),
          lineBarsData: [
            LineChartBarData(
              // preventCurveOvershootingThreshold: 1,
              spots: spots,
              isCurved: true,
              barWidth: 3,
              color: Colors.lightBlueAccent,
              belowBarData: BarAreaData(
                  show: true, color: Colors.lightBlueAccent.withOpacity(0.3)),
              dotData: const FlDotData(show: false),
              isStrokeCapRound: false,
              curveSmoothness: 0.1,
            ),
          ],
          minX: 0,
          maxX: spots.length.toDouble() - 1,
          minY: minY,
          maxY: adjustedMaxY, // Use the adjusted maxY
          clipData: const FlClipData.all(),
        ),
      ),
    ),
  );
}

List<FlSpot> _generateLineChartSpots(Map<String, num?> stockPrices) {
  final sortedYears = stockPrices.keys.toList();
  return List.generate(sortedYears.length, (i) {
    final stockPrice = stockPrices[sortedYears[i]];
    if (stockPrice == null) return null;

    return FlSpot(i.toDouble(), stockPrice.toDouble());
  }).whereType<FlSpot>().toList();
}

Map<String, num?> _sortDataByYears(Map<String, num?> data) {
  final sortedKeys = data.keys.toList()..sort();
  return {for (var key in sortedKeys) key: data[key]};
}
