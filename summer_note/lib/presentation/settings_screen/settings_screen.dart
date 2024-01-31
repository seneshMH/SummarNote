import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/utils/ip.dart';
import 'package:summer_note/widgets/custom_drop_down.dart';
import 'package:summer_note/widgets/custom_drop_down_button.dart';

// ignore_for_file: must_be_immutable
class SettingsScreen extends StatelessWidget {
  List<String> dropdownItemList = [];
  List<String> dropdownItemList1 = [];
  List<String> dropdownItemList2 = [];
  List<String> dropdownItemList3 = [];
  List<String> dropdownItemList4 = [];

  late TextEditingController ipAddressController = TextEditingController();

  SettingsScreen({Key? key}) : super(key: key) {
    _initializeController();
  }

  void _initializeController() async {
    //String ip = await IP.loadIpAddress();
    //ipAddressController = TextEditingController(text: ip);
    ipAddressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onError.withOpacity(1),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeaderSection(context),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 21.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: TextField(
                          controller: ipAddressController,
                          decoration: InputDecoration(
                            hintText: 'Enter IP Address for Debugging',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    TextButton(
                      onPressed: () {
                        String ipAddress = ipAddressController.text;
                        debugConnection(ipAddress, context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Debug Connection',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                  padding: EdgeInsets.only(left: 21.h, right: 60.h),
                  child: CustomDropDownButton(
                    hintText: "Terms & Conditions",
                    items: dropdownItemList,
                    prefix: Container(
                        margin: EdgeInsets.fromLTRB(4.h, 6.v, 7.h, 5.v),
                        child: CustomImageView(
                            imagePath: ImageConstant.imgPolicies,
                            height: 25.adaptSize,
                            width: 25.adaptSize)),
                    prefixConstraints: BoxConstraints(maxHeight: 36.v),
                    onTap: () {
                      _showTermsAndConditionsDialog(context);
                    },
                  )),
              SizedBox(height: 21.v),
              Padding(
                  padding: EdgeInsets.only(left: 21.h, right: 60.h),
                  child: CustomDropDownButton(
                    hintText: "About",
                    items: dropdownItemList1,
                    prefix: Container(
                        margin: EdgeInsets.fromLTRB(5.h, 8.v, 9.h, 6.v),
                        child: CustomImageView(
                            imagePath: ImageConstant.imgVideocamera,
                            height: 22.adaptSize,
                            width: 22.adaptSize)),
                    prefixConstraints: BoxConstraints(maxHeight: 36.v),
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  )),
              SizedBox(height: 19.v),
              Padding(
                  padding: EdgeInsets.only(left: 21.h, right: 60.h),
                  child: CustomDropDownButton(
                      hintText: "Feedback",
                      items: dropdownItemList2,
                      prefix: Container(
                          margin: EdgeInsets.fromLTRB(4.h, 6.v, 8.h, 6.v),
                          child: CustomImageView(
                              imagePath: ImageConstant.imgFeedback,
                              height: 24.adaptSize,
                              width: 24.adaptSize)),
                      prefixConstraints: BoxConstraints(maxHeight: 36.v),
                      onTap: () {
                        _showFeedbackDialog(context);
                      })),
              SizedBox(height: 21.v),
              Padding(
                  padding: EdgeInsets.only(left: 21.h, right: 60.h),
                  child: CustomDropDownButton(
                      hintText: "Help",
                      items: dropdownItemList3,
                      prefix: Container(
                          margin: EdgeInsets.fromLTRB(4.h, 6.v, 7.h, 6.v),
                          child: CustomImageView(
                              imagePath: ImageConstant.imgHelp,
                              height: 24.adaptSize,
                              width: 24.adaptSize)),
                      prefixConstraints: BoxConstraints(maxHeight: 36.v),
                      onTap: () {
                        _showHelpDialog(context);
                      })),
              SizedBox(height: 20.v),
              Padding(
                  padding: EdgeInsets.only(left: 21.h, right: 60.h),
                  child: CustomDropDownButton(
                      hintText: "Share",
                      items: dropdownItemList4,
                      prefix: Container(
                          margin: EdgeInsets.fromLTRB(4.h, 6.v, 6.h, 6.v),
                          child: CustomImageView(
                              imagePath: ImageConstant.imgShare,
                              height: 24.adaptSize,
                              width: 24.adaptSize)),
                      prefixConstraints: BoxConstraints(maxHeight: 36.v),
                      onChanged: (value) {})),
              SizedBox(height: 66.0),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "version 1.0",
                  style: CustomTextStyles.titleLargeInterGray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeaderSection(BuildContext context) {
    return SizedBox(
        height: 89.v,
        width: double.maxFinite,
        child: Stack(alignment: Alignment.topRight, children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: 277.h,
                  margin: EdgeInsets.only(right: 83.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.h, vertical: 16.v),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(ImageConstant.imgVector1),
                          fit: BoxFit.cover)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 5.v, bottom: 6.v),
                            child: Text("Settings",
                                style: theme.textTheme.headlineLarge)),
                        CustomImageView(
                            imagePath: ImageConstant.imgSearch,
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            margin: EdgeInsets.only(left: 69.h, top: 29.v))
                      ]))),
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
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.only(right: 10.h, bottom: 17.v),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageView(
                            imagePath: ImageConstant.imgHome,
                            height: 25.v,
                            width: 29.h,
                            margin: EdgeInsets.only(bottom: 1.v),
                            onTap: () {
                              onTapImgHome(context);
                            }),
                        CustomImageView(
                            imagePath: ImageConstant.imgHistory,
                            height: 25.adaptSize,
                            width: 25.adaptSize,
                            margin: EdgeInsets.only(left: 20.h, top: 2.v),
                            onTap: () {
                              onTapImgHistory(context);
                            })
                      ])))
        ]));
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: "Summar Note",
          applicationVersion: "1.0",
          applicationLegalese: "Copyright © 2024 Summar Note",
          applicationIcon: Image.asset(
            ImageConstant.imgLogosm1,
            height: 50,
            width: 50,
          ),
        );
      },
    );
  }

  void _showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Terms and Conditions"),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          children: [
            Text(
              """
Document Summarization:

1. Accuracy of Summaries:

  While the App employs advanced summarization algorithms, the accuracy of summaries cannot be guaranteed. Users should verify the generated summaries for critical applications.

2. Intellectual Property:

  Users retain ownership of the content they upload. By uploading, users grant SummarNote the right to use, modify, and store the content for the purpose of providing the summarization service.""",
              style: TextStyle(fontSize: 16.0),
            ),
            // You can add more Text widgets or any other widgets as needed
          ],
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Help"),
          content: Container(
            width: double.maxFinite,
            height: 300, // Set a fixed height or adjust as needed
            child: ListView.builder(
              itemCount: 1, // Only one item in the ListView
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  """
1. AI-Powered Summarization:

1.1. Summarization Process:

Once a document is uploaded, the intelligent system will process it to generate a summary. This may take a few moments.

2. Troubleshooting:

2.1. Document Not Summarized:

If a document is not summarized, check the document format and size. Ensure it meets the supported criteria.

2.2. App Performance Issues:

If you experience performance issues, try clearing your browser cache or restarting the mobile application. For persistent issues, contact our support team.

3. Contact Support:

3.1. Technical Assistance:

For technical assistance or general inquiries, contact our support team at support@summarnote.com.
                """,
                  style: TextStyle(fontSize: 16.0),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Feedback Form"),
          content: Column(
            children: [
              Text(
                "Please provide your feedback below:",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Your Feedback",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Process the feedback (you can add your logic here)
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  textStyle: TextStyle(fontSize: 18.0),
                  fixedSize: Size(100, 70)
                  // Change the background color
                  ),
              child:
                  Text("   Submit   ", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void debugConnection(String ipAddress, BuildContext context) async {
    // Initialize Dio
    Dio dio = Dio();

    try {
      print(ipAddress);
      // Send a GET request to the "/ping" route
      Response response = await dio.get('http://$ipAddress/ping');

      // Check the response status
      if (response.statusCode == 200) {
        _showSnackBar(context, 'Connected to the backend');
        IP.saveIpAddress(ipAddress);
      } else {
        _showSnackBar(
            context, 'Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (error) {
      _showSnackBar(context, 'Error connecting to the backend: $error');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Navigates to the homepageScreen when the action is triggered.
  onTapImgHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.homepageScreen);
  }

  /// Navigates to the historyScreen when the action is triggered.
  onTapImgHistory(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.historyScreen);
  }
}
