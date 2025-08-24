import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<BudgetProvider>();
    final fmt = NumberFormat.currency(symbol: 'Rs ');

    return Scaffold(
      backgroundColor: Colors.black87,
      
      appBar: AppBar(title: Center(
        child: const 
        Text('Budget'),
      
      ),
      foregroundColor: Colors.white,
      backgroundColor: Colors.black87,),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDialog(context, p),
        label: const Text('Set Budget'),
        icon: const Icon(Icons.add),
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: p.budget == null
            ? const Center(child: Text('No budget set'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Month: ${DateFormat.yMMM().format(p.budget!.month)}',
                    style: TextStyle(color: Colors.white),
                    
                  ),
                  const SizedBox(height: 8),
                  Text('Monthly Limit: ${fmt.format(p.budget!.monthlyLimit)}', style: TextStyle(color: Colors.white),),
                ],
              ),
      ),
    );
  }
}

Future<void> _openDialog(BuildContext context, BudgetProvider p) async {
  final formKey = GlobalKey<FormState>();
  final amountCtrl = TextEditingController(
    text: p.budget?.monthlyLimit.toString() ?? '',
  );
  DateTime month =
      p.budget?.month ?? DateTime(DateTime.now().year, DateTime.now().month);

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Set Monthly Budget'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly Limit'),
              validator: (v) =>
                  (double.tryParse(v ?? '') == null) ? 'Enter number' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text('Month: ${DateFormat.yMMM().format(month)}'),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: month,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      month = DateTime(picked.year, picked.month);
                      (context as Element).markNeedsBuild();
                    }
                  },
                  child: const Text('Pick Month'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            await p.setBudget(
              monthlyLimit: double.parse(amountCtrl.text),
              month: month,
            );
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
