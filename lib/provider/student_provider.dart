import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:duetstahall/data/model/response/student_model.dart';
import 'package:duetstahall/data/repository/auth_repo.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/util/app_constant.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/model/response/meal_date_utils.dart';

class StudentProvider with ChangeNotifier {
  final AuthRepo authRepo;

  StudentProvider({required this.authRepo});

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
    Response apiResponse = await Dio().get('http://worldtimeapi.org/api/timezone/Asia/Dhaka');
    _isLoadingMeal = false;
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

  List<Event> getEventsForDay(DateTime day) {
    final kEvents = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay, hashCode: getHashCode)..addAll(kEventSource);
    return kEvents[day] ?? [];
  }

  Map<DateTime, List<Event>> kEventSource = {};

  initializeAllDate(List<DateTime> dates) {
    kEventSource = {};
    int p = 0;
    for (var item in dates) {
      var list = (guestMeal[p] != 0 ? [Event('Today\'s Event 1'), Event('Today\'s Event 1')] : [Event('Today\'s Event 1')]);
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

  initializeEmptyDates() {
    selectedDates = [];
  }

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
          showMessage('This Day will Already be started On Meal.');
        } else {
          selectedDates.add(value);
          notifyListeners();
        }
      } else {
        showMessage('This Date Has Already been Select.');
      }
    }
  }

  void removeDates(int index) {
    selectedDates.removeAt(index);

    notifyListeners();
  }

  List<String> dateTimesForQuery = [];

  void getAllDateForQuery() async {
    mealStudentCollection.doc(authRepo.getStudentID()).collection(authRepo.getStudentID()).get().then((querySnapshot) {
      _isLoadingMeal = true;
      dateTimesForQuery = [];
      for (DocumentSnapshot ds in querySnapshot.docs) {
        Map? date = ds.data() as Map;
        dateTimesForQuery.add(date['date']);
      }

      _isLoadingMeal = false;
      notifyListeners();
    });
  }

  void uploadDateOnServer(BuildContext context, bool isRemove) {
    _isLoadingMeal = true;
    notifyListeners();
    for (var element in selectedDates) {
      if (isRemove) {
        removeDateFromServer(DateConverter.isoStringToDatePushServer(element), context);
      } else {
        addDateToServer(DateConverter.isoStringToDatePushServer(element), context);
      }
      if (selectedDates.last == element) {
        if (isRemove) {
          updateMealData(isIncrement: true, removeCount: selectedDates.length);
        }

        Timer(const Duration(seconds: 2), () {
          _isLoadingMeal = false;
          selectedDates = [];
          getAllDateForQuery();
        });
      }
    }

    notifyListeners();
  }

  void addDateToServer(String dateTime, BuildContext context, {bool isGuestMeal = false, bool isGuestMessage = false}) {
    if (studentModel.allowableMeal == 0) {
      showMessage('You Haven\'t any meal');
    } else {
      //TODO for save user record
      mealStudentCollection
          .doc(authRepo.getStudentID())
          .collection(authRepo.getStudentID())
          .doc(dateTime)
          .set({'date': dateTime, 'guest_meal': isGuestMeal ? 1 : 0});
      //TODO for save admin record
      mealAdminCollection.doc('admin_meal').collection(dateTime).doc(authRepo.getStudentID()).set({
        'student_id': authRepo.getStudentID(),
        'room_no': studentModel.roomNO.toString(),
        'name': studentModel.name,
        'guest_meal': isGuestMeal ? 1 : 0
      });
      updateMealData(isIncrement: isGuestMessage ? !isGuestMeal : isGuestMeal);
      if (isGuestMessage) {
        if (isGuestMeal) {
          showMessage('Guest Meal Added Successfully: $dateTime. Press Refresh Button for Get Update', isError: false);
        } else {
          showMessage('Guest Meal Removed Successfully: $dateTime. Press Refresh Button for Get Update', isError: false);
        }
      } else {
        showMessage('Successfully Added Date: $dateTime', isError: false);
      }

      notifyListeners();
    }
  }

  removeDateFromServer(String dateTime, BuildContext context) async {
    mealStudentCollection.doc(authRepo.getStudentID()).collection(authRepo.getStudentID()).get().then((querySnapshot) {
      for (DocumentSnapshot ds in querySnapshot.docs) {
        Map? date = ds.data() as Map;
        if (dateTime == date['date']) {
          ds.reference.delete();
        }
      }
    });

    mealAdminCollection.doc('admin_meal').collection(dateTime).get().then((querySnapshot) {
      for (DocumentSnapshot ds in querySnapshot.docs) {
        Map? date = ds.data() as Map;
        if (authRepo.getStudentID() == date['student_id']) {
          ds.reference.delete();
        }
      }
    });

    showMessage('Remove Successfully Date: $dateTime', isError: false);
    notifyListeners();
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

  // for Blood Group Dropdown
  List<int> floorsLists = [1, 2, 3, 4, 5, 6, 7, 8];
  int selectedFloors = 1;
  List<int> roomLists = [];

  changeFloors(int value) {
    selectedFloors = value;
    generateRooms();
    notifyListeners();
  }

  generateRooms() {
    roomLists.clear();
    roomLists = [];
    int i = selectedFloors * 100;
    for (int j = 1; j <= 25; j++) {
      roomLists.add(i + j);
    }
    notifyListeners();
  }
}
