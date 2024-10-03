import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otter/constants/colors.dart';
import 'package:otter/services/auth_provider.dart';
import 'package:otter/services/database_provider.dart';
import 'package:otter/ui/widgets/Dashboard/dashboard_widget.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final authProvider = AuthProvider();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FireStoreProvider>(
      builder: (context, dbProvider, child) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: Colors.white10, width: 2)),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(authProvider.user?.photoURL ??
                    "https://i.imgur.com/WxNkK7J.png"),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
          elevation: 10,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            )
          ],
          centerTitle: true,
          title: const Text(
            "OTTER",
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 4,
                fontWeight: FontWeight.w900),
          ),
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 80),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 12),
                child: Autocomplete<String>(
                  optionsBuilder: (textEditingValue) {
                    return dbProvider.searchHistory;
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    _searchController.text = textEditingController.text;
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: AppColors.primaryDarkBlue,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: TextButton(
                            onPressed: () {},
                            child: TextButton(
                              onPressed: () => dbProvider.clearSearchHistory(),

                              child: const Text("Clear History",
                                  style: TextStyle(
                                      color: AppColors.secondaryDarkBlue,
                                      fontSize: 12)),
                            )),
                        hintText: "Search",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                width: 0, color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                width: 0, color: Colors.transparent)),
                      ),
                      onChanged: (value) {
                        dbProvider.search(value.trim());
                      },
                      onFieldSubmitted: (query) => dbProvider.addToSearchHistory(query),
                    );
                  },
                  onSelected: (String selection) {
                    log("Selected: $selection");
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.primaryDarkBlue
                                      .withOpacity(0.8)),
                              width: 330,
                              height: 250,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);

                                  return ListTile(
                                    onTap: () => onSelected(option),
                                    leading: const Icon(Icons.access_time),
                                    title: Text(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
        ),
        body: const Center(child: DashboardWidget()),
      ),
    );
  }
}
