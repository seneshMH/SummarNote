import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'dart:async';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 2),
      () =>
          Navigator.of(context).pushReplacementNamed(AppRoutes.homepageScreen),
    );

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          //width: SizeUtils.width,
          //height: SizeUtils.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0.45),
              end: Alignment(0.5, 0),
              colors: [
                theme.colorScheme.primary.withOpacity(1),
                theme.colorScheme.onError.withOpacity(1),
              ],
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 66.v),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(
                  flex: 40,
                ),
                SizedBox(
                  height: 191.adaptSize,
                  width: 191.adaptSize,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 190.adaptSize,
                          width: 190.adaptSize,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onError.withOpacity(1),
                            borderRadius: BorderRadius.circular(
                              95.h,
                            ),
                          ),
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgLogosm1,
                        //height: 181.v,
                        //width: 182.h,
                        alignment: Alignment.bottomLeft,
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 59,
                ),
                Text(
                  "version 1.0",
                  style: CustomTextStyles.titleLargeInterOnError,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
