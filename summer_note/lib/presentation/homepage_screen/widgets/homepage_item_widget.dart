import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';

// ignore: must_be_immutable
class HomepageItemWidget extends StatelessWidget {
  HomepageItemWidget({
    Key? key,
    this.onTapPdfSummarizer,
    required this.imagePath,
    required this.title,
  }) : super(
          key: key,
        );

  VoidCallback? onTapPdfSummarizer;
  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapPdfSummarizer!.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 11.h,
          vertical: 5.v,
        ),
        decoration: AppDecoration.outlineBlack90001.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder14,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 13.v),
            CustomImageView(
              imagePath: imagePath,
              height: 65.v,
              width: 48.h,
            ),
            SizedBox(height: 3.v),
            Text(
              title,
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
