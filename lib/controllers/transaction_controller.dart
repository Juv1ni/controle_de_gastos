import 'package:controle_de_gastos/services/db_services.dart';
import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionController extends ChangeNotifier {
  final DbService _db = DbService();

  bool isLoading = false;
  List<TransactionModel> items = [];

  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  double get totalIncome =>
      items.where((e) => e.isIncome).fold(0.0, (s, e) => s + e.amount);

  double get totalExpense =>
      items.where((e) => !e.isIncome).fold(0.0, (s, e) => s + e.amount);

  double get balance => totalIncome - totalExpense;

  int get _startMs =>
      DateTime(currentMonth.year, currentMonth.month, 1).millisecondsSinceEpoch;

  int get _endMs => DateTime(
    currentMonth.year,
    currentMonth.month + 1,
    1,
  ).millisecondsSinceEpoch;

  Future<void> load() async => loadForMonth(currentMonth);

  Future<void> loadForMonth(DateTime month) async {
    currentMonth = DateTime(month.year, month.month);
    isLoading = true;
    notifyListeners();

    items = await _db.getTransactionsBetween(_startMs, _endMs);

    isLoading = false;
    notifyListeners();
  }

  Future<void> prevMonth() async {
    final m = DateTime(currentMonth.year, currentMonth.month - 1);
    await loadForMonth(m);
  }

  Future<void> nextMonth() async {
    final m = DateTime(currentMonth.year, currentMonth.month + 1);
    await loadForMonth(m);
  }

  Future<void> add(TransactionModel t) async {
    await _db.insertTransaction(t);
    await load();
  }

  Future<void> update(TransactionModel t) async {
    await _db.updateTransaction(t);
    await load();
  }

  Future<void> remove(int id) async {
    await _db.deleteTransaction(id);
    await load();
  }
}
