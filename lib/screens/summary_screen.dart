import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../core/app_colors.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final controller = TransactionController();

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _brl(double v) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(v);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Resumo')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: controller.isLoading
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
                                'Saldo',
                                style: TextStyle(color: AppColors.subtext),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _brl(controller.balance),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: _mini(
                                      'Entradas',
                                      _brl(controller.totalIncome),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _mini(
                                      'Saídas',
                                      _brl(controller.totalExpense),
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
                          title: const Text('Lançamentos'),
                          subtitle: Text(
                            '${controller.items.length} no total • '
                            '${controller.items.where((e) => e.isIncome).length} entradas • '
                            '${controller.items.where((e) => !e.isIncome).length} saídas',
                            style: const TextStyle(color: AppColors.subtext),
                          ),
                          trailing: const Icon(Icons.receipt_long),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _mini(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.subtext)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
