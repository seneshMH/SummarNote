import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';
import 'package:summer_note/utils/ip.dart';
import 'package:summer_note/widgets/custom_drop_down.dart';

// ignore_for_file: must_be_immutable
class SettingsScreen extends StatelessWidget {
  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];
  List<String> dropdownItemList1 = ["Item One", "Item Two", "Item Three"];
  List<String> dropdownItemList2 = ["Item One", "Item Two", "Item Three"];
  List<String> dropdownItemList3 = ["Item One", "Item Two", "Item Three"];
  List<String> dropdownItemList4 = ["Item One", "Item Two", "Item Three"];

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

              // Custom dropdown menus
              Padding(
                padding: EdgeInsets.only(left: 21.0, right: 21.0),
                child: ListTile(
                  title: Center(
                    child: Text(
                      "About",
                      style: TextStyle(
                        color: Colors.black, // Set your desired text color
                        fontSize: 18.0, // Set your desired font size
                        fontWeight:
                            FontWeight.bold, // Set your desired font weight
                      ),
                    ),
                  ),
                  tileColor:
                      Colors.yellowAccent, // Set your desired button color
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ),

              // Similar blocks for other dropdown menus...
              // (existing code)

              Spacer(),

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
