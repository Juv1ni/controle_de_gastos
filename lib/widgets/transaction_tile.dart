import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel item;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onTap,
  });

  String _brl(double v) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(v);

  @override
  Widget build(BuildContext context) {
    final isIncome = item.isIncome;
    final accent = isIncome ? AppColors.positive : AppColors.negative;
    final icon = isIncome ? Icons.north_east : Icons.south_east;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: accent.withValues(alpha: 0.10),
          ),
          child: Icon(icon, color: accent),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy', 'pt_BR').format(item.date),
          style: const TextStyle(color: AppColors.subtext),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _brl(item.amount),
              style: TextStyle(fontWeight: FontWeight.w900, color: accent),
            ),
            const SizedBox(width: 8),
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
