import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/widgets/custom_elevated_button.dart';

class DocuploadScreen extends StatelessWidget {
  const DocuploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 25.h, top: 134.v, right: 25.h),
                child: Column(children: [
                  SizedBox(height: 5.v),
                  _buildDocUploadSection(context)
                ]))));
  }

  /// Section Widget
  Widget _buildDocUploadSection(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 46.h, vertical: 13.v),
        decoration: AppDecoration.outlineBlack900014
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("Upload Word File Here",
              style: CustomTextStyles.titleLargeInter),
          SizedBox(height: 14.v),
          CustomImageView(
              imagePath: ImageConstant.imgIcon, height: 66.v, width: 90.h),
          SizedBox(height: 20.v),
          CustomElevatedButton(
              height: 46.v,
              width: 150.h,
              text: "SUMMARIZE",
              buttonStyle: CustomButtonStyles.fillLime,
              buttonTextStyle: CustomTextStyles.titleLargeInterOnErrorExtraBold,
              onPressed: () {
                onTapSUMMARIZE(context);
              }),
          SizedBox(height: 5.v)
        ]));
  }

  /// Navigates to the pdfSummarizerScreen when the action is triggered.
  onTapSUMMARIZE(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.pdfSummarizerScreen);
  }
}
