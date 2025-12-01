import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TransactionProvider extends ChangeNotifier {
  List<dynamic> _transactions = [];
  
  List<dynamic> get transactions => _transactions;

  double get totalBalance {
    // Mock calculation
    return 1250.50; 
  }

  void addTransaction(dynamic transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    // Load from Hive later
    notifyListeners();
  }
}
