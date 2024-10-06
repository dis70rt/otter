import 'package:flutter/material.dart';
import 'package:otter/services/computation.dart';
import 'package:otter/services/database_provider.dart';
import 'package:otter/ui/widgets/Company/additional_widgets.dart';
import 'package:provider/provider.dart';

import '../../../services/company_model.dart';
import 'stock_price_linegraph.dart';

class ExpandableCompanyCard extends StatefulWidget {
  final CompanyModel data;
  const ExpandableCompanyCard({super.key, required this.data});

  @override
  State<ExpandableCompanyCard> createState() => _ExpandableCompanyCardState();
}

class _ExpandableCompanyCardState extends State<ExpandableCompanyCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.data.country.toUpperCase()} (${widget.data.countryCode})",
                          style: const TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.data.company,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "DIVERSITY: ${widget.data.diversity}%",
                          style: const TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "STOCK PRICE",
                          style: TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        stockPriceLineChart(widget.data),
                        const SizedBox(height: 10),
                        Text(
                          "MCAP: \$${formatMarketCap(widget.data.marketCap)}",
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
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Other Greater Divesity\nCompanies in ${widget.data.country}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: SizedBox(
                            width: 10,
                            height: 30,
                            child: Consumer<FireStoreProvider>(
                                builder: (context, dbProvider, child) {
                              final computeData = CompanyComputation(
                                      dbProvider.companyDataList)
                                  .greaterDiversityInSameCountry(widget.data);
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: computeData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 2, vertical: 2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.lightBlueAccent),
                                        borderRadius: BorderRadius.circular(60),
                                        // color: AppColors.midDarkBlue,
                                      ),
                                      child: Center(
                                        child: Text(
                                          computeData[index].company,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 5),
                    Graphs(company: widget.data)
                  ],
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
