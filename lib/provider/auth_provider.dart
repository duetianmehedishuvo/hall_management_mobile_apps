import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addAdmin(String email, String password) async {
    _isLoading = true;
    await adminCollection.doc('admin').set({"email": email, "password": password});
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkAdmin(String email, String password, bool isRemember) async {
    if (isRemember) {
      authRepo.saveUserEmailAndPassword(email, password);
    } else {
      authRepo.clearUserEmailAndPassword();
    }
    DocumentSnapshot snapshot = await adminCollection.doc('admin').get();
    return (snapshot.get('password') == password) && (snapshot.get('email') == email);
  }

  Future<bool> addStudent(StudentModel studentModel) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(studentModel.studentID).set(studentModel.toJson());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkStudent(String studentID, String password) async {
    DocumentSnapshot snapshot = await userCollection.doc(studentID).get();
    authRepo.saveStudentID(studentID);
    return snapshot.exists && (snapshot.get('password') == password) && (snapshot.get('studentID') == studentID);
  }

  String getUserEmail() {
    return authRepo.getUserEmail();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  String getStudentID() {
    return authRepo.getStudentID();
  }

  bool _isActiveRememberMe = true;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  // for Blood Group Dropdown
  List<String> bloodGroups = ["A+", "A-", "O+", "O-", "B+", "B-", "AB+", "AB-"];
  String selectedBlood = "A+";

  changeBloodGroups(String value) {
    selectedBlood = value;
    notifyListeners();
  }

}
