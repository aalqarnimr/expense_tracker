import 'package:expense_tracker/my_app.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
  ];
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  _openAddExpenseOverlay() {
    showModalBottomSheet(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(_addExpense));
  }

  void _deleteExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text("Expense deleted."),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  Icon setChangeThemeIcon() {
    final currentTheme = Theme.of(context).brightness;
    if (currentTheme == Brightness.light) {
      return const Icon(Icons.wb_sunny);
    } else {
      return const Icon(Icons.nightlight_round);
    }
  }

  void changeAppTheme() {
    setState(() {
      final currentTheme = Theme.of(context).brightness;
      if (currentTheme == Brightness.light) {
        MyApp.of(context).changeTheme(ThemeMode.dark);
      } else {
        MyApp.of(context).changeTheme(ThemeMode.light);
      }
    });
  }

  @override
  Widget build(context) {
    print(Theme.of(context).brightness);
    final width = MediaQuery.of(context).size.width;
    Widget mainContent =
        const Center(child: Text('no expenses found. start adding some!'));
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onDeleteExpense: _deleteExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("ExpenseTracker App"),
        actions: [
          IconButton(onPressed: changeAppTheme, icon: setChangeThemeIcon()),
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent)
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent)
              ],
            ),
    );
  }
}
