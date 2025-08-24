import 'dart:async';
import 'package:financemanageapp/models/goals.dart';
import 'package:flutter/material.dart';

import '../services/firestore_paths.dart';


class GoalProvider extends ChangeNotifier {
List<Goal> _items = [];
StreamSubscription? _sub;


List<Goal> get items => _items;


void start() {
_sub?.cancel();
_sub = FP.goals().orderBy('title').snapshots().listen((snap) {
_items = snap.docs.map((d) => Goal.fromMap(d.id, d.data())).toList();
notifyListeners();
});
}


Future<void> add({required String title, required double targetAmount}) async {
await FP.goals().add({'title': title, 'targetAmount': targetAmount, 'savedAmount': 0.0});
}


Future<void> update(Goal g) async => FP.goals().doc(g.id).update(g.toMap());
Future<void> delete(String id) async => FP.goals().doc(id).delete();


Future<void> addProgress(String id, double add) async {
final g = _items.firstWhere((e) => e.id == id);
g.savedAmount += add;
await update(g);
}


@override
void dispose() {
_sub?.cancel();
super.dispose();
}
}