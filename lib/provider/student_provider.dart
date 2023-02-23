import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/base/error_response.dart';
import 'package:duetstahall/data/model/response/meal_model.dart';
import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/data/model/response/student_model1.dart';
import 'package:duetstahall/data/model/response/transaction_model.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/data/repository/student_repo.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/model/response/event_model.dart';

class StudentProvider with ChangeNotifier {
  final AuthRepo authRepo;
  final StudentRepo studentRepo;

  StudentProvider({required this.authRepo, required this.studentRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // for get All Student from collection
  List<StudentModel> studentList = [];
  List<StudentModel> studentListTmp = [];

  initializeAllStudent() async {
    _isLoading = true;
    studentList.clear();
    studentListTmp.clear();
    studentList = [];
    studentListTmp = [];

    QuerySnapshot snapshot = await userCollection.get();

    for (var element in snapshot.docs) {
      studentList.add(StudentModel.fromMap(element));
    }
    studentList.sort((a, b) => a.studentID.toString().compareTo(b.studentID.toString()));
    studentListTmp.addAll(studentList);
    notifyListeners();
    _isLoading = false;
  }

  searchStudent(String query) {
    if (query.isEmpty) {
      studentList.clear();
      studentList.addAll(studentListTmp);
      notifyListeners();
    } else {
      studentList = [];
      for (var studentData in studentListTmp) {
        if ((studentData.name!.toLowerCase().contains(query.toLowerCase())) ||
            (studentData.studentID!.toLowerCase().contains(query.toLowerCase())) ||
            (studentData.roomNO!.toString().toLowerCase().contains(query.toLowerCase()))) {
          studentList.add(studentData);
        }
      }
      notifyListeners();
    }
  }

  StudentModel studentModel = StudentModel();

  // get Student Data
  void initializeStudent(String studentID) async {
    studentModel = StudentModel();
    _isLoading = true;

    QuerySnapshot snapshot = await userCollection.get();

    for (var element in snapshot.docs) {
      if (StudentModel.fromMap(element).studentID == studentID) {
        studentModel = StudentModel.fromMap(element);
      }
    }
    notifyListeners();

    _isLoading = false;
  }

  Future<bool> addStudent(StudentModel studentModel) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(studentModel.studentID).set(studentModel.toJson());
      _isLoading = false;
      initializeStudent(authRepo.getStudentID());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // check Student Password
  Future<bool> checkPassword(String password) async {
    StudentModel student = StudentModel();
    _isLoading = true;

    QuerySnapshot snapshot = await userCollection.get();

    for (var element in snapshot.docs) {
      if (StudentModel.fromMap(element).studentID == authRepo.getStudentID()) {
        student = StudentModel.fromMap(element);
      }
    }
    notifyListeners();

    _isLoading = false;
    return student.password.toString() == password.toString();
  }

  DateTime currentDateTime = DateTime.now();

  //get Current Time
  bool _isLoadingMeal = false;

  bool get isLoadingMeal => _isLoadingMeal;

  void initializeCurrentTime() async {
    _isLoadingMeal = true;
    Response apiResponse = await Dio().get('http://worldtimeapi.org/api/timezone/Asia/Dhaka/');

    if (apiResponse.statusCode == 200 || apiResponse.statusCode == 201) {
      DateTime d = DateTime.parse(apiResponse.data['datetime']);
      currentDateTime = DateTime(d.year, d.month, d.day);
    } else {}
    notifyListeners();
  }

  updateMealData({bool isIncrement = false, int removeCount = 1}) async {
    if (isIncrement) {
      studentModel.allowableMeal = studentModel.allowableMeal! + removeCount;
    } else {
      studentModel.allowableMeal = studentModel.allowableMeal! - removeCount;
    }
    await userCollection.doc(studentModel.studentID).set(studentModel.toJson());
    initializeStudent(studentModel.studentID!);
    notifyListeners();
  }

  List<DateTime> dateTimes = [];
  List<int> guestMeal = [];

  void getAllDate({String studentID = ''}) async {
    initializeCurrentTime();
    dateTimes = [];
    guestMeal = [];
    mealStudentCollection
        .doc(studentID.isEmpty ? authRepo.getStudentID() : studentID)
        .collection(studentID.isEmpty ? authRepo.getStudentID() : studentID)
        .get()
        .then((querySnapshot) {
      for (DocumentSnapshot ds in querySnapshot.docs) {
        Map? date = ds.data() as Map;
        // DateConverter.isoStringToDateGetServer(date['date']);
        dateTimes.add(DateConverter.isoStringToDateGetServer(date['date']));
        guestMeal.add(date['guest_meal']);
      }
      initializeAllDate(dateTimes);
      _isLoadingMeal = false;
      notifyListeners();
    });
  }

  List<EventModel> getEventsForDay(DateTime day) {
    final kEvents = LinkedHashMap<DateTime, List<EventModel>>(equals: isSameDay, hashCode: getHashCode)..addAll(kEventSource);
    return kEvents[day] ?? [];
  }

  Map<DateTime, List<EventModel>> kEventSource = {};

  initializeAllDate(List<DateTime> dates) {
    kEventSource = {};
    int p = 0;
    for (var item in dates) {
      var list = (guestMeal[p] != 0
          ? [const EventModel('Today\'s Event 1'), const EventModel('Today\'s Event 1')]
          : [const EventModel('Today\'s Event 1')]);
      kEventSource[DateTime.utc(item.year, item.month, item.day)] = list;
      p++;
    }
    notifyListeners();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

// get Student

  bool isLoadingCheckTodays = false;
  List<String> ids = [];
  int guestMealCount = 0;
  List<Map<String, dynamic>> allMeals = [];

  getTodayMeal(String dateTime, bool isToday) {
    isLoadingCheckTodays = true;
    guestMealCount = 0;
    ids.clear();
    ids = [];
    allMeals.clear();
    allMeals = [];

    mealAdminCollection.doc('admin_meal').collection(dateTime).get().then((querySnapshot) {
      for (DocumentSnapshot ds in querySnapshot.docs) {
        Map? date = ds.data() as Map;
        ids.add(date['student_id']);
        if (date['guest_meal'] != 0) {
          guestMealCount++;
        }
        allMeals.add(<String, dynamic>{
          'student_id': date['student_id'],
          'room_no': date['room_no'],
          'name': date['name'],
          'guest_meal': date['guest_meal']
        });
      }
      Map<String, dynamic> fingerData = {};
      Map<String, dynamic> rfData = {};

      int j = 0;
      for (var element in ids) {
        for (int i = 0; i < studentListTmp.length; i++) {
          if (element == studentListTmp[i].studentID) {
            fingerData['fingerData$j'] = int.parse(studentListTmp[i].fingerID!);
            rfData['rfData$j'] = int.parse(studentListTmp[i].rfID!);
            j++;
          }
        }
      }

      if (isToday) {
        fingerCollectionToday.doc('Finger_Data').delete();
        rfCollectionToday.doc('Rf_Data').delete();

        fingerCollectionToday.doc('Finger_Data').set(fingerData);
        rfCollectionToday.doc('Rf_Data').set(rfData);
      } else {
        fingerCollectionTomorrow.doc('Finger_Data').delete();
        rfCollectionTomorrow.doc('Rf_Data').delete();
        fingerCollectionTomorrow.doc('Finger_Data').set(fingerData);
        rfCollectionTomorrow.doc('Rf_Data').set(rfData);
      }

      isLoadingCheckTodays = false;
      notifyListeners();
    });
  }

  List<String> selectedDates = [];

  void addDates(String value, BuildContext context, {bool isRemove = false}) {
    if (isRemove) {
      if (dateTimesForQuery.contains(DateConverter.isoStringToDatePushServer(value))) {
        selectedDates.add(value);
        notifyListeners();
      } else {
        showMessage('This day has not been found for on meal.');
      }
    } else {
      if (!selectedDates.contains(value)) {
        if (dateTimesForQuery.contains(DateConverter.isoStringToDatePushServer(value))) {
          showMessage('This day already has been added, Please select other dates from the open calendar');
        } else {
          selectedDates.add(value);
          notifyListeners();
        }
      } else {
        showMessage('This date has already been selected.');
      }
    }
  }

  void removeDates(int index) {
    selectedDates.removeAt(index);
    notifyListeners();
  }

  List<String> dateTimesForQuery = [];
  List<MealModel> myMealLists = [];

  void getAllDateForQuery() async {
    initializeCurrentTime();
    dateTimes.clear();
    dateTimes = [];
    guestMeal.clear();
    guestMeal = [];
    myMealLists.clear();
    myMealLists = [];
    selectedDates = [];
    // notifyListeners();
    ApiResponse apiResponse = await studentRepo.getAllMealByStudentID();
    _isLoadingMeal = false;

    if (apiResponse.response.statusCode == 200) {
      for (var element in apiResponse.response.data) {
        MealModel mealModel = MealModel.fromJson(element);
        myMealLists.add(mealModel);
        dateTimes.add(DateConverter.isoStringToLocalDate(mealModel.createdAt!));
        guestMeal.add((mealModel.totalMeal as int) - 1);
      }
      notifyListeners();
      initializeAllDate(dateTimes);
    } else {
      String errorMessage = apiResponse.error.toString();
      showMessage(errorMessage, isError: true);
    }
    notifyListeners();
  }

  void addDateToServer(String dateTime, {bool isGuestMeal = false}) async {
    _isLoadingMeal = true;
    notifyListeners();
    ApiResponse apiResponse1;
    if (isGuestMeal == true) {
      apiResponse1 = await studentRepo.addGuestMeal(dateTime);
    } else {
      apiResponse1 = await studentRepo.addMeal(dateTime);
    }

    _isLoadingMeal = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage('Added ${isGuestMeal == true ? "Guest " : ""}Meal On Date $dateTime Successfully', isError: false);
      getAllDateForQuery();
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
    }
    notifyListeners();
  }

  void cancelMeal(String dateTime, {bool isGuestMeal = false}) async {
    _isLoadingMeal = true;
    notifyListeners();
    ApiResponse apiResponse1;
    if (isGuestMeal == true) {
      apiResponse1 = await studentRepo.deleteGuestMealByID(dateTime);
    } else {
      apiResponse1 = await studentRepo.deleteMealByID(dateTime);
    }
    _isLoadingMeal = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllDateForQuery();
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
    }
    notifyListeners();
  }

  Future<Map> updateBalance(String balance) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await studentRepo.updateBalance(balance);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      authRepo.updateBalance(balance, true);
      return {'status': true, 'value': balance};
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return {'status': false, 'value': "0"};
    }
  }

  bool isMealOn = false;

  changeMealOn(bool value) {
    isMealOn = value;
    notifyListeners();
  }

  DateTime date = DateTime.now();
  List<DateTime> dateList = [];

  removeStudent(String studentID, BuildContext context) async {
    date = DateTime.now();
    dateList = [];
    userCollection.get().then((querySnapshot) {
      for (DocumentSnapshot ds in querySnapshot.docs) {
        Map? date = ds.data() as Map;
        if (studentID == date['studentID']) {
          ds.reference.delete();
          initializeAllStudent();
        }
      }
    });

    mealStudentCollection.doc(studentID).collection(studentID).get().then((querySnapshot) {
      for (DocumentSnapshot ds in querySnapshot.docs) {
        ds.reference.delete();
      }
    });

    // DateTime dateTime=DateTime.now();
    for (int i = 0; i < 30; i++) {
      dateList.add(date);
      date = date.add(const Duration(days: 1));
    }
    for (var element in dateList) {
      mealAdminCollection.doc('admin_meal').collection(DateConverter.localDateToIsoString(element)).get().then((querySnapshot) {
        for (DocumentSnapshot ds in querySnapshot.docs) {
          Map? da = ds.data() as Map;
          if (studentID == da['student_id']) {
            ds.reference.delete();
          }
        }
      });
    }

    showMessage('Student Remove Successfully.', isError: false);
    notifyListeners();
  }

  int totalStudentMeal = 0;

  Future<void> getData() async {
    date = DateTime.now();
    dateList = [];
    totalStudentMeal = 0;
    for (int i = 0; i < 90; i++) {
      dateList.add(date);
      date = date.add(const Duration(days: 1));
    }

    for (var element in dateList) {
      mealAdminCollection.doc('admin_meal').collection(DateConverter.localDateToIsoString(element)).get().then((querySnapshot) {
        for (DocumentSnapshot ds in querySnapshot.docs) {
          Map? da = ds.data() as Map;
          if (da['guest_meal'] == 0) {
            totalStudentMeal++;
          } else {
            totalStudentMeal += 2;
          }
        }
        totalStudentMeal = totalStudentMeal;
      });
    }
    // notifyListeners();
  }

  addMealRate(int mealRate) async {
    //TODO for save user record
    await mealRateCollection.doc('meal_rate').set({'meal-rate': mealRate});
  }

///////TODO for New Data

  // for get  Student By ID
  StudentModel1 studentModel1 = StudentModel1();

  getStudentInfoByID(String studentID) async {
    _isLoading = true;
    isSelectBasicInfo = true;
    studentModel1 = StudentModel1();
    // notifyListeners();
    ApiResponse apiResponse = await studentRepo.getStudentInfoByID(studentID);
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      studentModel1 = StudentModel1.fromJson(apiResponse.response.data);
      notifyListeners();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.toString();
      }
      showMessage(errorMessage, isError: true);
      notifyListeners();
    }
  }

  bool isSelectBasicInfo = true;

  changeBasicInfo(bool value) {
    isSelectBasicInfo = value;
    notifyListeners();
  }

  List<StudentSubModel> searchStudents = [];
  String selectStudentID = 'none';

  callForSearchStudent(String query) async {
    _isLoading = true;
    searchStudents.clear();
    searchStudents = [];
    selectStudentID = 'none';
    notifyListeners();
    ApiResponse apiResponse = await studentRepo.searchStudent(query);
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      for (var element in apiResponse.response.data) {
        searchStudents.add(StudentSubModel.fromJson(element));
      }
      notifyListeners();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.toString();
      }
      showMessage(errorMessage, isError: true);
      notifyListeners();
    }
  }

  changeSelectStudentID(int index) {
    selectStudentID = searchStudents[index].studentID.toString();
    notifyListeners();
  }

  clearSearchStudent() {
    searchStudents.clear();
    searchStudents = [];
    selectStudentID = 'none';
  }

  // TODO:: for group All Posts
  List<TransactionModel> transactionList = [];
  bool isBottomLoading = false;
  int selectPage = 1;
  bool hasNextData = false;

  updateUserTransactionListNo() {
    selectPage++;
    callForGetUserAllTransaction(page: selectPage);
    notifyListeners();
  }

  callForGetUserAllTransaction({int page = 1, bool isFirstTime = true}) async {
    if (page == 1) {
      selectPage = 1;
      transactionList.clear();
      transactionList = [];
      _isLoading = true;
      hasNextData = false;
      isBottomLoading = false;
      if (!isFirstTime) {
        notifyListeners();
      }
    } else {
      isBottomLoading = true;
      notifyListeners();
    }

    ApiResponse response = await studentRepo.userAllTransaction(selectPage);

    _isLoading = false;
    isBottomLoading = false;

    if (response.response.statusCode == 200) {
      hasNextData = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        transactionList.add(TransactionModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }
}
