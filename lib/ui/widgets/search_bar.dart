import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../services/database_provider.dart';

Widget buildSearchBar(FireStoreProvider dbProvider) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    child: Autocomplete<String>(
      optionsBuilder: (textEditingValue) => dbProvider.searchHistory,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return SizedBox(
          height: 48,
          child: TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: AppColors.primaryDarkBlue,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: TextButton(
                onPressed: () => dbProvider.clearSearchHistory(),
                style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                child: const Text("Clear History",
                    style: TextStyle(
                        color: AppColors.secondaryDarkBlue, fontSize: 12)),
              ),
              hintText: "Search",
              enabledBorder: _inputBorder(),
              focusedBorder: _inputBorder(),
            ),
            onChanged: (value) => dbProvider.search(value.trim()),
            onFieldSubmitted: (query) => dbProvider.addToSearchHistory(query),
          ),
        );
      },
      onSelected: (String selection) => log("Selected: $selection"),
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
                    color: AppColors.primaryDarkBlue.withOpacity(0.8),
                  ),
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
  );
}

OutlineInputBorder _inputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(width: 0, color: Colors.transparent),
  );
}
