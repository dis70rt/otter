import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/database_provider.dart';
import 'expanded_card.dart';

class CompanyWidget extends StatefulWidget {
  const CompanyWidget({super.key});

  @override
  State<CompanyWidget> createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FireStoreProvider>(
      builder: (context, docsProvider, child) {
        if (docsProvider.isLoading && docsProvider.companyDataList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = docsProvider.companyDataList;
        return ListView.builder(
          itemCount: data.length + (docsProvider.isLoading ? 1 : 0),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index < data.length) {
              return ExpandableCompanyCard(data: data[index]);
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
          controller: _scrollController(docsProvider),
        );
      },
    );
  }

  ScrollController _scrollController(FireStoreProvider docsProvider) {
    final controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent &&
          !docsProvider.isLoading) {
        docsProvider.fetchCompanyData();
      }
    });
    return controller;
  }
}
