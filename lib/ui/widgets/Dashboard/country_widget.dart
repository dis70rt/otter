import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lists.dart';
import '../../../services/computation.dart';

class CountryCardWidget extends StatefulWidget {
  const CountryCardWidget({super.key});

  @override
  State<CountryCardWidget> createState() => _CountryCardWidgetState();
}

class _CountryCardWidgetState extends State<CountryCardWidget> {
  String? selectedCountry;
  final companyComputation = CompanyComputation();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondaryDarkBlue, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Total Companies in Country",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF7373ff)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCountry ?? "Select Country",
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.15,
                        color: Color(0xFF111184),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF111184),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Companies",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                  ),
                ),
                Text(
                  selectedCountry != null
                      ? companyComputation
                          .companiesInSameCountry(selectedCountry!)
                          .length
                          .toString()
                      : "0",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedCountry != null
                    ? companyComputation
                        .companiesInSameCountry(selectedCountry!)
                        .length
                    : 0,
                itemBuilder: (context, index) {
                  final company = companyComputation
                      .companiesInSameCountry(selectedCountry!)[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: AppColors.midDarkBlue),
                      child: Center(
                        child: Text(
                          company.company,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.primaryDarkBlue.withOpacity(0.5),
              ),
              height: 250,
              child: Column(
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text(
                        "Select a Country",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      // backgroundColor: AppColors.primaryDarkBlue,
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedCountry != null
                            ? countries.indexOf(selectedCountry!)
                            : 0,
                      ),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          selectedCountry = countries[index];
                        });
                      },
                      children:
                          List<Widget>.generate(countries.length, (int index) {
                        return Center(
                          child: Text(
                            countries[index],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
