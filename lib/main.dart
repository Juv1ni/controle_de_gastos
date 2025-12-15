import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/summary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.add: (_) => const AddTransactionScreen(),
        AppRoutes.summary: (_) => const SummaryScreen(),
      },
    );
  }
}
