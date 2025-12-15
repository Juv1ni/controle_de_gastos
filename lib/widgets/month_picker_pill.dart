import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class MonthPickerPill extends StatelessWidget {
  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const MonthPickerPill({
    super.key,
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Mês anterior',
        ),
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.calendar_month_outlined, size: 18),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Próximo mês',
        ),
      ],
    );
  }
}
