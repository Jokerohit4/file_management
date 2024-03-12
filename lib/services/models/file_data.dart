import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_management/utils/constants/app_keys.dart';
import 'package:file_management/utils/constants/string_constants.dart';

class FileData {
  final String category;
  final String subCategory;
  final String description;

  FileData(
      {required this.category,
      required this.subCategory,
      required this.description});

  factory FileData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    print("gggggggggggggggggggggggggggggggggggggggggggggggggggg");
    print(data);
    return FileData(
      category: data[AppKeys.category],
      subCategory: data[AppKeys.subCategory],
      description: data[AppKeys.description],
    );
  }
}
