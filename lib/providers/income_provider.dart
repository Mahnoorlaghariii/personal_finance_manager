import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/income.dart';
import '../services/firestore_paths.dart';


class IncomeProvider extends ChangeNotifier {
List<Income> _items = [];
StreamSubscription? _sub;


List<Income> get items => _items;
double get totalIncome => _items.fold(0.0, (s, e) => s + e.amount);


void start() {
_sub?.cancel();
_sub = FP.income().orderBy('date', descending: true).snapshots().listen((snap) {
_items = snap.docs.map((d) => Income.fromMap(d.id, d.data())).toList();
notifyListeners();
});
}


Future<void> add({required String source, required double amount, required DateTime date}) async {
await FP.income().add({'source': source, 'amount': amount, 'date': date.toIso8601String()});
}


Future<void> update(Income i) async {
await FP.income().doc(i.id).update(i.toMap());
}


Future<void> delete(String id) async {
await FP.income().doc(id).delete();
}


@override
void dispose() {
_sub?.cancel();
super.dispose();
}
}