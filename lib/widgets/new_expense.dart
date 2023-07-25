import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.onAddExpense, {super.key});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  DateTime _selectedDate = DateTime.now();

  void _showCalender() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(
          now.year - 1,
          now.month,
          now.day,
        ),
        lastDate: now);
    setState(() {
      if (pickedDate != null) {
        _selectedDate = pickedDate;
      }
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty || amountIsInvalid) {
      showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: const Text('INVALID INPUT'),
              content: const Text(
                  "Please make sure that a valid input has been entered correctly"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("Okay!"))
              ],
            )),
      );
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate,
        category: _selectedCategory));
    Navigator.pop(context);
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final deviceWidth = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        width: deviceWidth < 600 ? double.infinity : deviceWidth - 40,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                deviceWidth < 400
                    ? TextField(
                        controller: _titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(label: Text("Title")),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _titleController,
                              maxLength: 50,
                              decoration:
                                  const InputDecoration(label: Text("Title")),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  label: Text("Amount"), prefixText: "\$"),
                            ),
                          ),
                        ],
                      ),
                if (deviceWidth < 400)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              label: Text("Amount"), prefixText: "\$"),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(formatter.format(_selectedDate)),
                            IconButton(
                                onPressed: _showCalender,
                                icon: const Icon(Icons.calendar_month))
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownButton(
                                value: _selectedCategory,
                                items: Category.values
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name.toUpperCase())))
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              formatter.format(_selectedDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                                onPressed: _showCalender,
                                icon: const Icon(Icons.calendar_month)),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: _submitExpenseData,
                              child: const Text("Save Expense"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (deviceWidth < 400)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Save Expense"),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
