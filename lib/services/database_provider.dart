import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'company_model.dart';

class FireStoreProvider extends ChangeNotifier {
  final CollectionReference _companyCollection =
      FirebaseFirestore.instance.collection("Company");

  final List<CompanyModel> _companyDataList = [];
  bool _isLoading = true;

  List<CompanyModel> get companyDataList => _companyDataList;
  bool get isLoading => _isLoading;

  List<String> _searchHistory = [];
  List<String> get searchHistory => _searchHistory;

  FireStoreProvider() {
    _loadCachedCompanyData();
    _loadSearchHistory();
  }

  Future<void> _loadCachedCompanyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('companyData');

    if (cachedData != null) {
      List<dynamic> cachedList = jsonDecode(cachedData);
      _companyDataList.addAll(
        cachedList.map((json) => CompanyModel.fromJson(json)).toList(),
      );
      _isLoading = false;
      notifyListeners();
    } else {
      await fetchCompanyData();  // Fetch from Firestore if cache is empty
    }
  }

  Future<void> fetchCompanyData() async {
    _isLoading = true; // Set loading state
    notifyListeners(); // Notify listeners to show loading state

    try {
      QuerySnapshot snapshot = await _companyCollection.get(); // Fetch all data

      if (snapshot.docs.isNotEmpty) {
        List<CompanyModel> newCompanies = snapshot.docs
            .map((doc) => CompanyModel.fromFirestore(doc))
            .toList();

        _companyDataList.clear(); // Clear previous data
        _companyDataList.addAll(newCompanies);
        _isLoading = false;

        await _cacheCompanyData(); // Cache the fetched data
        notifyListeners(); // Notify listeners with new data
      }
    } catch (e) {
      log("Error fetching company data: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cacheCompanyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData =
        jsonEncode(_companyDataList.map((e) => e.toJson()).toList());
    await prefs.setString('companyData', encodedData);
  }

  Future<void> search(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot;

      if (query.isEmpty) {
        snapshot = await _companyCollection.get();
      } else {
        query = query[0].toUpperCase() + query.substring(1).toLowerCase();
        Query searchQuery = _companyCollection
            .where('Company', isGreaterThanOrEqualTo: query)
            .where('Company', isLessThanOrEqualTo: '$query\uf8ff');
        snapshot = await searchQuery.get();
      }
      _companyDataList.clear();
      List<CompanyModel> newCompanies =
          snapshot.docs.map((doc) => CompanyModel.fromFirestore(doc)).toList();

      _companyDataList.addAll(newCompanies);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log("Error searching company data: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _searchHistory = prefs.getStringList('searchHistory') ?? [];
    notifyListeners();
  }

  Future<void> addToSearchHistory(String query) async {
    if (!_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('searchHistory', _searchHistory);
      notifyListeners();
    }
  }

  Future<void> clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    _searchHistory.clear();
    notifyListeners();
  }

  Future<void> refreshCompanyData() async {
    _companyDataList.clear();
    await fetchCompanyData(); // Refetch company data from Firestore
  }
}
