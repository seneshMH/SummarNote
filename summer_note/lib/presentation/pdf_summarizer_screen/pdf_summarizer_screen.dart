import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/models/summary_model.dart';
import 'package:summer_note/widgets/app_bar/appbar_leading_image.dart';
import 'package:summer_note/widgets/app_bar/appbar_subtitle_one.dart';
import 'package:summer_note/widgets/app_bar/custom_app_bar.dart';
import 'package:summer_note/widgets/custom_elevated_button.dart';
import 'package:summer_note/widgets/custom_icon_button.dart';
import 'package:summer_note/widgets/custom_text_form_field.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class PdfSummarizerScreen extends StatefulWidget {
  final Summary summary;

  PdfSummarizerScreen({Key? key, required this.summary}) : super(key: key);

  @override
  _PdfSummarizerScreenState createState() => _PdfSummarizerScreenState();
}

class _PdfSummarizerScreenState extends State<PdfSummarizerScreen> {
  bool isParagraphView = true;
  TextEditingController keySevenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> words = widget.summary.body.split(' ');
    int wordCount = words.length;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildFive(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.h,
                      vertical: 3.v,
                    ),
                    decoration: AppDecoration.outlineBlack900012.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderTL25,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Summarized Content",
                          style: theme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 13.v),
                        Container(
                          margin: EdgeInsets.only(
                            left: 35.h,
                            right: 39.h,
                          ),
                          padding: EdgeInsets.all(3.h),
                          decoration: AppDecoration.outlineBlack900013.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomElevatedButton(
                                width: 111.h,
                                text: "Paragraphs",
                                leftIcon: Container(
                                  margin: EdgeInsets.only(right: 6.h),
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgParagraph,
                                    height: 16.adaptSize,
                                    width: 16.adaptSize,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isParagraphView = true;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: CustomElevatedButton(
                                  width: 111.h,
                                  text: "Points",
                                  leftIcon: Container(
                                    margin: EdgeInsets.only(right: 6.h),
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgParagraph,
                                      height: 16.adaptSize,
                                      width: 16.adaptSize,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isParagraphView = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 22.v),
                        _buildContent(context),
                        SizedBox(height: 2.v),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              "Words: $wordCount",
                              style: theme.textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.v),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 53.adaptSize,
                              width: 53.adaptSize,
                              padding: EdgeInsets.all(14.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgCopy,
                              ),
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: widget.summary.body));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Text copied to clipboard'),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.h),
                              child: CustomIconButton(
                                height: 53.adaptSize,
                                width: 53.adaptSize,
                                padding: EdgeInsets.all(14.h),
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgDownload,
                                ),
                                onTap: () {
                                  _saveTextToFile(widget.summary.body)
                                      .then((String filePath) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('File saved to: $filePath'),
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.h),
                              child: CustomIconButton(
                                height: 53.adaptSize,
                                width: 53.adaptSize,
                                padding: EdgeInsets.all(14.h),
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgShareAlt,
                                ),
                                onTap: () {
                                  Share.share(widget.summary.body);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 46.v),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _saveTextToFile(String textContent) async {
    try {
      String? outputFile = await FilePicker.platform
          .saveFile(dialogTitle: 'Save Your File to desired location');

      File returnedFile = File('$outputFile');
      await returnedFile.writeAsString(textContent);

      // Return the file path
      return returnedFile.path;
    } catch (e) {
      // Handle errors
      print('Error saving file: $e');
      return '';
    }
  }

  Widget _buildFive(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.v),
      decoration: AppDecoration.fillPrimary,
      child: Column(
        children: [
          CustomAppBar(
            leadingWidth: 36.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgArrowLeft,
              margin: EdgeInsets.only(
                left: 18.h,
                top: 1.v,
                bottom: 2.v,
              ),
            ),
            title: AppbarSubtitleOne(
              text: "Back",
              margin: EdgeInsets.only(left: 4.h),
              onTap: () {
                onTapBack(context);
              },
            ),
          ),
          SizedBox(height: 4.v),
          Text(
            "PDF File Summarizer",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.v),
          Text(
            "Results",
            style: CustomTextStyles.titleLargeSemiBold,
          ),
          SizedBox(height: 2.v),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.h,
        vertical: 16.v,
      ),
      decoration: AppDecoration.fillOnError.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              // Set this to true to always show the scrollbar
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: 272.h,
                  child: isParagraphView
                      ? _buildParagraphView(context)
                      : _buildBulletPointView(context),
                ),
              ),
            ),
          ),
          Container(
            height: 300.v,
            width: 6.h,
            margin: EdgeInsets.only(
              left: 10.h,
              top: 40.v,
              bottom: 56.v,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraphView(BuildContext context) {
    return SizedBox(
      width: 272.h,
      child: Text(
        widget.summary.body,
        textAlign: TextAlign.justify,
        style: theme.textTheme.bodySmall!.copyWith(
          fontSize: 18.0,
          height: 1.20,
        ),
      ),
    );
  }

  Widget _buildBulletPointView(BuildContext context) {
    List<String> lines = widget.summary.body.split('.');

    // Filter out empty lines before mapping to bullet points
    lines = lines.where((line) => line.trim().isNotEmpty).toList();

    String bulletPointsText = lines
        .map((line) => '• $line') // Prefix each line with a bullet point
        .join(
            '\n\n'); // Add an additional newline character between bullet points

    return SizedBox(
      width: 272.h,
      child: Text(
        bulletPointsText,
        textAlign: TextAlign.justify,
        style: theme.textTheme.bodySmall!.copyWith(
          fontSize: 14.0,
          height: 1.20,
        ),
      ),
    );
  }

  void onTapBack(BuildContext context) {
    //navigate back to home screen
    Navigator.pushNamed(context, AppRoutes.homepageScreen);
  }
}
