import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onDeleteExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onDeleteExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            ),
            margin: Theme.of(context).cardTheme.margin,
          ),
          key: ValueKey(expenses[index]),
          onDismissed: (direction) {
            onDeleteExpense(expenses[index]);
          },
          child: ExpenseItem(expenses[index])),
    );
  }
}
