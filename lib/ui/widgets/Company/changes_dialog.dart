import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/services/company_model.dart';
import 'package:otter/services/computation.dart';
import 'package:otter/services/database_provider.dart';
import 'package:provider/provider.dart';

void showBlurredDialog(CompanyModel company, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Dialog(
          backgroundColor: AppColors.primaryDarkBlue,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white10, width: 2),
                    color: AppColors.primaryDarkBlue,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Yearly Performance of',
                        style: TextStyle(
                          color: AppColors.midBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            company.company,
                            style: const TextStyle(
                                color: AppColors.midBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${company.country} (${company.countryCode})",
                            style: TextStyle(
                                color: AppColors.midBlue.withOpacity(0.6),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildPerformanceSection(
                          company, 'Stock Price', 'stockPrice'),
                      _buildPerformanceSection(company, 'Revenue', 'revenue'),
                      _buildPerformanceSection(
                          company, 'Market Share', 'marketShare'),
                      _buildPerformanceSection(company, 'Expenses', 'expenses'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildPerformanceSection(
    CompanyModel company, String title, String type) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      changedByYear(company, type),
      const Divider(color: Colors.white10),
    ],
  );
}

Widget changedByYear(CompanyModel company, String type) {
  return Consumer<FireStoreProvider>(
    builder: (context, dbProvider, child) {
      return FutureBuilder(
        future: CompanyComputation(dbProvider.companyDataList)
            .yearOverYearComparison(company),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Error loading data');
          } else if (!snapshot.hasData || (snapshot.data as Map).isEmpty) {
            return const Text('No data available');
          } else {
            final data = snapshot.data as Map<String, dynamic>;
            return SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data[type].keys.length,
                itemBuilder: (context, index) {
                  final year = data[type].keys.elementAt(index);
                  final change = (data[type][year] ?? 0.0) as double;
                  final isPositive = change >= 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              year,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              isPositive
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: isPositive ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                        Text(
                          '${change.toStringAsFixed(2)}%', // Format percentage change
                          style: TextStyle(
                            color: isPositive ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    },
  );
}
