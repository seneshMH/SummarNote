import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/models/summary_model.dart';
import 'package:summer_note/presentation/text_summarizer_screen/text_summarizer_screen.dart';
import 'package:summer_note/utils/ip.dart';
import 'package:summer_note/widgets/custom_elevated_button.dart';
import 'package:summer_note/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable

class TextuploadScreen extends StatefulWidget {
  const TextuploadScreen({Key? key}) : super(key: key);

  @override
  _TextuploadScreenState createState() => _TextuploadScreenState();
}

class _TextuploadScreenState extends State<TextuploadScreen> {
  TextEditingController typeorpastevalueController = TextEditingController();
  double sliderValue = 30.0; // Default slider value (in percentage)

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 25.h, top: 134.v, right: 25.h),
          child: Column(
            children: [
              SizedBox(height: 5.v),
              _buildTextUploadTwo(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildTextUploadTwo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 8.v),
      decoration: AppDecoration.outlineBlack900014
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Insert Text Here", style: CustomTextStyles.titleLargeInter),
          SizedBox(height: 13.v),
          Column(
            children: [
              CustomTextFormField(
                controller: typeorpastevalueController,
                hintText: "type or paste...",
                textInputAction: TextInputAction.done,
                maxLines: 5,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 11.h, vertical: 9.v),
                borderDecoration: TextFormFieldStyleHelper.outlineGray,
              ),
              SizedBox(height: 14.v),
              Slider(
                value: sliderValue,
                activeColor: Colors.yellow.shade700,
                min: 0.0,
                max: 100.0,
                onChanged: (value) {
                  // Update the slider value
                  setState(() {
                    sliderValue = value;
                  });
                },
              ),
              SizedBox(height: 8.v), // Adjust the spacing as needed
              Text(
                "Sentences Count: ${sliderValue.toStringAsFixed(1)}%", // Display the slider value with one decimal place
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 14.v),
              CustomElevatedButton(
                height: 46.v,
                width: 150.h,
                text: "EXTRACT",
                buttonStyle: CustomButtonStyles.fillLime,
                buttonTextStyle:
                    CustomTextStyles.titleLargeInterOnErrorExtraBold,
                onPressed: () {
                  _uploadText(context);
                },
              ),
            ],
          ),
          SizedBox(height: 9.v),
        ],
      ),
    );
  }

  Future<void> _uploadText(context) async {
    var dio = Dio();
    late ProgressDialog progressDialog;

    try {
      progressDialog = ProgressDialog(context, type: ProgressDialogType.normal);
      progressDialog.show();

      String data = typeorpastevalueController.text;
      Uri uri = Uri.parse(data);
      String domain = uri.host;

      String ip = await IP.loadIpAddress();

      if (sliderValue <= 30.0) {
        sliderValue = 30.0;
      }

      double percentage = sliderValue / 100.0;

      var response = await dio.post("http://$ip/extract",
          data: {'text': data, 'percentage': percentage});
      progressDialog.hide(); // Close the progress dialog

      Map<String, dynamic> responseMap = jsonDecode(response.toString());

      // Extract the "best_sentences" array
      List<String> bestSentences =
          List<String>.from(responseMap['best_sentences']);

      // Convert the array into a paragraph
      String paragraph = bestSentences.join();

      print(paragraph);

      //Map<String, dynamic> jsonMap = json.decode(response.toString());

      final summary = Summary(title: domain, body: paragraph);

      if (summary == null) {
        print("Text is null");
        return;
      }

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TextSummarizerScreen(
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

  /// Navigates to the textSummarizerScreen when the action is triggered.
  onTapSUMMARIZE(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.textSummarizerScreen);
  }
}
