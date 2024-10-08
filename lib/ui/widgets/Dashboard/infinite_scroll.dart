import 'dart:async';
import 'package:flutter/material.dart';
import 'package:otter/services/company_model.dart';
import 'package:otter/services/computation.dart';
import 'package:otter/services/database_provider.dart';
import 'package:provider/provider.dart';

class InfiniteScroll extends StatefulWidget {
  const InfiniteScroll({super.key});

  @override
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  final ScrollController scroll = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startAutoScroll();
  }

  @override
  void dispose() {
    scroll.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.offset + 10,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );

        if (scroll.offset >= scroll.position.maxScrollExtent) {
          scroll.jumpTo(scroll.position.minScrollExtent);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: Consumer<FireStoreProvider>(
        builder: (context, dbProvider, child) {
          return ListView.builder(
            controller: scroll,
            scrollDirection: Axis.horizontal,
            itemCount: dbProvider.companyDataList.length,
            itemBuilder: (context, index) {
              CompanyModel company = dbProvider.companyDataList[index];
              return FutureBuilder(
                future: CompanyComputation.yearOverYearComparison(company),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: 100,
                      child: Center(child: Text('Error loading data')),
                    );
                  } else if (!snapshot.hasData ||
                      (snapshot.data as Map).isEmpty) {
                    return const SizedBox(
                      width: 100,
                      child: Center(child: Text('No data available')),
                    );
                  } else {
                    final data = snapshot.data as Map<String, dynamic>;
                    final cmp = company.company;
                    final change = (data['stockPrice']['2024'] ??
                        data['stockPrice']['2023']) as double;
                    final isPositive = change >= 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cmp,
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
                            '${change.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: isPositive ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
