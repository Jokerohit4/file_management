

import 'package:file_management/services/models/file_data.dart';

abstract class UploadedFilesState{}

class UploadedFilesLoading extends UploadedFilesState{}

class UploadedFilesLoaded extends UploadedFilesState{
  final List<FileData> fileData;

  UploadedFilesLoaded({required this.fileData});
}

class UploadedFilesError extends UploadedFilesState{
  final String error;

  UploadedFilesError({required this.error});

}