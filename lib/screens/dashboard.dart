import 'package:financemanageapp/screens/budget_screen.dart';
import 'package:financemanageapp/screens/expense_screen.dart';
import 'package:financemanageapp/screens/goals_screen.dart';
import 'package:financemanageapp/screens/home_screen.dart';
import 'package:financemanageapp/screens/income_Screen.dart';
import 'package:financemanageapp/screens/reports_screens.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int index = 0;
  final pages = const [
    HomeScreen(),
    IncomeScreen(),
    ExpensesScreen(),
    BudgetScreen(),
    GoalsScreen(),
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.black, // 👈 background
          indicatorColor: Colors.white24, // highlight for selected item
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white), // 👈 label color
          ),
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Colors.white), // 👈 icon color
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.trending_up),
              label: 'Income',
            ),
            NavigationDestination(
              icon: Icon(Icons.trending_down),
              label: 'Expenses',
            ),
            NavigationDestination(
              icon: Icon(Icons.savings_outlined),
              label: 'Budget',
            ),
            NavigationDestination(
              icon: Icon(Icons.flag_outlined),
              label: 'Goals',
            ),
          
          ],
        ),
      ),
    );
  }
}
