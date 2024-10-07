import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/services/company_model.dart';
import 'package:otter/services/computation.dart';
import 'package:otter/ui/widgets/Dashboard/bar_graph.dart';
import 'package:otter/ui/widgets/Dashboard/country_widget.dart';
import 'package:otter/ui/widgets/Dashboard/infinite_scroll.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final computation = CompanyComputation();
  ValueNotifier<CompanyModel?> selectedCompany =
      ValueNotifier<CompanyModel?>(null);
  List<CompanyModel>? companies;
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (companies != null && companies!.isNotEmpty) {
        selectedCompany.value = companies![currentIndex];
        currentIndex = (currentIndex + 1) %
            (companies!.length > 3 ? 3 : companies!.length);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    selectedCompany.dispose();
    super.dispose();
  }

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
              future: computation.getTopPerformingCompanies(topCount: 5),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error loading data"));
                } else if (snapshot.hasData) {
                  companies = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        children: List.generate(
                          companies!.length > 3 ? 3 : companies!.length,
                          (index) {
                            return ValueListenableBuilder<CompanyModel?>(
                              valueListenable: selectedCompany,
                              builder: (context, selected, child) {
                                return Chip(
                                  side: const BorderSide(color: Colors.black),
                                  shape: const StadiumBorder(),
                                  label: Text(
                                    companies![index].company,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: selected == companies![index]
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  backgroundColor: selected == companies![index]
                                      ? AppColors.secondaryDarkBlue
                                      : AppColors.midBlue,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<CompanyModel?>(
                        valueListenable: selectedCompany,
                        builder: (context, selected, child) {
                          if (selected != null) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: barChart(selected.stockPrices),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const Center(
                          child: Text(
                        "Stock Price",
                        style: TextStyle(fontSize: 10),
                      )),
                      const Divider(color: Colors.white10),
                      const InfiniteScroll(),
                    ],
                  );
                } else {
                  return const Center(child: Text("No data available"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
