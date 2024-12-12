import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_shared_preferences/features/todo/data/iexpense_facade_.dart';
import 'package:todo_with_shared_preferences/features/todo/data/model/expense_model.dart';
import 'package:todo_with_shared_preferences/general/failures/failures.dart';

@LazySingleton(as: IExpenseFacade)
class IexpenseFacadeImpl implements IExpenseFacade {
  List<ExpenseModel> expenseList = [];
  @override
  Future<Either<MainFailures, ExpenseModel>> addExpenses(
      ExpenseModel expense) async {
    try {
      expenseList.add(expense);
      log('add expenses succesfully');
      log(expense.amountType.toString());
      await saveExpenses();

      return right(expense);
    } catch (e) {
      return left(MainFailures.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<MainFailures, List<ExpenseModel>>> saveExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      List<String> saveExpense =
          expenseList.map((exp) => json.encode(exp.toMap())).toList();

      await prefs.setStringList('expenses', saveExpense);
      return right(expenseList);
    } catch (e) {
      return left(MainFailures.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<MainFailures, List<ExpenseModel>>> loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? expense = prefs.getStringList('expenses');

    try {
      if (expense != null) {
        expenseList = expense
            .map((exp) => ExpenseModel.fromMap(json.decode(exp)))
            .toList();
      }
      return right(expenseList);
    } catch (e) {
      return left(MainFailures.serverFailure(errorMessage: e.toString()));
    }
  }
}
