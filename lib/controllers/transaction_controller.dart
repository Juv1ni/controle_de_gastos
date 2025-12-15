import 'package:controle_de_gastos/services/db_services.dart';
import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionController extends ChangeNotifier {
  final DbService _db = DbService();

  bool isLoading = false;
  List<TransactionModel> items = [];

  double get totalIncome =>
      items.where((e) => e.isIncome).fold(0.0, (s, e) => s + e.amount);

  double get totalExpense =>
      items.where((e) => !e.isIncome).fold(0.0, (s, e) => s + e.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    items = await _db.getAllTransactions();
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(TransactionModel t) async {
    await _db.insertTransaction(t);
    await load();
  }

  Future<void> remove(int id) async {
    await _db.deleteTransaction(id);
    await load();
  }
}
