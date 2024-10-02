import 'dart:developer';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:otter/services/company_model.dart';
import 'package:otter/services/database_provider.dart';
import 'package:provider/provider.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FireStoreProvider>(
      builder: (context, docsProvider, child) {
        if (docsProvider.isLoading && docsProvider.companyDataList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = docsProvider.companyDataList;
        return ListView.builder(
          itemCount: data.length + (docsProvider.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < data.length) {
              return _companyCard(data[index]);
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
          controller: _scrollController(docsProvider),
        );
      },
    );
  }

  ScrollController _scrollController(FireStoreProvider docsProvider) {
    final controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent &&
          !docsProvider.isLoading) {
        docsProvider.fetchCompanyData();
      }
    });
    return controller;
  }

  Widget _companyCard(CompanyModel data) {
    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12, width: 2),
            gradient: RadialGradient(
              colors: [
                Colors.blueAccent,
                Colors.indigo.shade900,
                const Color(0xFF0B1050)
              ],
              radius: 3,
              center: const Alignment(-1, -3),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${data.country.toUpperCase()} (${data.countryCode})",
                        style: const TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                    const SizedBox(height: 20),
                    Text(data.company,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const SizedBox(height: 5),
                    Text("DIVERSITY: ${data.diversity}%",
                        style: const TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    _stockPriceLineChart(data),
                    const SizedBox(height: 15),
                    Text(
                      "MCAP: \$${_formatMarketCap(data.marketCap)}",
                      style: const TextStyle(
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMarketCap(num marketCap) {
    return marketCap / 1e9 >= 1
        ? '${(marketCap / 1e9).toStringAsFixed(1)}B'
        : '${(marketCap / 1e6).toStringAsFixed(1)}M';
  }

  Widget _stockPriceLineChart(CompanyModel data) {
    final spots = _generateLineChartSpots(data.stockPrices);
    // If there are no data points, we should return an empty chart or a placeholder
    if (spots.isEmpty) {
      return const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
      );
    }

    // Calculate min and max Y values based on actual stock prices
    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        height: 40,
        width: 120,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 2,
                color: Colors.tealAccent,
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
      ),
    );
  }

  List<FlSpot> _generateLineChartSpots(Map<String, num?> stockPrices) {
    final sortedYears = stockPrices.keys.toList(); // Sort the keys (years)
    return List.generate(sortedYears.length, (i) {
      final stockPrice = stockPrices[sortedYears[i]];
      if (stockPrice == null) return null;

      // Use original stock prices without scaling
      return FlSpot(i.toDouble(), stockPrice.toDouble());
    }).whereType<FlSpot>().toList();
  }
}
