import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: Center(child: const Text("Expense Report"))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("expenses")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No expenses found", style: TextStyle(color: Colors.white),));
          }

          final data = snapshot.data!.docs;
          final Map<String, double> categoryTotals = {};

          for (var doc in data) {
            final docData = doc.data() as Map<String, dynamic>;

            // 🔎 Debug log to check your Firestore fields
            print("📌 Firestore doc: $docData");

            final category = docData["category"]?.toString() ?? "Other";

            // ✅ Safely parse amount even if it's String or num
            final amountRaw = docData["amount"];
            double amount = 0.0;
            if (amountRaw is int) {
              amount = amountRaw.toDouble();
            } else if (amountRaw is double) {
              amount = amountRaw;
            } else if (amountRaw is String) {
              amount = double.tryParse(amountRaw) ?? 0.0;
            }

            if (amount > 0) {
              categoryTotals[category] =
                  (categoryTotals[category] ?? 0) + amount;
            }
          }

          if (categoryTotals.isEmpty) {
            return const Center(child: Text("No valid expense data"));
          }

          final categories = categoryTotals.keys.toList();
          final values = categoryTotals.values.toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 🔹 Summary
                Text(
                  "Total Expenses: ${values.reduce((a, b) => a + b).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Pie Chart
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: List.generate(categories.length, (i) {
                        return PieChartSectionData(
                          value: values[i],
                          title: categories[i],
                          color:
                              Colors.primaries[i % Colors.primaries.length],
                          radius: 70,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
