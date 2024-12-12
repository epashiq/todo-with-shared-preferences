import 'package:todo_with_shared_preferences/features/todo/data/model/expense_model.dart';
import 'package:todo_with_shared_preferences/general/failures/failures.dart';
import 'package:dartz/dartz.dart';

abstract class IExpenseFacade{
  Future<Either<MainFailures, ExpenseModel>> addExpenses(ExpenseModel expense){
    throw UnimplementedError('error');
  }

  Future<Either<MainFailures,List<ExpenseModel>>> saveExpenses()async{
    throw UnimplementedError('error');
  }

  Future<Either<MainFailures,List<ExpenseModel>>> loadExpenses()async{
    throw UnimplementedError();
  }

}