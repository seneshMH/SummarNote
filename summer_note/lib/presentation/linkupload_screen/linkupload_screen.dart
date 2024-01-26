import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/models/summary_model.dart';
import 'package:summer_note/presentation/pdf_summarizer_screen/pdf_summarizer_screen.dart';
import 'package:summer_note/utils/ip.dart';
import 'package:summer_note/widgets/custom_elevated_button.dart';
import 'package:summer_note/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class LinkuploadScreen extends StatefulWidget {
  LinkuploadScreen({Key? key}) : super(key: key);

  @override
  State<LinkuploadScreen> createState() => _LinkuploadScreenState();
}

class _LinkuploadScreenState extends State<LinkuploadScreen> {
  TextEditingController insertlinkvalueController = TextEditingController();
  double uploadProgress = 0.0; // Initialize uploadProgress variable
  static List<Summary> summaries = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 25.h, top: 134.v, right: 25.h),
          child: Column(
            children: [
              SizedBox(height: 5.v),
              _buildLinkUploadColumn(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkUploadColumn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 7.v),
      decoration: AppDecoration.outlineBlack900014.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Insert Link Here",
            style: CustomTextStyles.titleLargeInter,
          ),
          SizedBox(height: 27.v),
          CustomTextFormField(
            controller: insertlinkvalueController,
            hintText: "insert link",
            textInputAction: TextInputAction.done,
            prefix: Container(
              margin: EdgeInsets.fromLTRB(9.h, 9.v, 7.h, 7.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgPaste,
                height: 25.adaptSize,
                width: 25.adaptSize,
              ),
            ),
            prefixConstraints: BoxConstraints(maxHeight: 42.v),
            contentPadding:
                EdgeInsets.only(top: 11.v, right: 30.h, bottom: 11.v),
          ),
          SizedBox(height: 37.v),
          CustomElevatedButton(
            height: 46.v,
            width: 150.h,
            text: "SUMMARIZE",
            buttonStyle: CustomButtonStyles.fillLime,
            buttonTextStyle: CustomTextStyles.titleLargeInterOnErrorExtraBold,
            onPressed: () async {
              await _uploadLink(context, (double progress) {
                // Update the progress variable and trigger a rebuild
                setState(() {
                  uploadProgress = progress;
                });
              });
            },
          ),
          SizedBox(height: 11.v),
        ],
      ),
    );
  }

  void onTapSUMMARIZE(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.linkSummarizerScreen);
  }

  Future<void> _uploadLink(context, Function(double) onProgress) async {
    var dio = Dio();
    late ProgressDialog progressDialog;

    try {
      progressDialog = ProgressDialog(context, type: ProgressDialogType.normal);
      progressDialog.show();

      String data = insertlinkvalueController.text;
      Uri uri = Uri.parse(data);
      String domain = uri.host;

      String ip = await IP.loadIpAddress();

      var response =
          await dio.post("http://$ip/summary-from-url", data: {'url': data});

      progressDialog.hide(); // Close the progress dialog

      Map<String, dynamic> jsonMap = json.decode(response.toString());

      final summary = Summary(title: domain, body: jsonMap['summary']);

      if (summary == null) {
        print("Summary is null");
        return;
      }

      summaries = await loadList();
      summaries.add(summary);

      await saveList(summaries);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PdfSummarizerScreen(
          summary: summary,
        ),
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
  }

  Future<void> saveList(List<Summary> listToSave) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'summariesKey';

    // Convert the list of summaries to a List<Map<String, dynamic>>
    final serializedList =
        listToSave.map((summary) => summary.toMap()).toList();

    // Convert the List<Map<String, dynamic>> to a JSON-encoded string
    final encodedList = json.encode(serializedList);

    // Save the JSON-encoded string to SharedPreferences
    prefs.setString(key, encodedList);
  }

  Future<List<Summary>> loadList() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'summariesKey';

    // Retrieve the JSON-encoded string from SharedPreferences
    final encodedList = prefs.getString(key);

    if (encodedList != null) {
      // Convert the JSON-encoded string back to a List<Map<String, dynamic>>
      final decodedList = json.decode(encodedList);

      // Convert the List<Map<String, dynamic>> to a List<Summary>
      final loadedList =
          List<Summary>.from(decodedList.map((map) => Summary.fromMap(map)));

      return loadedList;
    } else {
      return List.empty(growable: true);
    }
  }
}
