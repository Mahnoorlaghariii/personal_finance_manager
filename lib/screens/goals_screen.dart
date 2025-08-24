import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/goal_provider.dart';
import '../models/goals.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GoalProvider>();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(title: Center(child: const Text('Goals')),backgroundColor: Colors.black87, foregroundColor: Colors.white,),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openGoalDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: p.items.isEmpty
          ? const Center(child: Text('No goals yet'))
          : ListView.builder(
              itemCount: p.items.length,
              itemBuilder: (c, i) {
                final g = p.items[i];
                final ratio = (g.savedAmount / g.targetAmount).clamp(0, 1).toDouble();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              g.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text('${(ratio * 100).toStringAsFixed(0)}%'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: ratio),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Saved: ${g.savedAmount.toStringAsFixed(0)} / ${g.targetAmount.toStringAsFixed(0)}',
                              ),
                            ),
                            IconButton(
                              onPressed: () => _addToGoalDialog(context, g),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            IconButton(
                              onPressed: () =>
                                  context.read<GoalProvider>().delete(g.id),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _openGoalDialog(context, existing: g),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

Future<void> _openGoalDialog(BuildContext context, {Goal? existing}) async {
  final formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final targetCtrl = TextEditingController(
    text: existing?.targetAmount.toString() ?? '',
  );
  final p = context.read<GoalProvider>();

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(existing == null ? 'Add Goal' : 'Edit Goal'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: targetCtrl,
              decoration: const InputDecoration(labelText: 'Target Amount'),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  (double.tryParse(v ?? '') == null) ? 'Enter number' : null,
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
            final title = titleCtrl.text.trim();
            final target = double.parse(targetCtrl.text);
            if (existing == null) {
              await p.add(title: title, targetAmount: target);
            } else {
              await p.update(
                Goal(
                  id: existing.id,
                  title: title,
                  targetAmount: target,
                  savedAmount: existing.savedAmount,
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

Future<void> _addToGoalDialog(BuildContext context, Goal g) async {
  final ctrl = TextEditingController();
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Add to ${g.title}'),
      content: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Amount'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            final v = double.tryParse(ctrl.text);
            if (v != null) {
              await context.read<GoalProvider>().addProgress(g.id, v);
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
