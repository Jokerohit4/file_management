import 'package:file_management/pages/file_upload_and_display/pages/upload_files_screen.dart';
import 'package:file_management/pages/file_upload_and_display/pages/uploaded_files_screen.dart';
import 'package:flutter/material.dart';


class FileUploadAndDisplayScreen extends StatelessWidget {
  const FileUploadAndDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return isWide
    ? const Row(
      children: [
        Flexible(flex: 9,child: UploadFileScreen()),
        Flexible(flex: 7,child: UploadedFilesScreen()),
      ],
    )
    : const UploadFileScreen();
  }
}
