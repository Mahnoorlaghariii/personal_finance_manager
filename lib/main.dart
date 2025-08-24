import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financemanageapp/firebase_options.dart';
import 'package:financemanageapp/providers/budget_provider.dart';
import 'package:financemanageapp/providers/expense_provider.dart';
import 'package:financemanageapp/providers/goal_provider.dart';
import 'package:financemanageapp/providers/income_provider.dart';
import 'package:financemanageapp/screens/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> resetExpenses() async {
  try {
    final expenses = await FirebaseFirestore.instance.collection("expenses").get();
    for (var doc in expenses.docs) {
      await doc.reference.delete();
    }
    print("✅ All expenses deleted");
  } catch (e) {
    print("⚠️ Error deleting expenses: $e");
  }
}

void main() async {
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
await resetExpenses();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ExpenseProvider()..start()),
ChangeNotifierProvider(create: (_) => IncomeProvider()..start()),
ChangeNotifierProvider(create: (_) => BudgetProvider()..start()),
ChangeNotifierProvider(create: (_) => GoalProvider()..start()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Root(),
    ),);
  }
}

