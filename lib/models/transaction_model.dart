class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final bool isIncome; // true = entrada, false = saída
  final DateTime date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
  });

  TransactionModel copyWith({
    int? id,
    String? title,
    double? amount,
    bool? isIncome,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'isIncome': isIncome ? 1 : 0,
    'date': date.millisecondsSinceEpoch,
  };

  static TransactionModel fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      isIncome: (map['isIncome'] as int) == 1,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
}
