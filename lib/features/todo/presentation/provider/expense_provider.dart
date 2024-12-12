import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_shared_preferences/features/todo/data/iexpense_facade_.dart';
import 'package:todo_with_shared_preferences/features/todo/data/model/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  final IExpenseFacade iExpenseFacade;
  ExpenseProvider({required this.iExpenseFacade});
  List<ExpenseModel> expenseList = [];
  bool isAmountType = false;

  final amountController = TextEditingController();
  final titleController = TextEditingController();

  void addExpense(ExpenseModel expense) async {
    final result = await iExpenseFacade.addExpenses(expense);

    result.fold(
      (failure) {
        log(failure.toString());
      },
      (success) {
        expenseList.insert(0, success);
        notifyListeners();
      },
    );
    // try {
    //   expenseList.add(expense);
    //   log('add expenses succesfully');
    //   log(expense.amountType.toString());
    //   notifyListeners();
    //   await saveExpenses();
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  Future<void> saveExpenses() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = await iExpenseFacade.saveExpenses();

    result.fold(
      (failure) {
        log(failure.toString());
      },
      (success) {
        expenseList.addAll(success);
      },
    );

    // try {
    //   List<String> saveExpense =
    //       expenseList.map((exp) => json.encode(exp.toMap())).toList();

    //   await prefs.setStringList('expenses', saveExpense);
    //   notifyListeners();
    //   log('save expenses');
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  Future<void> loadExpenses() async {
    final result = await iExpenseFacade.loadExpenses();
    result.fold(
      (failure) {
        log(failure.toString());
      },
      (success) {
        expenseList.addAll(expenseList);
      },
    );
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String>? expense = prefs.getStringList('expenses');

    // if (expense != null) {
    //   expenseList =
    //       expense.map((exp) => ExpenseModel.fromMap(json.decode(exp))).toList();
    // }
    // notifyListeners();
  }

  void toggle(bool value) {
    isAmountType = value;
    notifyListeners();
  }

  void claearController() {
    amountController.clear();
    titleController.clear();
  }

  void addLocally(ExpenseModel expense) {
    expenseList.insert(0, expense);
    notifyListeners();
  }
}
