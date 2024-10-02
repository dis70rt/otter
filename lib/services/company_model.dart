import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  String company;
  String country;
  String countryCode;
  num marketCap;
  double diversity;
  Map<String, num?> stockPrices;
  Map<String, num> expenses;
  Map<String, num> revenue;
  Map<String, double> marketShare;

  CompanyModel({
    required this.company,
    required this.country,
    required this.countryCode,
    required this.marketCap,
    required this.diversity,
    required this.stockPrices,
    required this.expenses,
    required this.revenue,
    required this.marketShare,
  });

  factory CompanyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CompanyModel(
      company: data['Company'] ?? '',
      country: data['Country'] ?? '',
      countryCode: data['Country Code'] ?? '',
      marketCap: data['Market Cap'] ?? 0,
      diversity: data['Diversity']?.toDouble() ?? 0.0,
      stockPrices: Map<String, num?>.from(data['Stock Prices'] ?? {}),
      expenses: Map<String, num>.from(data['Expenses'] ?? {}),
      revenue: Map<String, num>.from(data['Revenue'] ?? {}),
      marketShare: Map<String, double>.from(data['Market Share']
              ?.map((key, value) => MapEntry(key, (value as num).toDouble())) ??
          {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'Company': company,
      'Country': country,
      'Country Code': countryCode,
      'Market Cap': marketCap,
      'Diversity': diversity,
      'Stock Prices': stockPrices,
      'Expenses': expenses,
      'Revenue': revenue,
      'Market Share': marketShare,
    };
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      company: json['Company'] ?? '',
      country: json['Country'] ?? '',
      countryCode: json['Country Code'] ?? '',
      marketCap: json['Market Cap'] ?? 0,
      diversity: (json['Diversity'] ?? 0.0).toDouble(),
      stockPrices: Map<String, num?>.from(json['Stock Prices'] ?? {}),
      expenses: Map<String, num>.from(json['Expenses'] ?? {}),
      revenue: Map<String, num>.from(json['Revenue'] ?? {}),
      marketShare: Map<String, double>.from(json['Market Share']
              ?.map((key, value) => MapEntry(key, (value as num).toDouble())) ??
          {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Company': company,
      'Country': country,
      'Country Code': countryCode,
      'Market Cap': marketCap,
      'Diversity': diversity,
      'Stock Prices': stockPrices,
      'Expenses': expenses,
      'Revenue': revenue,
      'Market Share': marketShare,
    };
  }
}
