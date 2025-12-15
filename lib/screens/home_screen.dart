import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../controllers/transaction_controller.dart';
import '../core/app_routes.dart';
import '../models/transaction_model.dart';
import '../widgets/money_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/month_picker_pill.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TransactionController();

  bool _showSwipeHint = true;

  @override
  void initState() {
    super.initState();
    controller.load();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showSwipeHint = false);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _monthLabel(DateTime m) => DateFormat('MMMM yyyy', 'pt_BR').format(m);

  Widget _swipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(Icons.delete_outline, color: Colors.red),
          SizedBox(width: 8),
          Text(
            'Excluir',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(TransactionModel t) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir lançamento?'),
        content: Text('Deseja excluir "${t.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Future<void> _openForm({TransactionModel? edit}) async {
    final saved = await Navigator.pushNamed(
      context,
      AppRoutes.add,
      arguments: {'controller': controller, 'edit': edit},
    );
    if (saved == true) controller.load();
  }

  void _showUndoSnack(TransactionModel deleted) {
    // fecha qualquer snackbar anterior (pra não empilhar)
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lançamento excluído'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () async {
            // ✅ recria o lançamento (sem id)
            await controller.add(
              TransactionModel(
                title: deleted.title,
                amount: deleted.amount,
                isIncome: deleted.isIncome,
                date: deleted.date,
              ),
            );
            HapticFeedback.lightImpact();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Controle de gastos'),
            actions: [
              IconButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.summary,
                  arguments: controller,
                ),
                icon: const Icon(Icons.pie_chart_outline),
                tooltip: 'Resumo',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _openForm();
            },
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  MonthPickerPill(
                    label: _monthLabel(controller.currentMonth),
                    onPrev: controller.isLoading ? () {} : controller.prevMonth,
                    onNext: controller.isLoading ? () {} : controller.nextMonth,
                  ),
                  const SizedBox(height: 12),

                  // ✅ saldo anima automaticamente (MoneyCard)
                  MoneyCard(
                    balance: controller.balance,
                    income: controller.totalIncome,
                    expense: controller.totalExpense,
                  ),
                  const SizedBox(height: 12),

                  if (_showSwipeHint && controller.items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.swipe_left, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text(
                            'Arraste um item para excluir',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : controller.items.isEmpty
                        ? const EmptyState(
                            title: 'Sem lançamentos',
                            subtitle:
                                'Toque no + para adicionar uma entrada ou saída.',
                            icon: Icons.receipt_long_outlined,
                          )
                        : ListView.separated(
                            itemCount: controller.items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final t = controller.items[i];

                              return Dismissible(
                                key: ValueKey(
                                  t.id ??
                                      '${t.title}-${t.date.millisecondsSinceEpoch}',
                                ),
                                direction: DismissDirection.endToStart,
                                background: _swipeBackground(),
                                confirmDismiss: (_) => _confirmDelete(t),
                                onDismissed: (_) async {
                                  if (t.id == null) return;

                                  final deleted = t;

                                  HapticFeedback.mediumImpact();
                                  await controller.remove(t.id!);

                                  // ✅ UNDO
                                  _showUndoSnack(deleted);
                                },
                                child: TransactionTile(
                                  item: t,
                                  onTap: () => _openForm(edit: t),
                                  onDelete: () async {
                                    final ok = await _confirmDelete(t);
                                    if (ok == true && t.id != null) {
                                      final deleted = t;
                                      HapticFeedback.mediumImpact();
                                      await controller.remove(t.id!);
                                      _showUndoSnack(deleted);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
