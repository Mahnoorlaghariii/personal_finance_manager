import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/income_provider.dart';
import '../models/income.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<IncomeProvider>();
    final fmt = NumberFormat.currency(symbol: 'Rs ');

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: Center(child: const Text('Income')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDialog(context),
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      body: p.items.isEmpty
          ? const Center(child: Text('No income yet'))
          : ListView.builder(
              itemCount: p.items.length,
              itemBuilder: (c, i) {
                final e = p.items[i];
                final color = Colors.green.shade700;
                return Dismissible(
                  key: ValueKey(e.id),
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 24),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) =>
                      context.read<IncomeProvider>().delete(e.id),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 192, 188, 188),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      tileColor: Colors.grey,
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(.15),
                        child: Icon(Icons.north_east, color: color),
                      ),
                      title: Text(e.source),
                      subtitle: Text(DateFormat.yMMMd().format(e.date)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+ ${fmt.format(e.amount)}',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openDialog(context, existing: e),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

Future<void> _openDialog(BuildContext context, {Income? existing}) async {
  final formKey = GlobalKey<FormState>();
  String source = existing?.source ?? 'Salary';
  final sources = ['Salary', 'Freelance', 'Business', 'Gift', 'Other'];
  final amountCtrl = TextEditingController(
    text: existing?.amount.toString() ?? '',
  );
  DateTime date = existing?.date ?? DateTime.now();

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(existing == null ? 'Add Income' : 'Edit Income'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: source,
              items: sources
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => source = v!,
              decoration: const InputDecoration(labelText: 'Source'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (v) =>
                  (double.tryParse(v ?? '') == null) ? 'Enter number' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text('Date: ${DateFormat.yMMMd().format(date)}'),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      initialDate: date,
                    );
                    if (picked != null) {
                      date = picked;
                      (context as Element).markNeedsBuild();
                    }
                  },
                  child: const Text('Pick Date'),
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
            final amount = double.parse(amountCtrl.text);
            final p = context.read<IncomeProvider>();
            if (existing == null) {
              await p.add(source: source, amount: amount, date: date);
            } else {
              await p.update(
                Income(
                  id: existing.id,
                  source: source,
                  amount: amount,
                  date: date,
                ),
              );
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(existing == null ? 'Save' : 'Update'),
        ),
      ],
    ),
  );
}
