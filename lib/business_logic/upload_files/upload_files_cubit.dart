import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_management/business_logic/upload_files/upload_files_state.dart';
import 'package:file_management/business_logic/uploaded_files/uploaded_files_cubit.dart';
import 'package:file_management/business_logic/uploaded_files/uploaded_files_state.dart';
import 'package:file_management/services/authentication.dart';
import 'package:file_management/services/storage/firebase_firestore.dart';
import 'package:file_management/utils/constants/app_keys.dart';
import 'package:file_management/utils/constants/string_constants.dart';
import 'package:file_management/utils/styles/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadFilesCubit extends Cubit<UploadFilesState> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = Authentication;

  UploadFilesCubit()
      : super(UploadFilesLoaded(
      categoryValue: "", subCategoryValue: "", fileUrl: ""));

  final List<String> _category = [
    StringConstants.identity,
    StringConstants.residence,
    StringConstants.finance,
  ];

  final List<List<DropdownMenuItem<String>>> _subCategory = [
    [
      const DropdownMenuItem(
        value: StringConstants.chooseCategoryFirst,
        child: Text(StringConstants.chooseCategoryFirst),
      ),
    ],
    [
      const DropdownMenuItem(
        value: StringConstants.passport,
        child: Text(StringConstants.passport),
      ),
      const DropdownMenuItem(
        value: StringConstants.aadharCard,
        child: Text(StringConstants.aadharCard),
      ),
      const DropdownMenuItem(
        value: StringConstants.drivingLicense,
        child: Text(StringConstants.drivingLicense),
      ),
    ],
    [
      const DropdownMenuItem(
        value: StringConstants.waterBill,
        child: Text(StringConstants.waterBill),
      ),
      const DropdownMenuItem(
        value: StringConstants.electricityBill,
        child: Text(StringConstants.electricityBill),
      ),
      const DropdownMenuItem(
        value: StringConstants.rentBill,
        child: Text(StringConstants.rentBill),
      ),
    ],
    [
      const DropdownMenuItem(
        value: StringConstants.salary,
        child: Text(StringConstants.salary),
      ),
      const DropdownMenuItem(
        value: StringConstants.food,
        child: Text(StringConstants.food),
      ),
      const DropdownMenuItem(
        value: StringConstants.drinks,
        child: Text(StringConstants.drinks),
      ),
    ],
  ];

  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CloudStorage _firebaseStorage = CloudStorage();
  String categoryValue = "";
  String subCategoryValue = "";
  String? fileUrl;
  String fileName = "";



  List<String> get categories => _category;

  List<List<DropdownMenuItem<String>>> get subCategory => _subCategory;

  get descriptionController => _descriptionController;

  get scaffoldKey => _scaffoldKey;

  get formKey => _formKey;

  int giveIndex(String item) {
    return _category.indexOf(item);
  }

  void onChangeCategory(String value) {
    categoryValue = value;
    subCategoryValue="";
   emit(UploadFilesLoaded(
        categoryValue: categoryValue,
       subCategoryValue: subCategoryValue,
      fileUrl: fileUrl ?? ""));
  }

  void onChangeSubCategory(String value) {
    subCategoryValue = value;
    emit(UploadFilesLoaded(
        categoryValue: categoryValue,
        subCategoryValue: subCategoryValue,
        fileUrl: fileUrl ?? ""));
  }

  Future<void> onClickUploadFiles() async {
    final file = await _pickFile();
    emit(UploadFilesLoading());
    if (file != null) {
      debugPrint("file exists");
      _firebaseStorage.uploadFile(file).then((url) {
        fileUrl = url;
        emit(UploadFilesLoaded(
            categoryValue: categoryValue,
            subCategoryValue: subCategoryValue,
            fileUrl: fileUrl!));
      });
    } else {
      emit(UploadFilesError(error:StringConstants.userCancelledRequest ));
      debugPrint(StringConstants.userCancelledRequest);
    }
  }

  Future<void> onClickUploadButton(BuildContext context) async {
    if (fileUrl != null && _formKey.currentState!.validate()) {
      String uid = Authentication.getCurrentUserID() ?? "";
      Map<String, dynamic> fileData = {
        AppKeys.category: categoryValue,
        AppKeys.subCategory: subCategoryValue,
        AppKeys.description: _descriptionController.text,
        AppKeys.fileUrl: fileUrl,
        AppKeys.uploadedAt: FieldValue.serverTimestamp(),
      };
       _firebaseStorage.saveFileDetailsToFirestore(fileData,uid).whenComplete(() {
         debugPrint(StringConstants.fileUploadedAndDetails);
         categoryValue ="";
         subCategoryValue ="";
         fileUrl = "";
         fileName = "";
         _descriptionController.clear();
         emit(UploadFilesLoaded(categoryValue: "",subCategoryValue: "",fileUrl: ""));
         MediaQuery.of(context).size.width < 600 ? onClickOpenDrawer() : null;
         context.read<UploadedFilesCubit>().fetchData();
       });
    } else if (_formKey.currentState!.validate()) {
      print(fileUrl);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.yellow,
          content: Text(
            'Please upload file',
            style: TextStyle(color: AppColors.red,fontWeight: FontWeight.bold),
          )));
    }
  }

  void onClickOpenDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  String? categoryValidator() {
    if (categoryValue.isEmpty) {
      return StringConstants.categoryValue;
    } else {
      return null;
    }
  }

  String? subCategoryValidator() {
    if (subCategoryValue.isEmpty) {
      return StringConstants.subCategoryValue;
    } else {
      return null;
    }
  }

  String? descriptionValidator() {
    if (_descriptionController.text.isEmpty) {
      return StringConstants.descriptionValue;
    } else {
      return null;
    }
  }

  Future<PlatformFile?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
    // fileName = file.name.substring(0,fileName.length >10 ? 10 : fileName.length);
      fileName = file.name;
      debugPrint(fileName);
      return file;
    } else {
      return null;
    }
  }
}
