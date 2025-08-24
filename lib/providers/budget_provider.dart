import 'dart:async';
import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../services/firestore_paths.dart';


class BudgetProvider extends ChangeNotifier {
Budget? _budget;
StreamSubscription? _sub;


Budget? get budget => _budget;


void start() {
_sub?.cancel();
_sub = FP.budgetDoc().snapshots().listen((doc) {
if (doc.exists) {
_budget = Budget.fromMap(doc.data()!);
} else {
_budget = null;
}
notifyListeners();
});
}


Future<void> setBudget({required double monthlyLimit, required DateTime month}) async {
final b = Budget(monthlyLimit: monthlyLimit, month: DateTime(month.year, month.month));
await FP.budgetDoc().set(b.toMap());
}


@override
void dispose() {
_sub?.cancel();
super.dispose();
}
}