import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_shared_preferences/features/todo/data/iexpense_facade_.dart';
import 'package:todo_with_shared_preferences/features/todo/presentation/expense_page.dart';
import 'package:todo_with_shared_preferences/features/todo/presentation/provider/expense_provider.dart';
import 'package:todo_with_shared_preferences/general/di/injection.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependancy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ExpenseProvider(iExpenseFacade: sl<IExpenseFacade>()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ExpensePage(),
      ),
    );
  }
}
