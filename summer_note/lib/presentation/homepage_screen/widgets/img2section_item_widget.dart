import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';

// ignore: must_be_immutable
class Img2sectionItemWidget extends StatelessWidget {
  const Img2sectionItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return CustomImageView(
      imagePath: ImageConstant.imgImg21,
      height: 180.v,
      width: 360.h,
      margin: EdgeInsets.only(top: 1.v),
    );
  }
}
