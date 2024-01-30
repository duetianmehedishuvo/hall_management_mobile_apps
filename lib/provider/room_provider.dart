import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/base/error_response.dart';
import 'package:duetstahall/data/model/response/room_model1.dart';
import 'package:duetstahall/data/repository/room_repo.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';

class RoomProvider with ChangeNotifier {
  final RoomRepo roomRepo;

  RoomProvider({required this.roomRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // for get All Student from collection
  List<RoomModel1> activeStudents = [];
  List<RoomModel1> inactiveStudents = [];

  getRoomInfo() async {
    _isLoading = true;
    activeStudents.clear();
    activeStudents = [];
    inactiveStudents.clear();
    inactiveStudents = [];
    notifyListeners();
    ApiResponse apiResponse = await roomRepo.getRoomInfo(selectedRooms.toString());
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      try{
        for (var element in apiResponse.response.data['activeStudents']) {
          activeStudents.add(RoomModel1.fromJson(element));
        }
        for (var element in apiResponse.response.data['inactiveStudents']) {
          inactiveStudents.add(RoomModel1.fromJson(element));
        }
      }catch(e){

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

  // for Blood Group Dropdown
  List<int> floorsLists = [1, 2, 3, 4, 5, 6, 7, 8];
  int selectedFloors = 1;
  int selectedRooms = 1;
  List<int> roomLists = [];

  changeFloors(int value) {
    selectedFloors = value;
    generateRooms();
    notifyListeners();
  }

  selectRooms(int value) {
    selectedRooms = value;
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

  bool hasRemoveRoomAccess = false;

  changeRoomAccess(bool value, {bool isFirstTime = false}) {
    hasRemoveRoomAccess = value;
    if (!isFirstTime) {
      notifyListeners();
      updateRoomStatus();
    }
  }

  String userID = '';
  String id = '';
  int index = 0;

  void userTempData(String rID, int i, String sID) {
    id = rID;
    index = i;
    userID = sID;
    notifyListeners();
  }

  updateRoomStatus() async {
    ApiResponse apiResponse = await roomRepo.updateRoomStatus(id, hasRemoveRoomAccess == true ? 1 : 0);

    if (apiResponse.response.statusCode == 200) {
      showMessage(apiResponse.response.data['message'], isError: false);
      if (hasRemoveRoomAccess == true) {
        inactiveStudents[index].isAvaible = 1;
        activeStudents.add(inactiveStudents[index]);
        inactiveStudents.removeAt(index);
      } else {
        activeStudents[index].isAvaible = 0;
        inactiveStudents.add(activeStudents[index]);
        activeStudents.removeAt(index);
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

  deleteRoomStatus() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await roomRepo.deleteRoom(id);
    _isLoading = false;
    notifyListeners();

    if (apiResponse.response.statusCode == 200) {
      showMessage(apiResponse.response.data['message'], isError: false);
      if (hasRemoveRoomAccess == true) {
        activeStudents.removeAt(index);
      } else {
        inactiveStudents.removeAt(index);
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

  List<int> years = [];
  int selectYears = DateTime.now().year;

  void initializeYears() {
    if (years.isEmpty) {
      years = [];
      years.clear();
      for (int i = 1995; i <= DateTime.now().year; i++) {
        years.add(i);
      }
      notifyListeners();
    }
  }

  changeYear(int value) {
    selectYears = value;
    notifyListeners();
  }

  Future<bool> addRoom(String studentID) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await roomRepo.addRoom(selectedRooms.toString(), studentID, selectYears);
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response.statusCode == 200) {
      showMessage('Assign successful', isError: false);
      getRoomInfo();
      return true;
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.toString();
      }
      showMessage(errorMessage, isError: true);

      return false;
    }
  }
}
