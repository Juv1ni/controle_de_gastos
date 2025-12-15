import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../core/app_colors.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel item;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.item,
    required this.onDelete,
  });

  String _brl(double v) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(v);

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy').format(item.date);
    final sign = item.isIncome ? '+' : '-';

    return Card(
      child: ListTile(
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(date, style: const TextStyle(color: AppColors.subtext)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$sign ${_brl(item.amount)}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir',
            ),
          ],
        ),
      ),
    );
  }
}
