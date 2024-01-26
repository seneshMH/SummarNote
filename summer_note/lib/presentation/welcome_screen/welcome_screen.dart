import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/widgets/app_bar/appbar_title.dart';
import 'package:summer_note/widgets/app_bar/custom_app_bar.dart';
import 'package:summer_note/widgets/custom_outlined_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.gray200,
            body: SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  _buildOne(context),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.h, vertical: 34.v),
                      child: Column(children: [
                        _buildThree(context),
                        SizedBox(height: 10.v),
                        SizedBox(
                            height: 464.v,
                            width: 310.h,
                            child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Opacity(
                                      opacity: 0.8,
                                      child: CustomImageView(
                                          imagePath:
                                              ImageConstant.imgUndrawJoinReW1lh,
                                          height: 227.v,
                                          width: 229.h,
                                          alignment: Alignment.topCenter)),
                                  _buildSixtyOne(context)
                                ])),
                        SizedBox(height: 19.v),
                        CustomOutlinedButton(
                            width: 130.h,
                            text: "Get Start",
                            onPressed: () {
                              onTapGetStart(context);
                            }),
                        SizedBox(height: 5.v)
                      ]))
                ]))));
  }

  /// Section Widget
  Widget _buildOne(BuildContext context) {
    return Container(
        decoration: AppDecoration.fillGray600
            .copyWith(borderRadius: BorderRadiusStyle.customBorderBL25),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 16.v),
          CustomAppBar(
              height: 75.v,
              centerTitle: true,
              title: AppbarTitle(text: "Welcome to SummerNOTE"),
              styleType: Style.bgFill)
        ]));
  }

  /// Section Widget
  Widget _buildThree(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 11.h, right: 6.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.only(top: 1.v),
              child: Text("A", style: CustomTextStyles.headlineLargePrimary)),
          Padding(
              padding: EdgeInsets.only(left: 1.h),
              child: Text("I PDF Summarizer",
                  style: theme.textTheme.headlineLarge))
        ]));
  }

  /// Section Widget
  Widget _buildSixtyOne(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 24.v),
            decoration: AppDecoration.outlineBlack
                .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
            child: Container(
                width: 292.h,
                margin: EdgeInsets.only(left: 7.h),
                child: Text(
                    "Your Ultimate Summarizing Companion! Simplify complex information effortlessly with our user-friendly app. \n\nEnjoy concise and clear summaries tailored to your needs. \n\nSay goodbye to information overload and hello to streamlined understanding. \n\nLet SummerNote be your go-to tool for efficient summarization!\"",
                    maxLines: 12,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.bodyMedium14
                        .copyWith(height: 1.20)))));
  }

  /// Navigates to the homepageScreen when the action is triggered.
  onTapGetStart(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.homepageScreen);
  }
}
