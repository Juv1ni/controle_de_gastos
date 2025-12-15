import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';

class MoneyCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const MoneyCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  String _brl(double v) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(v);

  @override
  Widget build(BuildContext context) {
    final isPositive = balance >= 0;
    final balColor = isPositive ? AppColors.text : AppColors.negative;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saldo', style: TextStyle(color: AppColors.subtext)),
            const SizedBox(height: 6),

            // ✅ animação no saldo
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) {
                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.12),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                );
              },
              child: Text(
                _brl(balance),
                key: ValueKey(balance.toStringAsFixed(2)),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: balColor,
                  height: 1.0,
                ),
              ),
            ),

            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _pill(
                    icon: Icons.north_east,
                    label: 'Entradas',
                    value: _brl(income),
                    valueKey: income,
                    accent: AppColors.positive,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _pill(
                    icon: Icons.south_east,
                    label: 'Saídas',
                    value: _brl(expense),
                    valueKey: expense,
                    accent: AppColors.negative,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill({
    required IconData icon,
    required String label,
    required String value,
    required double valueKey,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: accent.withValues(alpha: 0.10),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.subtext)),
                const SizedBox(height: 2),

                // ✅ animação nas cápsulas também
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    value,
                    key: ValueKey(valueKey.toStringAsFixed(2)),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
