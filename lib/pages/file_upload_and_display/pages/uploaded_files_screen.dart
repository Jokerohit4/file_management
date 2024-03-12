import 'package:file_management/business_logic/uploaded_files/uploaded_files_cubit.dart';
import 'package:file_management/business_logic/uploaded_files/uploaded_files_state.dart';
import 'package:file_management/utils/constants/string_constants.dart';
import 'package:file_management/utils/extensions/extension.dart';
import 'package:file_management/utils/styles/app_colors.dart';
import 'package:file_management/utils/styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadedFilesScreen extends StatelessWidget {
  const UploadedFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UploadedFilesCubit>().fetchData();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(StringConstants.yourUploadedFiles,
                    style: AppTextStyle.subtitleTextStyle)
                .paddingSymmetric(vertical: 0.05.sh),
            BlocBuilder<UploadedFilesCubit, UploadedFilesState>(
              builder: (context, state) {
                if (state is UploadedFilesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UploadedFilesLoaded) {
                  return Expanded(
                    child: Table(
                      columnWidths:  <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FixedColumnWidth(0.3.sw),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        heading(),
                        divider(),
                        ...state.fileData.map((file) {
                          return TableRow(children: [
                            Text(file.category).paddingSymmetric(),
                            Text(file.subCategory),
                            Text(file.description),
                          ]);
                        }).toList(),
                      ],
                    ),
                  );
                } else if (state is UploadedFilesError) {
                  return Text('Error: ${state.error}');
                } else {
                  return const SizedBox(); // Fallback to an empty widget
                }
              },
            ),
            logoutButton(context),
          ],
        ).paddingSymmetric(horizontal: 0.05.sw),
      ),
    );
  }

  TableRow heading() {
    return TableRow(children: [
      Text(StringConstants.category, style: AppTextStyle.subtitleTextStyle),
      Text(StringConstants.subCategory, style: AppTextStyle.subtitleTextStyle)
          .paddingSymmetric(horizontal: 0.05.sw),
      Text(StringConstants.description, style: AppTextStyle.subtitleTextStyle)
    ]);
  }

  TableRow divider() {
    return const TableRow(children: [
      Divider(color: Colors.grey, thickness: 1),
      Divider(color: Colors.grey, thickness: 1),
      Divider(color: Colors.grey, thickness: 1),
    ]);
  }

  Widget logoutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => context.read<UploadedFilesCubit>().logout(context),
          child: Container(
            width: 0.3.sw,
            padding: EdgeInsets.symmetric(vertical: 0.01.sh, horizontal: 0.05.sw),
            margin: EdgeInsets.symmetric(vertical: 0.01.sh),
            color: AppColors.black,
            child: Center(
              child: Text(
                StringConstants.logOut,
                style: AppTextStyle.subtitleTextStyle
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
