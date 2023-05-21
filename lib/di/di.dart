import 'package:get_it/get_it.dart';
import 'package:travelday/Services/ApiServices.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator({bool test = false}) async {
  //locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => ApiService());

  //sl.registerFactory(() => User());
  //sl.registerFactory(() => Posts());

  //sl.registerFactory(() => UserReactive());
  //locator.registerFactory(() => PostsReactive());

  //locator.registerLazySingleton(() => StorageService());
}
