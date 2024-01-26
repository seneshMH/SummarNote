import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/presentation/filechat/chat_page.dart';
import 'package:summer_note/utils/ip.dart';
import 'package:summer_note/widgets/custom_elevated_button.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class FileuploadChatScreen extends StatefulWidget {
  FileuploadChatScreen({Key? key}) : super(key: key);

  @override
  State<FileuploadChatScreen> createState() => _FileuploadChatScreenState();
}

class _FileuploadChatScreenState extends State<FileuploadChatScreen> {
  double uploadProgress = 0.0;
  void initState() {
    super.initState();
    // Initialize the uploadProgress to 0.0
    uploadProgress = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 25.h, top: 134.v, right: 25.h),
                child: Column(children: [
                  SizedBox(height: 5.v),
                  _buildPdfUploadSection(context)
                ]))));
  }

  /// Section Widget
  /// Section Widget
  Widget _buildPdfUploadSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 53.h, vertical: 13.v),
      decoration: AppDecoration.outlineBlack900014
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Upload File Here", style: CustomTextStyles.titleLargeInter),
        SizedBox(height: 14.v),
        CustomImageView(
            imagePath: ImageConstant.imgIcon, height: 66.v, width: 90.h),
        SizedBox(height: 20.v),
        CustomElevatedButton(
          height: 46.v,
          text: "Analyse",
          margin: EdgeInsets.only(left: 24.h, right: 30.h),
          buttonStyle: CustomButtonStyles.fillLime,
          buttonTextStyle: CustomTextStyles.titleLargeInterOnErrorExtraBold,
          onPressed: () async {
            await _uploadFile(context, (double progress) {
              // Update the progress variable and trigger a rebuild
              setState(() {
                uploadProgress = progress;
              });
            });
          },
        ),
        SizedBox(height: 5.v),
        if (uploadProgress > 0.0 && uploadProgress < 1.0)
          LinearProgressIndicator(
            value: uploadProgress,
            backgroundColor: Colors.green,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
      ]),
    );
  }

  Future<void> _uploadFile(context, Function(double) onProgress) async {
    var dio = Dio();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc', 'txt', 'xlsx', 'xls'],
    );

    if (result != null) {
      File file = File(result.files.single.path ?? " ");

      String fileName = file.path.split("\\").last;
      String filePath = file.path;

      FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath,
            filename: fileName, contentType: MediaType('application', 'pdf'))
      });

      late ProgressDialog progressDialog;

      try {
        progressDialog =
            ProgressDialog(context, type: ProgressDialogType.normal);
        progressDialog.show();

        String ip = await IP.loadIpAddress();

        await dio.post(
          "http://$ip/data-ingestion",
          data: data,
          onSendProgress: (int sent, int total) {
            double progress = sent / total;
            onProgress(progress); // Report progress
          },
        );

        progressDialog.hide(); // Close the progress dialog

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatPage(),
        ));
      } catch (e) {
        progressDialog.hide(); // Close the progress dialog in case of an error

        if (e is DioException) {
          print("DioError: ${e.message}");
          // Handle DioError, possibly show a user-friendly error message
        } else {
          print("Unexpected error: $e");
          // Handle other unexpected errors
        }
      }
    } else {
      print("Result is null");
    }
  }
}
