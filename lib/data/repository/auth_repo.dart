import 'package:duetstahall/util/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.sharedPreferences});

  Future<void> saveStudentID(String studentID) async {
    try {
      await sharedPreferences.setString(AppConstant.studentID, studentID);
    } catch (e) {
      rethrow;
    }
  }

  String getStudentID() {
    return sharedPreferences.getString(AppConstant.studentID) ?? '';
  }

  Future<void> saveUserEmailAndPassword(String email, String password) async {
    try {
      await sharedPreferences.setString(AppConstant.userEmail, email);
      await sharedPreferences.setString(AppConstant.userPassword, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> clearUserEmailAndPassword() async {
    await sharedPreferences.remove(AppConstant.userPassword);
    return await sharedPreferences.remove(AppConstant.userEmail);
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstant.userPassword) ?? "";
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstant.userEmail) ?? "";
  }
}
