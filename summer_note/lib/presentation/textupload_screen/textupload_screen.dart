import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/widgets/custom_elevated_button.dart';
import 'package:summer_note/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class TextuploadScreen extends StatelessWidget {
  TextuploadScreen({Key? key}) : super(key: key);

  TextEditingController typeorpastevalueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 25.h, top: 134.v, right: 25.h),
                child: Column(children: [
                  SizedBox(height: 5.v),
                  _buildTextUploadTwo(context)
                ]))));
  }

  /// Section Widget
  Widget _buildTextUploadTwo(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 8.v),
        decoration: AppDecoration.outlineBlack900014
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("Insert Text Here", style: CustomTextStyles.titleLargeInter),
          SizedBox(height: 13.v),
          Column(children: [
            CustomTextFormField(
                controller: typeorpastevalueController,
                hintText: "type or paste...",
                textInputAction: TextInputAction.done,
                maxLines: 5,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 11.h, vertical: 9.v),
                borderDecoration: TextFormFieldStyleHelper.outlineGray),
            SizedBox(height: 14.v),
            CustomElevatedButton(
                height: 46.v,
                width: 150.h,
                text: "SUMMARIZE",
                buttonStyle: CustomButtonStyles.fillLime,
                buttonTextStyle:
                    CustomTextStyles.titleLargeInterOnErrorExtraBold,
                onPressed: () {
                  onTapSUMMARIZE(context);
                })
          ]),
          SizedBox(height: 9.v)
        ]));
  }

  /// Navigates to the textSummarizerScreen when the action is triggered.
  onTapSUMMARIZE(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.textSummarizerScreen);
  }
}
