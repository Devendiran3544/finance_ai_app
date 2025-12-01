import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  Box<Transaction>? _box;

  List<Transaction> get transactions => _transactions;

  double get totalBalance {
    return _transactions.fold(0, (sum, item) => item.isExpense ? sum - item.amount : sum + item.amount);
  }

  double get totalIncome {
    return _transactions.where((item) => !item.isExpense).fold(0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return _transactions.where((item) => item.isExpense).fold(0, (sum, item) => sum + item.amount);
  }

  // Currency Formatter for INR
  String formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    return format.format(amount);
  }

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
    }
    _box = await Hive.openBox<Transaction>('transactions');
    _transactions = _box!.values.toList();
    _transactions.sort((a, b) => b.date.compareTo(a.date)); // Newest first
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _box?.add(transaction);
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    await transaction.delete();
    _transactions.remove(transaction);
    notifyListeners();
  }
}
