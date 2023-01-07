import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/data/repository/splash_repo.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/dashboard_provider.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstant.baseUrl, sl(), sharedPreferences: sl(), loggingInterceptor: sl()));
  // Repository
  sl.registerLazySingleton(() => AuthRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => SplashRepo(dioClient: sl(), authRepo: sl()));

  // Provider
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => DashboardProvider());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
