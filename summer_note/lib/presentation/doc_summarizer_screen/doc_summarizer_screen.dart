import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/widgets/app_bar/appbar_leading_image.dart';
import 'package:summer_note/widgets/app_bar/appbar_subtitle.dart';
import 'package:summer_note/widgets/app_bar/appbar_subtitle_one.dart';
import 'package:summer_note/widgets/app_bar/appbar_trailing_image.dart';
import 'package:summer_note/widgets/app_bar/custom_app_bar.dart';
import 'package:summer_note/widgets/custom_elevated_button.dart';
import 'package:summer_note/widgets/custom_icon_button.dart';
import 'package:summer_note/widgets/custom_text_form_field.dart';

class DocSummarizerScreen extends StatelessWidget {
  DocSummarizerScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController bulletsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildNine(context),
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.h),
                                child: CustomTextFormField(
                                  width: 111.h,
                                  controller: bulletsController,
                                  hintText: "Bullets",
                                  textInputAction: TextInputAction.done,
                                  prefix: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        8.h, 5.v, 12.h, 4.v),
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgBullets,
                                      height: 16.adaptSize,
                                      width: 16.adaptSize,
                                    ),
                                  ),
                                  prefixConstraints: BoxConstraints(
                                    maxHeight: 26.v,
                                  ),
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
                              "Words: 534",
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

  /// Section Widget
  Widget _buildNine(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.v),
      decoration: AppDecoration.fillPrimary,
      child: Column(
        children: [
          CustomAppBar(
            leadingWidth: 35.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgArrowLeft,
              margin: EdgeInsets.only(
                left: 17.h,
                top: 1.v,
                bottom: 2.v,
              ),
            ),
            title: AppbarSubtitleOne(
              text: "Back",
              margin: EdgeInsets.only(left: 4.h),
            ),
            actions: [
              AppbarSubtitle(
                text: "History",
                margin: EdgeInsets.only(
                  left: 16.h,
                  top: 1.v,
                ),
              ),
              AppbarTrailingImage(
                imagePath: ImageConstant.imgArrowLeft,
                margin: EdgeInsets.fromLTRB(3.h, 1.v, 16.h, 2.v),
              ),
            ],
          ),
          SizedBox(height: 4.v),
          Text(
            "Word File Summarizer",
            style: theme.textTheme.titleLarge,
          ),
          Text(
            "Results",
            style: CustomTextStyles.titleLargeSemiBold,
          ),
        ],
      ),
    );
  }

  /// Section Widget
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
            child: SizedBox(
              width: 272.h,
              child: Text(
                "                    William Shakespeare, born in 1564 in Stratford-upon-Avon, England, is celebrated as the world's greatest playwright, leaving an enduring legacy in literature and drama. His timeless works, such as \"Romeo and Juliet\" and \"Hamlet,\" explore universal themes like love, betrayal, and the complexities of human nature, making them enduring classics performed globally.\r\n\r\n     Beyond his narrative prowess, Shakespeare's linguistic influence is profound. He coined numerous words and phrases, enriching the English language and becoming integral to everyday speech. His unparalleled mastery of language, combined with insightful explorations of the human condition, distinguishes him as a literary giant.\r\n\r\n        Despite the passage of time, Shakespeare's impact endures. His works are studied, performed, and cherished worldwide, ensuring his lasting legacy in the cultural tapestry of humanity. From the stage to everyday language, Shakespeare's contributions continue to shape literature and communication, solidifying his status as a literary icon.\n\n        ",
                maxLines: 27,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: theme.textTheme.bodySmall!.copyWith(
                  height: 1.20,
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
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 300.v,
                    child: VerticalDivider(
                      width: 6.h,
                      thickness: 6.v,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 193.v,
                    child: VerticalDivider(
                      width: 5.h,
                      thickness: 5.v,
                      color: appTheme.gray800,
                      indent: 2.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
