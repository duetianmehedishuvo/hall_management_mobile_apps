import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:duetstahall/data/datasource/remote/dio/dio_client.dart';
import 'package:duetstahall/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/data/repository/community_repo.dart';
import 'package:duetstahall/data/repository/complain_repo.dart';
import 'package:duetstahall/data/repository/guest_room_repo.dart';
import 'package:duetstahall/data/repository/hall_fee_repo.dart';
import 'package:duetstahall/data/repository/room_repo.dart';
import 'package:duetstahall/data/repository/settings_repo.dart';
import 'package:duetstahall/data/repository/splash_repo.dart';
import 'package:duetstahall/data/repository/student_repo.dart';
import 'package:duetstahall/provider/auth_provider.dart';
import 'package:duetstahall/provider/community_provider.dart';
import 'package:duetstahall/provider/complain_provider.dart';
import 'package:duetstahall/provider/dashboard_provider.dart';
import 'package:duetstahall/provider/guest_room_provider.dart';
import 'package:duetstahall/provider/hall_fee_provider.dart';
import 'package:duetstahall/provider/room_provider.dart';
import 'package:duetstahall/provider/settings_provider.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstant.baseUrl, sl(), sharedPreferences: sl(), loggingInterceptor: sl()));
  // Repository
  sl.registerLazySingleton(() => AuthRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => SplashRepo(dioClient: sl(), authRepo: sl()));
  sl.registerLazySingleton(() => RoomRepo(dioClient: sl()));
  sl.registerLazySingleton(() => StudentRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => HallFeeRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ComplainRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => GuestRoomRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => CommunityRepo(dioClient: sl()));
  sl.registerLazySingleton(() => SettingsRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => StudentProvider(authRepo: sl(), studentRepo: sl()));
  sl.registerFactory(() => RoomProvider(roomRepo: sl()));
  sl.registerFactory(() => ComplainProvider(authRepo: sl(), complainRepo: sl()));
  sl.registerFactory(() => GuestRoomProvider(guestRoomRepo: sl()));
  sl.registerFactory(() => HallFeeProvider(authRepo: sl(), hallFeeRepo: sl()));
  sl.registerFactory(() => DashboardProvider());
  sl.registerFactory(() => SettingsProvider(settingsRepo: sl()));
  sl.registerFactory(() => CommunityProvider(communityRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  final firebaseInstance = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firebaseInstance);
}
