import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:duetstahall/data/model/response/base/api_response.dart';
import 'package:duetstahall/data/model/response/medical_service_details_model.dart';
import 'package:duetstahall/data/model/response/medical_service_model.dart';
import 'package:duetstahall/data/repository/medical_repo.dart';
import 'package:duetstahall/view/widgets/snackbar_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MedicalProvider with ChangeNotifier {
  final MedicalRepo medicalRepo;

  MedicalProvider({required this.medicalRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void changeLoadingFalse() {
    _isLoading = false;
  }

  // TODO:: for updateUserAllHallFeeByID
  List<MedicalServiceModel> allMedicalService = [];
  bool isBottomLoading = false;
  int selectPage = 1;
  bool hasNextData = false;

  int isAll = 0;
  int studentID = -1;

  changeAllAndStudentID(int allValue, int studentIDValue) {
    isAll = allValue;
    studentID = studentIDValue;
  }

  updateAllMedicalHistory() {
    selectPage++;
    getAllMedicalHistory(page: selectPage);
    notifyListeners();
  }

  getAllMedicalHistory({int page = 1, bool isFirstTime = true}) async {
    if (page == 1) {
      selectPage = 1;
      allMedicalService.clear();
      allMedicalService = [];
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
    ApiResponse response = await medicalRepo.medicalHistory(isAll, studentID, selectPage);

    _isLoading = false;
    isBottomLoading = false;

    if (response.response.statusCode == 200) {
      hasNextData = response.response.data['next_page_url'] != null ? true : false;
      response.response.data['data'].forEach((element) {
        allMedicalService.add(MedicalServiceModel.fromJson(element));
      });
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  MedicalServiceDetailsModel medicalServiceDetailsModel = MedicalServiceDetailsModel();
  bool isLoading2 = false;

  medicalHistoryDetails(int id) async {
    isLoading2 = true;
    medicalServiceDetailsModel = MedicalServiceDetailsModel();
    notifyListeners();
    ApiResponse response = await medicalRepo.medicalHistoryDetails(id);

    isLoading2 = false;

    if (response.response.statusCode == 200) {
      medicalServiceDetailsModel = MedicalServiceDetailsModel.fromJson(response.response.data);
    } else {
      Fluttertoast.showToast(msg: response.response.statusMessage!);
    }
    notifyListeners();
  }

  File? imageFile;

  Future pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      imageFile = result.paths.map((e) => File(e!)).toList()[0];

      notifyListeners();
    }
  }

  Future<bool> addMedicalService(String service_type, String provider_name, String details, int isUpdate, {int id = -1}) async {
    _isLoading = true;
    notifyListeners();
    List<MapEntry<String, String>> map = [
      MapEntry('student_id', studentID.toString()),
      MapEntry('service_type', service_type),
      MapEntry('provider_name', provider_name),
      MapEntry('details', details),
      MapEntry('isUpdate', isUpdate.toString()),
      MapEntry('id', id.toString()),
    ];

    FormData formData = FormData();

    if (imageFile != null) {
      formData.files.add(
          MapEntry('document', MultipartFile(imageFile!.readAsBytes().asStream(), imageFile!.lengthSync(), filename: imageFile!.path.split("/").last)));
    }

    formData.fields.addAll(map);

    ApiResponse apiResponse1 = await medicalRepo.medicalService(formData);
    _isLoading = false;
    notifyListeners();
    if (apiResponse1.response.statusCode == 200) {
      showMessage(apiResponse1.response.data['message'], isError: false);
      getAllMedicalHistory();
      return true;
    } else {
      String errorMessage = apiResponse1.error.toString();
      showMessage(errorMessage);
      return false;
    }
  }
}
