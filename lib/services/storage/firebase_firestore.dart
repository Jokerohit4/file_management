import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_management/services/models/file_data.dart';
import 'package:file_management/utils/constants/app_keys.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';



class CloudStorage{









  Future <void> assignUser(Map<String,dynamic> userData,String uid) async {
    try{
      final collection = FirebaseFirestore.instance.collection(AppKeys.users).doc(uid);
      await collection.set(userData);
    }
    catch(error){
      debugPrint('Error fetching data: $error');
    }
  }






 Future<List<FileData>> fetchData(String userId) async {

    print(userId);
    List<FileData> data = [];
    try {
      QuerySnapshot querySnapshot = await  FirebaseFirestore.instance
          .collection(AppKeys.users)
          .doc(userId)
          .collection(AppKeys.storage)
          .get();
      for (var doc in querySnapshot.docs) {
        data.add(FileData.fromFirestore(doc));
      }
    } catch (error) {
      debugPrint('Error fetching data: $error');
    }
    return data;
  }

 Future<void> saveFileDetailsToFirestore(Map<String,dynamic> fileData,String userId) async {
   try{
     final collection = FirebaseFirestore.instance.collection(AppKeys.users).doc(userId).collection(AppKeys.storage);
     await collection.add(fileData);
   }
   catch(error){
     debugPrint('Error fetching data: $error');
   }
 }


  Future<String?> uploadFile(PlatformFile file) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('uploads/${file.name}');

      if (kIsWeb) {
        Uint8List? fileBytes = file.bytes;
        if (fileBytes == null) return null;
        final result = await ref.putData(fileBytes);
        String url = await result.ref.getDownloadURL();
        return url;
      }
      else {
        File fileToUpload = File(file.path!);
        final result = await ref.putFile(fileToUpload);
        String url = await result.ref.getDownloadURL();
        return url;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

}