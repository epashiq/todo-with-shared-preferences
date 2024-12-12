import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectableModule {
  @preResolve
  // @LazySingleton()
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
