import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/services/company_model.dart';
import 'package:otter/services/computation.dart';
import 'package:otter/ui/widgets/Dashboard/country_widget.dart';
import 'package:otter/ui/widgets/Dashboard/infinite_scroll.dart';

import '../widgets/Dashboard/dashboard_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final computation = CompanyComputation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CountryCardWidget(),
            const SizedBox(height: 8),
            const Divider(color: Colors.white12),
            const Text(
              "Top Performing Companies",
              style: TextStyle(
                  color: AppColors.midBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            FutureBuilder<List<CompanyModel>>(
              future: CompanyComputation.getTopPerformingCompanies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error loading data"));
                } else if (snapshot.hasData) {
                  return CompanyChipsAndBarGraph(companies: snapshot.data!);
                } else {
                  return const Center(child: Text("No data available"));
                }
              },
            ),
            const Divider(color: Colors.white10),
            const InfiniteScroll(),
          ],
        ),
      ),
    );
  }
}
