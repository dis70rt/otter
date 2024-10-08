import 'dart:async';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../services/company_model.dart';
import 'bar_graph.dart';

class CompanyChipsAndBarGraph extends StatefulWidget {
  final List<CompanyModel> companies;

  const CompanyChipsAndBarGraph({required this.companies, super.key});

  @override
  State<CompanyChipsAndBarGraph> createState() =>
      _CompanyChipsAndBarGraphState();
}

class _CompanyChipsAndBarGraphState extends State<CompanyChipsAndBarGraph> {
  ValueNotifier<CompanyModel?> selectedCompany =
      ValueNotifier<CompanyModel?>(null);
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (widget.companies.isNotEmpty) {
      selectedCompany.value = widget.companies.first;
    }

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.companies.isNotEmpty) {
        selectedCompany.value = widget.companies[currentIndex];
        currentIndex = (currentIndex + 1) %
            (widget.companies.length > 3 ? 3 : widget.companies.length);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: List.generate(
            widget.companies.length > 3 ? 3 : widget.companies.length,
            (index) {
              return ValueListenableBuilder<CompanyModel?>(
                valueListenable: selectedCompany,
                builder: (context, selected, child) {
                  return Chip(
                    side: const BorderSide(color: Colors.black),
                    shape: const StadiumBorder(),
                    label: Text(
                      widget.companies[index].company,
                      style: TextStyle(
                        fontSize: 12,
                        color: selected == widget.companies[index]
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    backgroundColor: selected == widget.companies[index]
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
      ],
    );
  }
}
