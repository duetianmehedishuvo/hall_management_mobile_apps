import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/guest_room_model.dart';
import 'package:duetstahall/data/repository/guest_room_repo.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GuestRoomProvider with ChangeNotifier {
  final GuestRoomRepo guestRoomRepo;

  GuestRoomProvider({required this.guestRoomRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // TODO:: for updateUserAllHallFeeByID
  List<GuestRoomModel> guestRoomLists = [];
  bool isBottomLoading = false;
  int selectPage = 1;
  bool hasNextData = false;

  updateAllGuestRoomAssign({bool isAdmin = false}) {
    selectPage++;
    getAllRoomAssign(page: selectPage, isAdmin: isAdmin);
    notifyListeners();
  }

  getAllRoomAssign({int page = 1, bool isFirstTime = true, bool isAdmin = false}) async {
    if (page == 1) {
      selectPage = 1;
      guestRoomLists.clear();
      guestRoomLists = [];
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
    ApiResponse response;
    if (isAdmin) {
      response = await guestRoomRepo.getAllRoomAssignList(selectPage);
    } else {
      response = await guestRoomRepo.getMyRoomAssignByID(selectPage);
    }

    _isLoading = false;
    isBottomLoading = false;

    if (response.response.statusCode == 200) {
      hasNextData = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        guestRoomLists.add(GuestRoomModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  DateTime? startTime;
  DateTime? endTime;

  resetDateTime() {
    startTime = null;
    endTime = null;
  }

  changeDateTime(bool isStart, DateTime dateTime) {
    if (isStart == true) {
      startTime = dateTime;
    } else {
      endTime = dateTime;
    }
    notifyListeners();
  }

  Future<bool> addGuestRoomBook(String purpose, String phoneNo) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await guestRoomRepo.addGuestRoomBook(
        selectRoomTypeInt.toString(), DateConverter.localDateToIsoString2(startTime!), DateConverter.localDateToIsoString2(endTime!), purpose, phoneNo);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllRoomAssign();
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  Future<bool> acceptRoom(int id, int status) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await guestRoomRepo.acceptRoom(id.toString(), status.toString());
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllRoomAssign(isAdmin: true);
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  Future<bool> deleteGuestRoomBook() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await guestRoomRepo.deleteGuestRoomBook(guestRoomModel.id.toString());
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllRoomAssign(isAdmin: true);
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  List<String> roomType = ['Guest Room 1', 'Guest Room 2', 'TV Room', 'Sport Room'];
  String selectRoomType = 'Guest Room 1';
  int selectRoomTypeInt = 1;

  changeRoomType(String value) {
    selectRoomType = value;
    selectRoomTypeInt = selectRoomType == roomType[0]
        ? 0
        : selectRoomType == roomType[1]
            ? 1
            : selectRoomType == roomType[2]
                ? 2
                : 3;
    notifyListeners();
  }

  late GuestRoomModel guestRoomModel;
  bool hasAvailableRoom = false;

  changeGuestRoom(value) {
    guestRoomModel = value;
    hasAvailableRoom = guestRoomModel.status == 0 ? false : true;
    notifyListeners();
  }

  changeGuestRoomAccess(bool value, {bool isFirstTime = false}) {
    hasAvailableRoom = value;
    if (!isFirstTime) {
      notifyListeners();
      acceptRoom(guestRoomModel.id as int, value == true ? 1 : 0);
      // changeGuestMealAddedStatus();
    }
  }
}
