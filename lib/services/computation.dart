import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'company_model.dart';

class CompanyComputation {
  final List<CompanyModel> companyData;
  CompanyComputation(this.companyData);

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

    // final stockPriceStdDev = _calculateStandardDeviation(stockPriceChanges.values.toList());
    // final revenueStdDev = _calculateStandardDeviation(revenueChanges.values.toList());
    // final expenseStdDev = _calculateStandardDeviation(expenseChanges.values.toList());
    // final marketShareStdDev = _calculateStandardDeviation(marketShareChanges.values.toList());

    // Logic to comment on growth
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
    // Example weights for the last three years
    List<double> weights = [4, 3, 2]; // Adjust weights based on relevant criteria
    List<double> weightedValues = [];

    for (int i = 0; i < values.length && i < weights.length; i++) {
      weightedValues.add(values[i] * weights[i]);
    }

    double totalWeight = weights.take(weightedValues.length).reduce((a, b) => a + b);
    double weightedMedian = weightedValues.reduce((a, b) => a + b) / totalWeight;

    return weightedMedian;
  }

  double _calculateStandardDeviation(List<double> values) {
    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance = values.map((value) => (value - mean) * (value - mean)).reduce((a, b) => a + b) / values.length;
    return sqrt(variance);
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
