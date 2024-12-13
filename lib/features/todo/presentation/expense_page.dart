import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_shared_preferences/features/todo/data/model/expense_model.dart';
import 'package:todo_with_shared_preferences/features/todo/presentation/provider/expense_provider.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  void initState() {
    super.initState();
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.getExpenses();
    // expenseProvider.calculateAmout();
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text(
                "Total Amount",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                expenseProvider.totalAmount.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 18,
                  color: expenseProvider.totalAmount >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, expProvider, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: expProvider.expenseList.length,
                    itemBuilder: (context, index) {
                      final exp = expProvider.expenseList[index];
                      return Card.outlined(
                        elevation: 5,
                        child: ListTile(
                            title: Text(
                              exp.title,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                            subtitle: Text(
                              exp.amount.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: Text(
                              exp.amountType ? 'Credit' : 'Debit',
                              style: TextStyle(
                                  color: exp.amountType
                                      ? Colors.green
                                      : Colors.red),
                            )),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Expense"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: expenseProvider.titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: expenseProvider.amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      value: expenseProvider.isAmountType,
                      onChanged: (value) {
                        expenseProvider.toggle(value);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final expense = ExpenseModel(
                        id: DateTime.now().toString(),
                        title: expenseProvider.titleController.text,
                        amount: int.tryParse(
                                expenseProvider.amountController.text) ??
                            0,
                        amountType: expenseProvider.isAmountType,
                      );
                      expenseProvider.addExpense(expense);
                      expenseProvider.claearController();
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
