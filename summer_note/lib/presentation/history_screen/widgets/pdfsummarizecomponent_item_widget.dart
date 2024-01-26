import 'package:flutter/material.dart';

import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/models/summary_model.dart';
import 'package:summer_note/presentation/pdf_summarizer_screen/pdf_summarizer_screen.dart';

// ignore: must_be_immutable
class PdfsummarizecomponentItemWidget extends StatelessWidget {
  PdfsummarizecomponentItemWidget(
      {Key? key,
      required this.summary,
      required this.deleteItem,
      required this.index})
      : super(
          key: key,
        );

  final Summary summary;
  final int index;
  final Function(int) deleteItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PdfSummarizerScreen(
                    summary: summary,
                  )));
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 7.h,
            vertical: 2.v,
          ),
          decoration: AppDecoration.outlineBlack900011.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgFilePdf,
                      height: 17.adaptSize,
                      width: 17.adaptSize,
                      margin: EdgeInsets.symmetric(vertical: 6.v),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: Text(
                        summary.title,
                        style: CustomTextStyles.titleLargeSemiBold,
                      ),
                    ),
                    Spacer(),
                    // CustomImageView(
                    //   imagePath: ImageConstant.imgPin,
                    //   height: 24.adaptSize,
                    //   width: 24.adaptSize,
                    //   margin: EdgeInsets.only(top: 6.v),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 17.v),
              Container(
                width: 268.h,
                margin: EdgeInsets.only(
                  left: 14.h,
                  right: 12.h,
                ),
                child: Text(
                  summary.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 31.v),
              Padding(
                padding: EdgeInsets.only(
                  left: 2.h,
                  right: 1.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 12.adaptSize,
                      width: 12.adaptSize,
                      margin: EdgeInsets.only(
                        top: 12.v,
                        bottom: 6.v,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(1),
                        borderRadius: BorderRadius.circular(
                          6.h,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 5.h,
                        top: 8.v,
                      ),
                      // child: Text(
                      //   "Today ",
                      //   style: theme.textTheme.bodyMedium,
                      // ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          deleteItem(index);
                        },
                        icon: Icon(Icons.delete)),
                    // CustomImageView(
                    //   imagePath: ImageConstant.imgTrashAlt,
                    //   height: 25.adaptSize,
                    //   width: 25.adaptSize,
                    //   margin: EdgeInsets.only(bottom: 6.v),
                    //   onTap: () {
                    //     deleteItem(index);
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
