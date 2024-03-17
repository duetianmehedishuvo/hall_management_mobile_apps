import 'dart:async';

import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/book_history_model.dart';
import 'package:duetstahall/data/model/response/book_model.dart';
import 'package:duetstahall/data/model/response/book_purched_model.dart';
import 'package:duetstahall/data/repository/library_repo.dart';
import 'package:duetstahall/util/helper.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LibraryProvider with ChangeNotifier {
  final LibraryRepo libraryRepo;

  LibraryProvider({required this.libraryRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void changeLoadingFalse() {
    _isLoading = false;
  }

  List<String> categoryType = ['CSE', 'EEE', "ME", "IPE", "CE", "Other"];
  String selectCategoryType = 'CSE';

  changeCategoryType(String value, {bool isCallAPI = false}) {
    selectCategoryType = value;
    if (isCallAPI == true) {
      getAllCommunity(isFirstTime: false);
    }
    notifyListeners();
  }

  // TODO:: for updateUserAllHallFeeByID
  List<BookModel> bookList = [];
  bool isBottomLoading = false;
  int selectPage = 1;
  bool hasNextData = false;

  void addBookCategoryItem(bool isAdd) {
    if (categoryType.contains('All')) {
      categoryType.remove('All');
      selectCategoryType = 'CSE';
    }

    if (isAdd == true) {
      categoryType.insert(0, 'All');
      selectCategoryType = 'All';
    }
  }

  updateAllCommunity() {
    selectPage++;
    getAllCommunity(page: selectPage);
    notifyListeners();
  }

  getAllCommunity({int page = 1, bool isFirstTime = true}) async {
    if (page == 1) {
      selectPage = 1;
      bookList.clear();
      bookList = [];
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
    ApiResponse response = await libraryRepo.getAllBooks(selectCategoryType, selectPage);

    _isLoading = false;
    isBottomLoading = false;

    if (response.response.statusCode == 200) {
      hasNextData = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        bookList.add(BookModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  Future<bool> addBook(String title, String author, String price, int isUpdate, {int id = -1}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await libraryRepo.book(title, author, selectCategoryType, price, isUpdate, id);
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

  Future<bool> bookIssue(int isUpdate, {int id = -1}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse1 = await libraryRepo.bookIssue(bookModel.id as int, int.parse(studentID), isUpdate, id);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getBookPurchedHistory(isFirstTime: false);
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  Future<bool> deleteAllCard() async {
    _isLoading = true;
    cardID = '';
    studentID = '';

    notifyListeners();
    ApiResponse apiResponse = await libraryRepo.deleteAllCard();
    _isLoading = false;
    notifyListeners();
    if (apiResponse.response.statusCode == 200) {
      isCheckCardIssue = true;
      return true;
    } else {
      String errorMessage = apiResponse.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }

  String studentID = '';
  String cardID = '';

  clearStudentID() {
    studentID = '';
  }

  bool isCheckCardIssue = false;

  void changeCheckCardIssue() {
    isCheckCardIssue = false;
    notifyListeners();
  }

  void checkCardIssue() async {
    cardID = '';
    studentID = '';

    if (isCheckCardIssue == true) {
      ApiResponse apiResponse = await libraryRepo.checkCardIssue();
      if (apiResponse.response.statusCode == 200) {
        studentID = apiResponse.response.data['student_id'].toString();
        cardID = apiResponse.response.data['card_id'].toString();
        notifyListeners();
      } else {
        Timer(const Duration(seconds: 2), () {
          checkCardIssue();
        });
      }
    }
  }

// TODO:: for Commend
  List<BookPurchedModel> bookPurchedList = [];
  bool isBottomLoadingCommend = false;
  int selectPageCommend = 1;
  bool isLoadingCommend = false;
  bool hasNextDataCommend = false;

  updateAllCommend(bool isFromIssueBook) {
    selectPageCommend++;
    getBookPurchedHistory(page: selectPageCommend);
    notifyListeners();
  }

  List<String> purchedType = ['All', 'Renew', "Return"];
  String selectPurchedType = 'All';

  changePurchedType(String value, {bool isCallAPI = false, bool isFirstTime = true}) {
    selectPurchedType = value;
    if (isCallAPI == true) {
      getBookPurchedHistory(isFirstTime: false);
    }
    if (!isFirstTime) {
      notifyListeners();
    }
  }

  getBookPurchedHistory({int page = 1, bool isFirstTime = true, bool isFromIssueBook = true}) async {
    if (page == 1) {
      selectPageCommend = 1;
      bookPurchedList.clear();
      bookPurchedList = [];
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
    ApiResponse response = await libraryRepo.bookPurchedHistory(
        selectPageCommend,
        studentID.isEmpty ? int.parse(globalStudentID) : int.parse(studentID),
        selectPurchedType,
        isFromIssueBook == true
            ? 0
            : checkIsAdmin
                ? 1
                : 0);

    isLoadingCommend = false;
    isBottomLoadingCommend = false;

    if (response.response.statusCode == 200) {
      hasNextDataCommend = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        bookPurchedList.add(BookPurchedModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  BookModel bookModel = BookModel();

  selectBook(BookModel b) {
    bookModel = b;
    notifyListeners();
  }

  ////////////////// TODO: get All Book Parched History

  List<BookHistoryModel> bookHistoryList = [];

  updateAllBookHistory(int bookID) {
    selectPageCommend++;
    getBookHistory(bookID, page: selectPageCommend);
    notifyListeners();
  }

  getBookHistory(int bookID, {int page = 1, bool isFirstTime = true}) async {
    if (page == 1) {
      selectPageCommend = 1;
      bookHistoryList.clear();
      bookHistoryList = [];
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
    ApiResponse response = await libraryRepo.bookHistory(selectPageCommend, bookID);

    isLoadingCommend = false;
    isBottomLoadingCommend = false;

    if (response.response.statusCode == 200) {
      hasNextDataCommend = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        bookHistoryList.add(BookHistoryModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }
}
