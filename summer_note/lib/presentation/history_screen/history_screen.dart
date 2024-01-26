import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:summer_note/models/summary_model.dart';

import '../history_screen/widgets/pdfsummarizecomponent_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/widgets/custom_drop_down.dart';

// ignore_for_file: must_be_immutable
class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  Future<List<Summary>>? summariesFuture;

  @override
  Widget build(BuildContext context) {
    summariesFuture = loadList();
    return SafeArea(
        child: Scaffold(
            backgroundColor: theme.colorScheme.onError.withOpacity(1),
            body: SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  _buildHeader(context),
                  SizedBox(height: 10.v),
                  //_buildFilterByCategory(context),
                  SizedBox(height: 10.v),

                  _buildPdfSummarizeComponent(context),
                  SizedBox(height: 6.v)
                ]))));
  }

  /// Section Widget
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
        height: 89.v,
        width: double.maxFinite,
        child: Stack(alignment: Alignment.topRight, children: [
          CustomImageView(
              imagePath: ImageConstant.imgVector1,
              height: 89.v,
              width: 277.h,
              alignment: Alignment.centerLeft),
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
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(25.h, 21.v, 10.h, 16.v),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 6.v),
                            child: Text("History",
                                style: theme.textTheme.headlineLarge)),
                        Spacer(flex: 72),
                        CustomImageView(
                            imagePath: ImageConstant.imgHistory,
                            height: 25.adaptSize,
                            width: 25.adaptSize,
                            margin: EdgeInsets.only(top: 24.v)),
                        Spacer(flex: 27),
                        CustomImageView(
                            imagePath: ImageConstant.imgHome,
                            height: 25.v,
                            width: 29.h,
                            margin: EdgeInsets.only(top: 22.v, bottom: 3.v),
                            onTap: () {
                              onTapImgHome(context);
                            }),
                        CustomImageView(
                            imagePath: ImageConstant.imgSearch,
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            margin: EdgeInsets.only(left: 18.h, top: 23.v),
                            onTap: () {
                              onTapImgSearch(context);
                            })
                      ])))
        ]));
  }

  /// Section Widget
  Widget _buildFilterByCategory(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 23.h),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: EdgeInsets.only(top: 1.v),
              child: Text("Filter by category",
                  style: CustomTextStyles.titleMediumInter)),
          CustomDropDown(
              width: 90.h,
              hintText: "Choose",
              hintStyle: CustomTextStyles.titleMediumInter,
              items: dropdownItemList,
              onChanged: (value) {})
        ]));
  }

  /// Section Widget
  Widget _buildPdfSummarizeComponent(BuildContext context) {
    return Expanded(
        child: Scrollbar(
            child: SingleChildScrollView(
                child: Container(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("${summaries.length} Documents",
          //     style: CustomTextStyles.bodyMediumInter),
          SizedBox(height: 15.v),
          FutureBuilder<List<Summary>>(
            future: summariesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data available.');
              } else {
                List<Summary> summaries = snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20.v);
                  },
                  itemCount: summaries.length,
                  itemBuilder: (context, index) {
                    // Assuming PdfsummarizecomponentItemWidget requires a Summary
                    return PdfsummarizecomponentItemWidget(
                      summary: summaries[index],
                      index: index,
                      deleteItem: deleteItem,
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    ))));
  }

  /// Navigates to the homepageScreen when the action is triggered.
  onTapImgHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.homepageScreen);
  }

  /// Navigates to the settingsScreen when the action is triggered.
  onTapImgSearch(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.settingsScreen);
  }

  Future<void> deleteItem(int index) async {
    // Load the list
    List<Summary> loadedList = await loadList();

    // Check if the index is within the bounds of the list
    if (index >= 0 && index < loadedList.length) {
      // Remove the item at the specified index
      loadedList.removeAt(index);

      // Save the updated list
      await saveList(loadedList);

      setState(() {});
    }
  }

  Future<void> saveList(List<Summary> listToSave) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'summariesKey';

    // Convert the list of summaries to a List<Map<String, dynamic>>
    final serializedList =
        listToSave.map((summary) => summary.toMap()).toList();

    // Convert the List<Map<String, dynamic>> to a JSON-encoded string
    final encodedList = json.encode(serializedList);

    // Save the JSON-encoded string to SharedPreferences
    prefs.setString(key, encodedList);
  }

  Future<List<Summary>> loadList() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'summariesKey';

    // Retrieve the JSON-encoded string from SharedPreferences
    final encodedList = prefs.getString(key);

    if (encodedList != null) {
      // Convert the JSON-encoded string back to a List<Map<String, dynamic>>
      final decodedList = json.decode(encodedList);

      // Convert the List<Map<String, dynamic>> to a List<Summary>
      final loadedList =
          List<Summary>.from(decodedList.map((map) => Summary.fromMap(map)));

      return loadedList;
    }

    // Return an empty list if the key is not present in SharedPreferences
    return [];
  }
}
