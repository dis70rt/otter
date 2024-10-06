import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'company_model.dart';

class CompanyComputation {
  final List<CompanyModel> companyData;

  CompanyComputation(this.companyData);

  Future<Map<String, dynamic>> performComputation(String companyId) async {
    // final startTime = DateTime.now();

    CompanyModel? company =
        companyData.firstWhere((c) => c.company == companyId);

    Map<String, dynamic> results = {
      // 'companiesInSameCountry': companiesInSameCountry(company),
      // 'greaterDiversityInSameCountry':
      // await greaterDiversityInSameCountry(company),
      'yearOverYearComparison': await _yearOverYearComparison(company),
      'greaterMetrics': await _compareMetrics(company),
      // 'growthAndStability': await _commentOnGrowth(company),
      'nextYearPrediction': await _predictNextYear(company),
    };

    // await _waitForMinimumTime(startTime, const Duration(minutes: 2));

    return results;
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

  Future<Map<String, dynamic>> _yearOverYearComparison(
      CompanyModel company) async {
    return {
      'stockPrice': _calculateYearlyChanges(company.stockPrices),
      'marketShare': _calculateYearlyChanges(company.marketShare),
      'revenue': _calculateYearlyChanges(company.revenue),
      'expenses': _calculateYearlyChanges(company.expenses),
    };
  }

  Map<String, double> _calculateYearlyChanges(Map<String, num?> data) {
    Map<String, double> changes = {};
    List<String> years = data.keys.toList()..sort();

    for (int i = 1; i < years.length; i++) {
      double previous = data[years[i - 1]]!.toDouble();
      double current = data[years[i]]!.toDouble();
      changes[years[i]] = ((current - previous) / previous) * 100;
    }

    return changes;
  }

  Future<Map<String, dynamic>> _compareMetrics(CompanyModel company) async {
    int greaterStockPriceCount = companyData
        .where((c) =>
            c.stockPrices.isNotEmpty &&
            c.stockPrices.values.last! > company.stockPrices.values.last!)
        .length;
    int greaterMarketShareCount = companyData
        .where((c) =>
            c.marketShare.isNotEmpty &&
            c.marketShare.values.last > company.marketShare.values.last)
        .length;
    int greaterRevenueCount = companyData
        .where((c) =>
            c.revenue.isNotEmpty &&
            c.revenue.values.last > company.revenue.values.last)
        .length;
    int greaterExpensesCount = companyData
        .where((c) =>
            c.expenses.isNotEmpty &&
            c.expenses.values.last > company.expenses.values.last)
        .length;

    return {
      'greaterStockPrice': greaterStockPriceCount,
      'greaterMarketShare': greaterMarketShareCount,
      'greaterRevenue': greaterRevenueCount,
      'greaterExpenses': greaterExpensesCount,
    };
  }

  Future<String> commentOnGrowth(CompanyModel company) async {
    double avgStockPriceChange = _calculateYearlyChanges(company.stockPrices)
            .values
            .reduce((a, b) => a + b) /
        company.stockPrices.length;
    double avgRevenueChange = _calculateYearlyChanges(company.revenue)
            .values
            .reduce((a, b) => a + b) /
        company.revenue.length;

    if (avgStockPriceChange > 10 && avgRevenueChange > 10) {
      return 'The company is growing rapidly and is showing signs of stability.';
    } else if (avgStockPriceChange < 0 || avgRevenueChange < 0) {
      return 'The company is experiencing challenges and may be unstable.';
    } else {
      return 'The company is stable with moderate growth.';
    }
  }

  Future<Map<String, dynamic>> _predictNextYear(CompanyModel company) async {
    double stockPriceGrowth = _calculateAverageGrowth(company.stockPrices);
    double marketShareGrowth = _calculateAverageGrowth(company.marketShare);
    double revenueGrowth = _calculateAverageGrowth(company.revenue);
    double expenseGrowth = _calculateAverageGrowth(company.expenses);

    return {
      'predictedStockPrice':
          company.stockPrices.values.last! * (1 + stockPriceGrowth / 100),
      'predictedMarketShare':
          company.marketShare.values.last * (1 + marketShareGrowth / 100),
      'predictedRevenue':
          company.revenue.values.last * (1 + revenueGrowth / 100),
      'predictedExpense':
          company.expenses.values.last * (1 + expenseGrowth / 100),
    };
  }

  double _calculateAverageGrowth(Map<String, num?> data) {
    Map<String, double> changes = _calculateYearlyChanges(data);
    return changes.values.reduce((a, b) => a + b) / changes.length;
  }

  Future<void> _waitForMinimumTime(
      DateTime startTime, Duration minimumDuration) async {
    final timeElapsed = DateTime.now().difference(startTime);
    if (timeElapsed < minimumDuration) {
      await Future.delayed(minimumDuration - timeElapsed);
    }
  }

  Future<void> cacheComputationResults(
      String companyId, Map<String, dynamic> results) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_computation_$companyId', jsonEncode(results));
  }

  Future<Map<String, dynamic>?> getCachedComputationResults(
      String companyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('cached_computation_$companyId');
    return cachedData != null ? jsonDecode(cachedData) : null;
  }
}
