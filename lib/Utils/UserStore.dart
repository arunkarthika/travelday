import 'package:shared_preferences/shared_preferences.dart';

class UserStore{

  Future<bool> getUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("userLogin") != null);
  }
  Future<bool> setUserLoggedIn(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userLogin', authToken);
    return true;
  }
  Future<String?> getUserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("userid"));
  }

  Future<bool> setUserid(String user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', user_id);
    return true;
  }

  Future<String?> getDepartment() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("department"));
  }
  Future<bool> setDepartment(String vechileno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('department', vechileno);
    return true;
  }
  Future<String?> getVechileNo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("VechileNo"));
  }
  Future<bool> setVechileNo(String vechileno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('VechileNo', vechileno);
    return true;
  }
  Future<bool> setRouteType( String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("RouteType", value);
    return true;
  }
  Future<String?> getRouteType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("RouteType");
  }

  Future<bool> setrouteType( String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("routeType", value);
    return true;
  }
  Future<String?> getrouteType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("routeType");
  }
  Future<String?> getPickupid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("Pickupid"));
  }
  Future<bool> setPickupid(String pickupid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Pickupid', pickupid);
    return true;
  }
  Future<bool> setRouteName(String routename) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('routename', routename);
    return true;
  }
  Future<String?> getRoutename() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("routename"));
  }

  Future<bool> setCurrentlat(double lat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', lat);
    return true;
  }

  Future<double?> getCurrentlat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getDouble("lat"));
  }

  Future<bool> setCurrentlng(double lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lng', lng);
    return true;
  }
  Future<double?> getCurrentlng() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getDouble("lng"));
  }

  Future<bool> setIMEI(String Imei) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imei', Imei);
    return true;
  }
  Future<String?> getImei() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("imei"));
  }

  Future<bool> setSec(int sec) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('sec', sec);
    return true;
  }
  Future<int?> getSec() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt("sec"));
  }
  Future<bool> setUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    return true;
  }

  Future<String?> getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("username"));
  }
  Future<bool> setVechno(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('vechno', username);
    return true;
  }
  Future<String?> getVechno() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("vechno"));
  }

  Future<bool> setToken(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', authToken);
    return true;
  }
  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("token"));
  }
  Future<bool> setDriverId(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('driverid', authToken);
    return true;
  }
  Future<String?> getDriverId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("driverid"));
  }

  Future<bool> setRouteid( String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("routeid", value);
    return true;
  }
  Future<String?> getRouteid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("routeid");
  }

}