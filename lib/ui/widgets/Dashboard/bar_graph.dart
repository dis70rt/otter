import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

String formatMarketCap(num marketCap) {
  return marketCap / 1e9 >= 1
      ? '${(marketCap / 1e9).toStringAsFixed(1)}B'
      : '${(marketCap / 1e6).toStringAsFixed(1)}M';
}

Widget barChart(Map<String, num?> data) {
  final sortedData = _sortDataByYears(data);
  final barGroups = _generateBarChartGroups(sortedData);

  if (barGroups.isEmpty) {
    return const Center(
      child: Text(
        'No Data Available',
        style: TextStyle(color: Colors.white60, fontSize: 12),
      ),
    );
  }

  final maxY = barGroups.map((group) => group.barRods.first.toY).reduce((a, b) => a > b ? a : b);
  final adjustedMaxY = maxY * 1.1;

  return Padding(
    padding: const EdgeInsets.only(right: 10),
    child: SizedBox(
      height: 200,
      width: 600,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false), // Remove grids
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
                  return Text(
                    formatMarketCap(value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
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
          barGroups: barGroups,
          minY: 0,
          maxY: adjustedMaxY,
        ),
      ),
    ),
  );
}

List<BarChartGroupData> _generateBarChartGroups(Map<String, num?> stockPrices) {
  final sortedYears = stockPrices.keys.toList();
  return List.generate(sortedYears.length, (i) {
    final stockPrice = stockPrices[sortedYears[i]];
    if (stockPrice == null) return null;

    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: stockPrice.toDouble(),
          color: Colors.lightBlueAccent,
          width: 10,
          borderRadius: BorderRadius.zero,
        ),
      ],
    );
  }).whereType<BarChartGroupData>().toList();
}

Map<String, num?> _sortDataByYears(Map<String, num?> data) {
  final sortedKeys = data.keys.toList()..sort();
  return {for (var key in sortedKeys) key: data[key]};
}
