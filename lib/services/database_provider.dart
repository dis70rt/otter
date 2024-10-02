import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'company_model.dart';

class FireStoreProvider extends ChangeNotifier {
  final CollectionReference _companyCollection =
      FirebaseFirestore.instance.collection("Company");

  final List<CompanyModel> _companyDataList = [];
  bool _isLoading = true;
  DocumentSnapshot? _lastDocument; // Keeps track of the last document in a page
  bool _hasMoreData = true; // Checks if there are more documents to load
  static const int _limit = 10; // Number of documents per page

  List<CompanyModel> get companyDataList => _companyDataList;

  bool get isLoading => _isLoading;

  FireStoreProvider() {
    fetchCompanyData();
  }

  // Fetch the initial page of data
  Future<void> fetchCompanyData() async {
    if (!_hasMoreData) return;

    try {
      Query query = _companyCollection.limit(_limit);
      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        List<CompanyModel> newCompanies = snapshot.docs
            .map((doc) => CompanyModel.fromFirestore(doc))
            .toList();

        _companyDataList.addAll(newCompanies);
        _isLoading = false;
        _hasMoreData = newCompanies.length == _limit;
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching company data: $e");
      _isLoading = false;
      notifyListeners();
    }
  }
}
