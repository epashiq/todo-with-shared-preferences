import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_shared_preferences/features/todo/data/iexpense_facade_.dart';
import 'package:todo_with_shared_preferences/features/todo/data/model/expense_model.dart';
import 'package:todo_with_shared_preferences/general/failures/failures.dart';

@LazySingleton(as: IExpenseFacade)
class IexpenseImpl implements IExpenseFacade {
  @override
  Future<Either<MainFailures, ExpenseModel>> addExpenses(
      ExpenseModel expense) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final expenseJsonData = prefs.getStringList('expense') ?? [];
      final updatedExpenseJsonData = <String>[];

      for(final expense in expenseJsonData){
        updatedExpenseJsonData.add(expense);
      }

      prefs.setStringList('expense', [expense.toJson(), ...expenseJsonData]);

      return right(expense);
    } catch (e) {
      return left(MainFailures.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<MainFailures, List<ExpenseModel>>> getExpenses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final getExpenseJsonData = prefs.getStringList(
            'expense',
          ) ??
          [];
      final expenseList =
          getExpenseJsonData.map((exp) => ExpenseModel.fromJson(exp)).toList();
      return right(expenseList);
    } catch (e) {
      return left(MainFailures.serverFailure(errorMessage: e.toString()));
    }
  }
  
  @override
  Future<Either<MainFailures, bool>> deleteExpenses(String expenseId)async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final expenseJsonData = prefs.getStringList('expense') ?? [];

      final updatedExpenseJsonData = expenseJsonData.where((expense) {
        final expenseModel = ExpenseModel.fromJson(expense);
        return expenseModel.id != expenseId;
      },).toList();

      prefs.setStringList('expense', updatedExpenseJsonData);
      return right(true);
    } catch (e) {
      return left(MainFailures.serverFailure(errorMessage: e.toString()));
    }
  }

  // @override
  // Future<Either<MainFailures, ExpenseModel>> addExpenses(
  //     ExpenseModel expense) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();

  //     final expenseJsonData = prefs.getStringList('expenses') ?? [];
  //     final updatedExpenseJsonData = <String>[];

  //     for (final expenseJson in expenseJsonData) {
  //       updatedExpenseJsonData.add(expenseJson);
  //     }

  //     updatedExpenseJsonData.add(expense.toJson());

  //     prefs.setStringList('expenses', updatedExpenseJsonData
  //         // [
  //         //   ...expenseJsonData,
  //         //   expense.toJson(),
  //         // ],
  //         );

  //     return right(expense);
  //   } catch (e) {
  //     return left(MainFailures.serverFailure(errorMessage: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<MainFailures, List<ExpenseModel>>> getExpenses() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final getExpenseJsonData = (prefs.getStringList('expenses')) ?? [];

  //     final expenseList =
  //         getExpenseJsonData.map((e) => ExpenseModel.fromJson(e)).toList();
  //     return right(expenseList);
  //   } catch (e) {
  //     return left(
  //       MainFailures.serverFailure(
  //         errorMessage: e.toString(),
  //       ),
  //     );
  //   }
  // }
}
