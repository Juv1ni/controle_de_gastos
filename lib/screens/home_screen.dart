import 'package:flutter/material.dart';
import '../controllers/transaction_controller.dart';
import '../core/app_routes.dart';
import '../widgets/money_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gastos'),
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.summary),
                icon: const Icon(Icons.pie_chart_outline),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final created = await Navigator.pushNamed(context, AppRoutes.add);
              if (created == true) controller.load();
            },
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                MoneyCard(
                  balance: controller.balance,
                  income: controller.totalIncome,
                  expense: controller.totalExpense,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.items.isEmpty
                      ? const EmptyState(
                          title: 'Sem lançamentos',
                          subtitle:
                              'Toque no + para adicionar sua primeira entrada ou saída.',
                        )
                      : ListView.separated(
                          itemCount: controller.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final t = controller.items[i];
                            return TransactionTile(
                              item: t,
                              onDelete: () async {
                                if (t.id != null) {
                                  await controller.remove(t.id!);
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
