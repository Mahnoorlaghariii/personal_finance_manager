import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';
import '../services/firestore_paths.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _items = [];
  StreamSubscription? _sub;

  List<Expense> get items => _items;
  double get totalExpense => _items.fold(0.0, (s, e) => s + e.amount);

  void start() {
    _sub?.cancel();
    _sub = FP.expenses().orderBy('date', descending: true).snapshots().listen((
      snap,
    ) {
      _items = snap.docs.map((d) => Expense.fromMap(d.id, d.data())).toList();
      notifyListeners();
    });
  }

  Future<void> add({
    required String category,
    required double amount,
    required DateTime date,
  }) async {
    await FP.expenses().add({
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    });
  }

  Future<void> update(Expense e) async {
    await FP.expenses().doc(e.id).update(e.toMap());
  }

  Future<void> delete(String id) async {
    await FP.expenses().doc(id).delete();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
