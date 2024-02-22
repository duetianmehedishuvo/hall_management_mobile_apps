import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/commend_model.dart';
import 'package:duetstahall/data/model/response/community_model.dart';
import 'package:duetstahall/data/repository/community_repo.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommunityProvider with ChangeNotifier {
  final CommunityRepo communityRepo;

  CommunityProvider({required this.communityRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // TODO:: for updateUserAllHallFeeByID
  List<CommunityModel> communityList = [];
  bool isBottomLoading = false;
  int selectPage = 1;
  bool hasNextData = false;

  updateAllCommunity({bool isAllPost = true}) {
    selectPage++;
    getAllCommunity(page: selectPage, isAllPost: isAllPost);
    notifyListeners();
  }

  getAllCommunity({int page = 1, bool isFirstTime = true, bool isAllPost = true}) async {
    if (page == 1) {
      selectPage = 1;
      communityList.clear();
      communityList = [];
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
    if (isAllPost == true) {
      response = await communityRepo.getAllPost(selectPage);
    } else {
      response = await communityRepo.getAllPostByStudentID(selectPage);
    }

    _isLoading = false;
    isBottomLoading = false;

    if (response.response.statusCode == 200) {
      hasNextData = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        communityList.add(CommunityModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  Future<bool> addPost(String details, int isUpdate, {int id = -1}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await communityRepo.post(details, isUpdate, id);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllCommunity();
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  Future<bool> deletePost(int id, int index) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await communityRepo.deletePost(id);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      communityList.removeAt(index);
      notifyListeners();
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
    }
    return true;
  }

  // TODO:: for Commend
  List<CommendModel> commendList = [];
  bool isBottomLoadingCommend = false;
  int selectPageCommend = 1;
  bool isLoadingCommend = false;
  bool hasNextDataCommend = false;

  updateAllCommend() {
    selectPageCommend++;
    getAllCommend(page: selectPageCommend, );
    notifyListeners();
  }

  getAllCommend({int page = 1,  bool isFirstTime = true}) async {
    if (page == 1) {
      selectPageCommend = 1;
      commendList.clear();
      commendList = [];
      isLoadingCommend = true;
      hasNextDataCommend = false;
      isBottomLoadingCommend = false;
      if (!isFirstTime) {
        notifyListeners();
      }
    } else {
      isBottomLoadingCommend = true;
      notifyListeners();
    }
    ApiResponse response = await communityRepo.getAllPostCommend(selectPageCommend, communityId);

    isLoadingCommend = false;
    isBottomLoadingCommend = false;

    if (response.response.statusCode == 200) {
      hasNextDataCommend = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        commendList.add(CommendModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  int communityId = 1;

  changeCommunityID(val) {
    communityId = val;
    notifyListeners();
  }

  Future<bool> commend( String comment, int isUpdate, {int id = -1}) async {
    isLoadingCommend = true;
    notifyListeners();
    ApiResponse apiResponse1 = await communityRepo.comment(communityId, comment, isUpdate, id);
    isLoadingCommend = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllCommend();
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  Future<bool> deleteCommend(int id, int index) async {
    isLoadingCommend = true;
    notifyListeners();
    ApiResponse apiResponse1 = await communityRepo.deleteCommend(id);
    isLoadingCommend = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      commendList.removeAt(index);
      notifyListeners();
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
    }
    return true;
  }
}
