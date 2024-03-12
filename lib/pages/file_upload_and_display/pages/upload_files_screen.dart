import 'package:dotted_border/dotted_border.dart';
import 'package:file_management/business_logic/upload_files/upload_files_cubit.dart';
import 'package:file_management/business_logic/upload_files/upload_files_state.dart';
import 'package:file_management/business_logic/uploaded_files/uploaded_files_cubit.dart';
import 'package:file_management/pages/file_upload_and_display/pages/uploaded_files_screen.dart';
import 'package:file_management/utils/constants/string_constants.dart';
import 'package:file_management/utils/extensions/extension.dart';
import 'package:file_management/utils/styles/app_colors.dart';
import 'package:file_management/utils/styles/app_text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadFileScreen extends StatelessWidget {
  const UploadFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
        key: context.read<UploadFilesCubit>().scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: isWide
            ? null
            : const UploadedFilesScreen(),
        body: SafeArea(
          child: Form(
            key: context.read<UploadFilesCubit>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(StringConstants.uploadDocuments,
                            style: AppTextStyle.subtitleTextStyle)
                        .paddingSymmetric(vertical: 0.05.sh),
                   isWide? const SizedBox.shrink()
                   : IconButton(
                        onPressed: () => context
                            .read<UploadFilesCubit>()
                            .onClickOpenDrawer(),
                        icon: const Icon(Icons.drive_file_move_sharp))
                  ],
                ),
                Row(
                  textBaseline: TextBaseline.ideographic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringConstants.selectCategory,
                          style: AppTextStyle.bodyTextStyle,
                        ),
                        0.1.sh.heightSizedBox,
                        Text(
                          StringConstants.selectSubCategory,
                          style: AppTextStyle.bodyTextStyle,
                        ),
                        0.15.sh.heightSizedBox,
                        Text(
                          StringConstants.description,
                          style: AppTextStyle.bodyTextStyle,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dropDownWithBuilder(true,isWide),
                        0.05.sh.heightSizedBox,
                        dropDownWithBuilder(false,isWide),
                        0.06.sh.heightSizedBox,
                        descriptionField(context,isWide),
                        dragAndDropBox(isWide),
                        uploadButton(context,isWide),
                      ],
                    ),
                  ],
                ),
              ],
            ).paddingLTRB(left: 0.01.sw,right: isWide ? 0 : 0.04.sw)
          ),
        ));
  }

  Widget descriptionField(BuildContext context,isWide) {
    return Container(
      width: isWide? 0.28.sw : 0.5.sw,
      height: 0.12.sh,
      margin: EdgeInsets.only(left: isWide ? 0.1.sw :0.2.sw),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        validator: (_) =>
            context.read<UploadFilesCubit>().descriptionValidator(),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: context.read<UploadFilesCubit>().descriptionController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 0.02.sw),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget dragAndDropBox(bool isWide) {
    return BlocBuilder<UploadFilesCubit, UploadFilesState>(
        builder: (context, state) {
      if (state is UploadFilesLoading) {
        return const CircularProgressIndicator()
            .paddingLTRB(left: 0.3.sw, top: 0.1.sh);
      } else if (state is UploadFilesLoaded) {
        return GestureDetector(
          onTap: () => context.read<UploadFilesCubit>().onClickUploadFiles(),
          child: Column(
            children: [
              DottedBorder(
                color: Colors.grey.shade400,
                strokeWidth: 1,
                child: Container(
                  width: isWide? 0.28.sw : 0.5.sw,
                  height: kIsWeb ? 0.23.sh : isWide ? 0.17.sh : 0.23.sh,
                  decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, weight: 0.2.sw),
                      Text(StringConstants.dragAndDropYourFilesHere,
                          style: AppTextStyle.bodyTextStyle
                              .copyWith(color: Colors.grey)),
                      Text(StringConstants.or,
                          style: AppTextStyle.bodyTextStyle
                              .copyWith(color: Colors.grey)),
                      Text(StringConstants.browseToUploadFiles,
                          style: AppTextStyle.bodyTextStyle
                              .copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
              ).paddingLTRB(left:isWide? 0.1.sw : 0.2.sw, top: isWide? 0.01.sh:0.05.sh),
              Text(context.read<UploadFilesCubit>().fileName),
            ],
          ),
        );
      } else if (state is UploadFilesError) {
        return Text('Error: ${state.error}');
      } else {
        return const SizedBox(); // Fallback to an empty widget
      }
    });
  }

  Widget dropDownWithBuilder(bool isCategory,bool isWide) {
    return BlocBuilder<UploadFilesCubit, UploadFilesState>(
        builder: (context, state) {
      String categoryValue =
          state is UploadFilesLoaded ? state.categoryValue : "";
      if (isCategory) {
        return dropDown(isCategory, context, categoryValue,isWide);
      } else {
        if (state is UploadFilesLoading) {
          return const CircularProgressIndicator()
              .paddingLTRB(left: 0.3.sw, top: 0.sh);
        } else if (state is UploadFilesLoaded) {
          return dropDown(isCategory, context, categoryValue,isWide);
        } else if (state is UploadFilesError) {
          return Text('Error: ${state.error}');
        } else {
          return const SizedBox(); // Fallback to an empty widget
        }
      }
    });
  }

  Widget dropDown(bool isCategory, BuildContext context, String categoryValue,bool isWide) {
    int index = categoryValue.isNotEmpty
        ? context.read<UploadFilesCubit>().giveIndex(categoryValue) + 1
        : 0;
    return Container(
      width: isWide ? 0.28.sw :0.55.sw,
      height:isWide ? 0.1.sh : 0.07.sh,
      margin: EdgeInsets.only(left: isWide ? 0.1.sw :0.2.sw),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(4)),
      child: DropdownButtonFormField<String>(
          value: isCategory
              ? context.read<UploadFilesCubit>().categoryValue.isEmpty
              ? null
              : context.read<UploadFilesCubit>().categoryValue
              : context.read<UploadFilesCubit>().subCategoryValue.isEmpty
                  ? null
                  : context.read<UploadFilesCubit>().subCategoryValue,
          validator: (_) => isCategory
              ? context.read<UploadFilesCubit>().categoryValidator()
              : context.read<UploadFilesCubit>().subCategoryValidator(),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: kIsWeb? 0.03.sw : 0.007.sw, vertical: kIsWeb ? 0.02.sh : isWide ? 0 :0.01.sh),
            hintText: isCategory ? "Select Category" : "Sub Category",
            border: InputBorder.none,
            suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ),
          icon: const SizedBox(),
          items: isCategory
              ? context.read<UploadFilesCubit>().categories.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList()
              : context.read<UploadFilesCubit>().subCategory[index],
          onChanged: (value) => isCategory
              ? context
                  .read<UploadFilesCubit>()
                  .onChangeCategory(value.toString())
              : context
                  .read<UploadFilesCubit>()
                  .onChangeSubCategory(value.toString())),
    );
  }

  Widget uploadButton(BuildContext context,bool isWide) {
    return GestureDetector(
      onTap: () =>
          context.read<UploadFilesCubit>().onClickUploadButton(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.01.sh, horizontal: isWide ? 0.11.sw : 0.2.sw),
        margin: EdgeInsets.only(left: isWide ? 0.1.sw:0.2.sw, top: isWide ? 0.005.sh: 0.02.sh),
        color: AppColors.black,
        child: Center(
          child: Text(
            StringConstants.upload,
            style: AppTextStyle.subtitleTextStyle
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
