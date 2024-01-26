import 'package:shared_preferences/shared_preferences.dart';

class IP {
  static Future<String> loadIpAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedIpAddress = prefs.getString('ipAddress');

    if (savedIpAddress != null) {
      // Set the saved IP address in the controller if available
      return savedIpAddress;
    } else {
      return '192.168.70.178:8080';
    }
  }

  static void saveIpAddress(String ipAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ipAddress', ipAddress);
  }
}
