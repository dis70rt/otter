import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../services/company_model.dart';

String formatMarketCap(num marketCap) {
  return marketCap / 1e9 >= 1
      ? '${(marketCap / 1e9).toStringAsFixed(1)}B'
      : '${(marketCap / 1e6).toStringAsFixed(1)}M';
}

Widget stockPriceLineChart(CompanyModel data) {
  final spots = _generateLineChartSpots(data.stockPrices);

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

  return SizedBox(
    height: 40,
    width: 120,
    child: LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            preventCurveOvershootingThreshold: 100,
            spots: spots,
            isCurved: true,
            barWidth: 2,
            color: Colors.lightBlueAccent,
            belowBarData: BarAreaData(
                show: true, color: Colors.tealAccent.withOpacity(0.3)),
            dotData: const FlDotData(show: false),
            preventCurveOverShooting: true,
            isStrokeCapRound: true,
          ),
        ],
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        clipData: const FlClipData.all(),
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
