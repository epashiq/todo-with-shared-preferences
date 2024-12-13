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

  num totalAmount = 0;

  final amountController = TextEditingController();
  final titleController = TextEditingController();

  void addExpense(ExpenseModel expense) async {
    final result = await iExpenseFacade.addExpenses(expense);

    result.fold(
      (failure) {
        log(failure.toString());
      },
      (success) {
        expenseList.add(success);
        // addLocally(expense);
        notifyListeners();
      },
    );
  }

  Future<void> getExpenses() async {
    final result = await iExpenseFacade.getExpenses();

    result.fold(
      (failure) {
        log(failure.errorMessage);
      },
      (success) {
        expenseList = success;

        calculateAmout();
        notifyListeners();

        log(totalAmount.toString(), name: 'totalAmount');
      },
    );
  }

  void calculateAmout() {
    for (var element in expenseList) {
      if (element.amountType) {
        totalAmount = totalAmount + element.amount;
      } else {
        totalAmount = totalAmount - element.amount;
      }
    }

    notifyListeners();
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
    calculateAmout();
    notifyListeners();
  }

  Future<void> deleteExpense(String expenseId) async {
    final result = await iExpenseFacade.deleteExpenses(expenseId);

    result.fold(
      (failure) {
        log(failure.toString());
      },
      (success) {
        expenseList.removeWhere((expense) => expense.id == expenseId);
        calculateAmout();
        notifyListeners();
      },
    );
  }
}
