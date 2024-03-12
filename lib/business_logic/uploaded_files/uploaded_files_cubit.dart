import 'package:file_management/business_logic/uploaded_files/uploaded_files_state.dart';
import 'package:file_management/services/authentication.dart';
import 'package:file_management/services/bloc/auth/auth_bloc.dart';
import 'package:file_management/services/bloc/auth/auth_event.dart';
import 'package:file_management/services/storage/firebase_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadedFilesCubit extends Cubit<UploadedFilesState> {
  final _firestore = CloudStorage();

  UploadedFilesCubit() : super(UploadedFilesLoaded(fileData: []));

  void fetchData() {
    emit(UploadedFilesLoading());
    final String? uid = Authentication.getCurrentUserID();
    if (uid != null) {
      _firestore.fetchData(uid).then((fileData) {
        emit(UploadedFilesLoaded(fileData: fileData));
      }).catchError((error) {
        emit(UploadedFilesError(error: error.toString()));
      });
    } else {
      emit(UploadedFilesError(error: "User not found"));
    }
  }

  void logout(BuildContext context){
    BlocProvider.of<AuthBloc>(context).add(
      AuthSignOutRequested(),
    );
  }

}
