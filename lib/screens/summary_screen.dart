import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/transaction_controller.dart';
import '../core/app_colors.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  String _brl(double v) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(v);

  @override
  Widget build(BuildContext context) {
    final ctrl =
        (ModalRoute.of(context)?.settings.arguments is TransactionController)
        ? (ModalRoute.of(context)!.settings.arguments as TransactionController)
        : TransactionController(); // fallback

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo')),
      body: AnimatedBuilder(
        animation: ctrl,
        builder: (_, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ctrl.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Saldo do mês',
                                style: TextStyle(color: AppColors.subtext),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _brl(ctrl.balance),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: _mini(
                                      'Entradas',
                                      _brl(ctrl.totalIncome),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _mini(
                                      'Saídas',
                                      _brl(ctrl.totalExpense),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: ListTile(
                          title: const Text(
                            'Lançamentos',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '${ctrl.items.length} no mês',
                            style: const TextStyle(color: AppColors.subtext),
                          ),
                          trailing: const Icon(Icons.receipt_long_outlined),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _mini(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.subtext)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
