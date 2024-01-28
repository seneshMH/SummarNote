import 'package:summer_note/models/summary_model.dart';

import '../homepage_screen/widgets/homepage_item_widget.dart';
import '../homepage_screen/widgets/img2section_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:summer_note/core/app_export.dart';

// ignore_for_file: must_be_immutable
class HomepageScreen extends StatelessWidget {
  HomepageScreen({Key? key, required this.summaries}) : super(key: key);

  int sliderIndex = 1;
  final List<Summary> summaries;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.gray200,
            body: SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  _buildHeaderSection(context),
                  _buildImg2Section(context),
                  SizedBox(height: 6.v),
                  SizedBox(
                      //height: 10.v,
                      child: AnimatedSmoothIndicator(
                          activeIndex: sliderIndex,
                          count: 2,
                          axisDirection: Axis.horizontal,
                          effect: ScrollingDotsEffect(
                              spacing: 12,
                              activeDotColor: theme.colorScheme.errorContainer,
                              dotColor:
                                  theme.colorScheme.onError.withOpacity(1),
                              dotHeight: 10.v,
                              dotWidth: 10.h))),
                  SizedBox(
                      height: 488.v,
                      width: 359.h,
                      child: Stack(alignment: Alignment.topCenter, children: [
                        _buildFortySevenSection(context),
                        _buildSummarizerSection(context),
                      ])),
                ]))));
  }

  /// Section Widget Top
  Widget _buildHeaderSection(BuildContext context) {
    return SizedBox(
        height: 89.v,
        width: double.maxFinite,
        child: Stack(alignment: Alignment.topLeft, children: [
          CustomImageView(
              imagePath: ImageConstant.imgVector1,
              height: 89.v,
              width: 277.h,
              alignment: Alignment.centerLeft),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 26.h, top: 19.v),
                  child: Text("Home", style: theme.textTheme.headlineLarge))),
          CustomImageView(
              imagePath: ImageConstant.imgHome,
              height: 25.v,
              width: 29.h,
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 113.h, bottom: 19.v)),
          Align(
              alignment: Alignment.topRight,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 11.h),
                  decoration: AppDecoration.fillBlack
                      .copyWith(borderRadius: BorderRadiusStyle.circleBorder29),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 4.v),
                        Text("SummarNOTE",
                            style: CustomTextStyles.titleMediumOnError)
                      ]))),
          CustomImageView(
              imagePath: ImageConstant.imgHistory,
              height: 25.adaptSize,
              width: 25.adaptSize,
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 59.h, bottom: 17.v),
              onTap: () {
                onTapImgHistory(context);
              }),
          CustomImageView(
              imagePath: ImageConstant.imgSearch,
              height: 28.adaptSize,
              width: 28.adaptSize,
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 10.h, bottom: 16.v),
              onTap: () {
                onTapImgSearch(context);
              })
        ]));
  }

  /// Section Widget
  Widget _buildImg2Section(BuildContext context) {
    return CarouselSlider.builder(
        options: CarouselOptions(
            height: 181.v,
            initialPage: 0,
            autoPlay: true,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              sliderIndex = index;
            }),
        itemCount: 2,
        itemBuilder: (context, index, realIndex) {
          return Img2sectionItemWidget();
        });
  }

  /// Section Widget
  Widget _buildFortySevenSection(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity, // Set width to take the full available width
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 31.v),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgGroup47),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Welcome to SummarNote",
                style: CustomTextStyles.titleSmallPoppins),
            SizedBox(height: 12.v),
            SizedBox(height: 20.v),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarizerSection(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text("Try Summarizer", style: theme.textTheme.headlineSmall),
              SizedBox(height: 9.v),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Adjust as needed
                children: [
                  Container(
                    width: 150.h,
                    height: 130.v, // Adjust the width as needed
                    child: HomepageItemWidget(
                      onTapPdfSummarizer: () {
                        onTapPdfSummarizer(context);
                      },
                      imagePath: ImageConstant.imgFile,
                      title: "File Summary",
                    ),
                  ),
                  Container(
                    width: 150.h,
                    height: 130.v, // Adjust the width as needed
                    child: HomepageItemWidget(
                      onTapPdfSummarizer: () {
                        onTapLinkSummarizer(context);
                      },
                      imagePath: ImageConstant.imgLink,
                      title: "Link Summary",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0), // Adjust the height as needed
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Adjust as needed
                children: [
                  Container(
                    width: 150.h,
                    height: 130.v, // Adjust the width as needed
                    child: HomepageItemWidget(
                      onTapPdfSummarizer: () {
                        onTapLinkSummarizer(context);
                      },
                      imagePath: ImageConstant.imgParagraph,
                      title: "Best Sentences",
                    ),
                  ),
                  Container(
                    width: 150.h,
                    height: 130.v, // Adjust the width as needed
                    child: HomepageItemWidget(
                      onTapPdfSummarizer: () {
                        onTapFileChat(context);
                      },
                      imagePath: ImageConstant.chatIcon,
                      title: "File Chat",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the pdfuploadScreen when the action is triggered.
  onTapPdfSummarizer(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.pdfuploadScreen,
        arguments: {'summaries': summaries});
  }

  onTapLinkSummarizer(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.linkuploadScreen,
        arguments: {'summaries': summaries});
  }

  onTapFileChat(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.fileuploadchatScreen);
  }

  /// Navigates to the historyScreen when the action is triggered.
  onTapImgHistory(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.historyScreen);
  }

  /// Navigates to the settingsScreen when the action is triggered.
  onTapImgSearch(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.settingsScreen);
  }
}
