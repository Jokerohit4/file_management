
abstract class UploadFilesState{}

class UploadFilesLoading extends UploadFilesState{}

class UploadFilesLoaded extends UploadFilesState{

 final String categoryValue;
 final String subCategoryValue;
 final String fileUrl;

 UploadFilesLoaded({required this.categoryValue, required this.subCategoryValue,required this.fileUrl});

}


class UploadFilesError extends UploadFilesState{
 final String error;

  UploadFilesError({required this.error});
}