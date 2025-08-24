import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/income_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/kv_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final income = context.watch<IncomeProvider>().totalIncome;
    final expenseProvider = context.watch<ExpenseProvider>();
    final expense = expenseProvider.totalExpense;
    final budget = context.watch<BudgetProvider>().budget;
    final fmt = NumberFormat.currency(symbol: 'Rs ');

    final balance = income - expense;
    final spentVsLimit = (budget == null || budget.monthlyLimit == 0)
        ? 0.0
        : (expense / budget.monthlyLimit).clamp(0, 1).toDouble();

    // ✅ Group expenses by category
    final Map<String, double> categoryTotals = {};
    for (var e in expenseProvider.items) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0) + e.amount;
    }

    // ✅ Assign colors to categories
    final categoryColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
    ];

    final pieSections = categoryTotals.entries.map((entry) {
      final index = categoryTotals.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        color: categoryColors[index % categoryColors.length],
        value: entry.value,
        title: '${entry.key}\n${fmt.format(entry.value)}',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: const Center(child: Text('Home')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          CustomCard(
            child: KVRow(label: 'Balance', value: fmt.format(balance)),
          ),
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  child: KVRow(label: 'Income', value: fmt.format(income)),
                ),
              ),
              Expanded(
                child: CustomCard(
                  child: KVRow(label: 'Expense', value: fmt.format(expense)),
                ),
              ),
            ],
          ),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Month',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: spentVsLimit),
                const SizedBox(height: 8),
                Text(
                  budget == null
                      ? 'No budget set'
                      : 'Spent ${fmt.format(expense)} of ${fmt.format(budget.monthlyLimit)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ✅ Pie Chart Section
          CustomCard(
            child: Column(
              children: [
                Text(
                  'Expenses by Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: pieSections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
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
