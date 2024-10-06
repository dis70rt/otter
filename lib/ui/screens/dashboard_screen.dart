import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/services/computation.dart';
import 'package:otter/services/database_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/lists.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<FireStoreProvider>(
        builder: (context, dbProvider, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [buildCard(dbProvider.companyDataList)],
        ),
      ),
    );
  }

  Widget buildCard(companyData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
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
                      color: Color(0xFF7373ff)),
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
                // mainAxisSize: MainAxisSize.min,
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
                        ? CompanyComputation(companyData)
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
              const SizedBox(height: 10), // Add some spacing
              SizedBox(
                height: 30, // Constrain height for ListView.builder
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedCountry != null
                      ? CompanyComputation(companyData)
                          .companiesInSameCountry(selectedCountry!)
                          .length
                      : 0,
                  itemBuilder: (context, index) {
                    final company = CompanyComputation(companyData)
                        .companiesInSameCountry(selectedCountry!)[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: AppColors.midDarkBlue
                        ),
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
      ),
    );
  }

  void _showCountryPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.primaryDarkBlue,
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
                  backgroundColor: AppColors.primaryDarkBlue,
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
        );
      },
    );
  }
}
