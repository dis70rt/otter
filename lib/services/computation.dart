import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otter/services/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'company_model.dart';

class CompanyComputation {
  final FireStoreProvider fireStoreProvider = FireStoreProvider();
  late final List<CompanyModel> companyData;

  CompanyComputation() {
    companyData = fireStoreProvider.companyDataList;
  }

  List<CompanyModel> companiesInSameCountry(String country) {
    return companyData
        .where((c) => c.country.toLowerCase() == country.toLowerCase())
        .toList();
  }

  List<CompanyModel> greaterDiversityInSameCountry(CompanyModel company) {
    return companyData
        .where((c) =>
            c.country == company.country && c.diversity > company.diversity)
        .toList();
  }

  Future<Map<String, dynamic>> yearOverYearComparison(
      CompanyModel company) async {
    return {
      'stockPrice': _calculateYearlyChanges(company.stockPrices),
      'marketShare': _calculateYearlyChanges(company.marketShare),
      'revenue': _calculateYearlyChanges(company.revenue),
      'expenses': _calculateYearlyChanges(company.expenses),
    };
  }

  List<CompanyModel> getTopPerformingCompanies({int topCount = 3}) {
    companyData.sort((a, b) {
      final latestYearA = a.stockPrices.keys.last;
      final latestYearB = b.stockPrices.keys.last;
      final stockPriceA = a.stockPrices[latestYearA] ?? 0;
      final stockPriceB = b.stockPrices[latestYearB] ?? 0;
      return stockPriceB.compareTo(stockPriceA);
    });

    return companyData.take(topCount).toList();
  }

  Map<String, double> _calculateYearlyChanges(Map<String, num?> data) {
    final changes = <String, double>{};
    final years = data.keys.toList()..sort();

    for (int i = 1; i < years.length; i++) {
      final previous = (data[years[i - 1]] ?? 0).toDouble();
      final current = (data[years[i]] ?? 0).toDouble();

      changes[years[i]] = ((current - previous) / previous) * 100;
    }

    return changes;
  }

  Future<Widget> commentOnGrowth(
      CompanyModel company, VoidCallback onTap) async {
    final stockPriceChanges = _calculateYearlyChanges(company.stockPrices);
    final revenueChanges = _calculateYearlyChanges(company.revenue);
    final expenseChanges = _calculateYearlyChanges(company.expenses);
    final marketShareChanges = _calculateYearlyChanges(company.marketShare);

    final weightedMedianStockPriceChange =
        _calculateWeightedMedian(stockPriceChanges.values.toList());
    final weightedMedianRevenueChange =
        _calculateWeightedMedian(revenueChanges.values.toList());
    final weightedMedianExpenseChange =
        _calculateWeightedMedian(expenseChanges.values.toList());
    final weightedMedianMarketShareChange =
        _calculateWeightedMedian(marketShareChanges.values.toList());

    if (weightedMedianStockPriceChange > 10 &&
        weightedMedianRevenueChange > 10 &&
        weightedMedianMarketShareChange > 5 &&
        weightedMedianExpenseChange < 5) {
      return _growthText(
          Colors.green.shade200,
          'The company shows strong growth in stock price, revenue, and market share, with controlled expenses.',
          onTap);
    } else if (weightedMedianStockPriceChange > 0 &&
        weightedMedianRevenueChange > 0 &&
        weightedMedianMarketShareChange > 0 &&
        weightedMedianExpenseChange < 10) {
      return _growthText(
          Colors.yellow.shade200,
          'The company is experiencing moderate growth, but expenses or market share could become a concern.',
          onTap);
    } else if (weightedMedianStockPriceChange < 0 ||
        weightedMedianRevenueChange < 0 ||
        weightedMedianMarketShareChange < 0 ||
        weightedMedianExpenseChange > 10) {
      return _growthText(
          Colors.red.shade200,
          'The company is facing challenges with declining metrics or rising expenses, indicating potential instability.',
          onTap);
    } else {
      return _growthText(
          Colors.grey.shade200,
          'The company is stable but not showing significant growth, suggesting a cautious position.',
          onTap);
    }
  }

  double _calculateWeightedMedian(List<double> values) {
    List<double> weights = [4, 3, 2];

    if (values.length < weights.length) {
      weights = weights.take(values.length).toList();
    }

    List<double> weightedValues = [];
    for (int i = 0; i < values.length; i++) {
      weightedValues.add(values[i] * weights[i % weights.length]);
    }

    double totalWeight =
        weights.take(weightedValues.length).reduce((a, b) => a + b);
    return weightedValues.reduce((a, b) => a + b) / totalWeight;
  }

  RichText _growthText(Color color, String text, VoidCallback onTap) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text, style: TextStyle(color: color)),
          TextSpan(
            text: ' (why?)',
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }

  Future<void> cacheComputationResults(
      String companyId, Map<String, dynamic> results) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_computation_$companyId', jsonEncode(results));
  }

  Future<Map<String, dynamic>?> getCachedComputationResults(
      String companyId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_computation_$companyId');
    return cachedData != null ? jsonDecode(cachedData) : null;
  }
}
