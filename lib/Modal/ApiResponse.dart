

//import 'dart:html';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.


@JsonSerializable()
class LoginResponse
{
  String status;
  String token;
  //String str_logo;

  LoginResponse(this.status, this.token);

  factory LoginResponse.fromJson(dynamic json) {
    //var tagObjsJson = json['data'] as List;
    //List<ProfileData> profilelist = tagObjsJson.map((tagJson) => ProfileData.fromJson(tagJson)).toList();
    String message;
    if(json.containsKey("token")==true)
    {
      message=json['token'] as String;
    }else{
      message=json['message'] as String;
    }
    return LoginResponse(json['status'] as String,message);
  }
}

class LoginFailureResponse{
  String str_status;
  String str_message;

  LoginFailureResponse(this.str_status,this.str_message);

  factory LoginFailureResponse.fromJson(dynamic json) {

    return LoginFailureResponse(json['status'] as String,json['message'] as String);
  }

}

class FeedResponse
{
  String str_type;
  String str_label;
  bool bl_required;
  String str_name;
  List<Getoptions> ll_options;
  FeedResponse(this.str_type,this.str_label,this.bl_required,this.str_name,this.ll_options);
  factory FeedResponse.fromJson(dynamic json) {
    print(json.containsKey("options"));
    if(json.containsKey("options")==true)
    {
      var tagObjsJson = json['options'] as List;
      List<Getoptions> optionlist = tagObjsJson.map((tagJson) => Getoptions.fromJson(tagJson)).toList();
      return FeedResponse(json['type'] as String,json['label'] as String,json['required'] as bool,json['name'] as String,optionlist);

    }else{
      List<Getoptions> optionlist=[];
      return FeedResponse(json['type'] as String,json['label'] as String,json['required'] as bool,json['name'] as String,optionlist);
    }

  }

}

class Getoptions
{
  String str_value;
  String str_name;
  Getoptions(this.str_value,this.str_name);
  factory Getoptions.fromJson(dynamic json) {
    return Getoptions(json['value'] as String, json['name'] as String);
  }

}
class ComplaintResponse{
  String str_status;
  List<ComplaintData> ll_profiledata;

  ComplaintResponse(this.str_status,this.ll_profiledata);

  factory ComplaintResponse.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    List<ComplaintData> profilelist = tagObjsJson.map((tagJson) => ComplaintData.fromJson(tagJson)).toList();
    return ComplaintResponse(json['status'] as String,profilelist);
  }

}
class ComplaintData
{
  String str_title;
  String str_requesttype;
  int int_status;
  String str_note;
  String str_requestId;
  List<FeedbackResponse>ll_formfields;
  ComplaintData(this.str_title,this.str_requesttype,this.int_status,this.str_note,this.str_requestId,this.ll_formfields);
  factory ComplaintData.fromJson(dynamic json) {
    var tagObjsJson = json['formFields'] as List;
    List<FeedbackResponse> profilelist = tagObjsJson.map((tagJson) => FeedbackResponse.fromJson(tagJson)).toList();
    return ComplaintData(json['title'] as String,json['requestType'] as String,json['status'] as int,json['note'] as String,json['requestID'] as String,profilelist);
  }


}
class DoctorRegistrationsuccessResponse{
  String str_status;
  String str_token;
  String str_message;

  DoctorRegistrationsuccessResponse(this.str_status,this.str_token,this.str_message);

  factory DoctorRegistrationsuccessResponse.fromJson(dynamic json) {
    return DoctorRegistrationsuccessResponse(json['status'] as String, json['token'] as String,json['message'] as String);
  }

}

class DoctorRegistrationfailureResponse{
  String str_status;
  Message message;


  DoctorRegistrationfailureResponse(this.str_status,this.message);

  factory DoctorRegistrationfailureResponse.fromJson(dynamic json) {
    return DoctorRegistrationfailureResponse(json['status'] as String,Message.fromJson(json['message']));
  }

}

class Message{
  List<Details> details;


  Message(this.details);

  factory Message.fromJson(dynamic json) {
    var tagObjsJson = json['details'] as List;
    List<Details> eventlist = tagObjsJson.map((tagJson) => Details.fromJson(tagJson)).toList();
    return Message(eventlist);
  }


}


class Details{
  String  str_message;

  Details(this.str_message);
  factory Details.fromJson(dynamic json) {
    return Details(json['message'] as String);
  }


}
class ProfileResponse{
  String str_status;
  List<ProfileData> ll_profiledata;

  ProfileResponse(this.str_status,this.ll_profiledata);

  factory ProfileResponse.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    List<ProfileData> profilelist = tagObjsJson.map((tagJson) => ProfileData.fromJson(tagJson)).toList();
    return ProfileResponse(json['status'] as String,profilelist);
  }

}
class ProfileData{

  String str_orgid;
  String  str_name;
  String str_email;
  int int_dob;
  int     str_mobile;
  int     str_emergencycontact;
  String  str_emprefid;
  String  str_gender;
  String  str_bloodgroup;
  String  str_address;
  String  str_city;
  String  str_state;
  String  str_country;
  int  str_pincode;
  String  str_branch;
  //late String  str_name;
  ProfileData(this.str_orgid,this.str_name,this.int_dob,this.str_mobile,this.str_emergencycontact,this.str_bloodgroup,this.str_address,
      this.str_city,this.str_state,this.str_country,this.str_pincode,this.str_branch,this.str_emprefid,this.str_gender,this.str_email);
  factory ProfileData.fromJson(dynamic json) {
    return ProfileData(json['orgID'] as String,json['name'] as String,json['dob'] as int,json['mobile'] as int,json['emergencyContact'] as int,json['bloodGroup'] as String,json['address'] as String,
        json['city'] as String,json['state'] as String,json['country'] as String,json['pincode'] as int,json['branch'] as String,json['empRefID'] as String,json['gender'] as String,json['email'] as String);
  }

}

class routeSummaryResponse{
  String str_status;
  RouteSummarydata routeSummarydata;
  //List<String>?routes;

  routeSummaryResponse(this.str_status,this.routeSummarydata);

  factory routeSummaryResponse.fromJson(dynamic json) {
    return routeSummaryResponse(json['status'] as String,RouteSummarydata.fromJson(json['data']));
  }

}
class RouteSummarydata{
  int NoofRoutes;
  int pickup;
  int drop;
  String str_Totalkms;
  RouteSummary routeInfo;
  RouteSummarydata(this.NoofRoutes,this.pickup,this.drop,this.str_Totalkms,this.routeInfo);

  factory RouteSummarydata.fromJson(dynamic json) {
    return RouteSummarydata(json['NoofRoutes'] as int,json['pickup'] as int,json['drop'] as int,json['Totalkms'] as String,RouteSummary.fromJson(json['routesummary']));
    // return RouteSummarydata(list_routes!);
  }

}
class RouteSummary
{
  List<VehicleDetails>ll_routes;
  RouteSummary(this.ll_routes);
  factory RouteSummary.fromJson(dynamic json) {
    var tagObjsJson = json['vehicledetails'] as List;
    List<VehicleDetails> profilelist = tagObjsJson.map((tagJson) => VehicleDetails.fromJson(tagJson)).toList();
    return RouteSummary(profilelist);

  }
}
class VehicleDetails
{
  String str_regno;
  int date;
  String str_type;
  String str_pickuppoint;
  String str_droppoint;
  int totalkm;
  bool safedrop;

  VehicleDetails(this.str_regno,this.date,this.str_type,this.str_pickuppoint,this.str_droppoint,this.totalkm,this.safedrop);

  factory VehicleDetails.fromJson(dynamic json) {
    return VehicleDetails(json['regno'] as String,json['date'] as int,json['type'] as String,json['pickupPoint'] as String,json['dropPoint'] as String,json['totalKms'] as int,json['safedrop'] as bool);

  }
}





@JsonSerializable()
class Activetrip{
  String str_status;
  Data data;

  Activetrip(this.str_status,this.data);

  factory Activetrip.fromJson(dynamic json){

    return Activetrip(json['status'] as String,Data.fromJson(json['data']) );
  }
}
@JsonSerializable()
class Data {
  List<Route> route;
  List<PointsData>? pointsData;

  Data(this.route, this.pointsData);

  factory Data.fromJson(dynamic json){

    var list = json['route'] as List;
    List<Route> routelist = list.map((tagJson) => Route.fromJson(tagJson)).toList();
    var _list = json['pointsData'] as List;
    List<PointsData> pointlist = _list.map((tagJson) => PointsData.fromJson(tagJson)).toList();

    return Data(routelist,pointlist);
  }

}
class Route{
   String id;
   String title;
   int fromdate;
   String str_time_str;
   String str_end_str;
   String routetype;

   Route(this.id,this.title,this.fromdate,this.str_time_str,this.str_end_str,this.routetype);

   factory Route.fromJson(dynamic json){

     return Route( json['_id'] as String,json['title'] as String,json['fromDate'] as int,json['startTimeStr'] as String,json['endTimeStr'] as String,json['routeType'] as String);
   }
}

class PointsData{
  String org_id;
  String route_id;
  String vegregno;
  int created_at;
  int status;
  int tripstatus;
  int pickuppointstatus;
  double lat;
  double lng;
  String location;
  String title;
  String eta;
  List<Employees> employees;
  String pickuppointid;
//S_Location start_loc;
//E_Location end_loc;
  PointsData(this.org_id,this.route_id,this.vegregno,this.created_at,this.status,this.tripstatus,this.pickuppointstatus,this.lat,this.lng,this.location,this.title,this.eta,this.employees,this.pickuppointid);
  factory PointsData.fromJson(dynamic json){
    var elist = json['employees'] as List;
    List<Employees> employeeslist = elist.map((tagJson) => Employees.fromJson(tagJson)).toList();
    return PointsData(json['orgID'] as String,json['routeID'] as String,json['vehRegNo'] as String,json['createdAt'] as int,json['status'] as int,json['tripStatus'] as int,json['pickuppointStatus'] as int,json['lat'] as double,json['lng'] as double,json['location'] as String,json['title'] as String,json['eta'] as String,employeeslist,json['pickuppointID'] as String);//S_Location.fromJson(json['startLoc']),E_Location.fromJson(json['endLoc'])
}
}

class Employees {
  String name;
  String gender;
  LLocation ll_location;
  Employees(this.name,this.gender,this.ll_location);
  factory Employees.fromJson(dynamic json){

    return Employees(json['name'] as String,json['gender'] as String,LLocation.fromJson(json['location']));
  }
}

class LLocation{
  double ll_lat;
  double ll_lng;
  String ll_name;

  LLocation(this.ll_lat,this.ll_lng,this.ll_name);

  factory LLocation.fromJson(dynamic json){
    return LLocation(json['lat'] as double,json['lng'] as double,json['name'] as String);
  }
}
class S_Location{
  double s_lat;
  double s_lng;
  String s_name;
  S_Location(this.s_lat,this.s_lng,this.s_name);
  factory S_Location.fromJson(dynamic json){
    return S_Location(json['lat'] as double,json['lng'] as double,json['name'] as String);
  }
}
class E_Location{
  double e_lat;
  double e_lng;
  String e_name;
  E_Location(this.e_lat,this.e_lng,this.e_name);
  factory E_Location.fromJson(dynamic json){
    return E_Location(json['lat'] as double,json['lng'] as double,json['name'] as String);
  }
}



class RequestListResponse{
  String str_status;
  List<RequestListData> ll_complaintdata;
  //ComplaintStatus complaintStatus;

  RequestListResponse(this.str_status,this.ll_complaintdata);

  factory RequestListResponse.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    List<RequestListData> requestlist = tagObjsJson.map((tagJson) => RequestListData.fromJson(tagJson)).toList();
    return RequestListResponse(json['status'] as String,requestlist);
  }
}
class RequestListData
{
  String title;
  String note;
  int status;
  String requestID;

  RequestListData(this.title, this.note, this.status,this.requestID);

  factory RequestListData.fromJson(dynamic json) {
    String? requestid;
    if(json.containsKey("requestID")==true)
    {
      requestid=json['requestID'] as String;
    }else if(json.containsKey("customeRequestID")==true)
    {
      requestid=json['customeRequestID'] as String;
    }

    return RequestListData(json['title'] as String,json['note'] as String,json['status'] as int,requestid!);
  }

}

class RequestListFormResponse{
  String str_status;
  List<FormFieldsResponse> ll_formfields;
  //ComplaintStatus complaintStatus;

  RequestListFormResponse(this.str_status,this.ll_formfields);

  factory RequestListFormResponse.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    List<FormFieldsResponse> requestlist = tagObjsJson.map((tagJson) => FormFieldsResponse.fromJson(tagJson)).toList();
    return RequestListFormResponse(json['status'] as String,requestlist);
  }
}

class FormFieldsResponse{
  List<FeedbackResponse> ll_formfields;
  FormFieldsResponse(this.ll_formfields);
  factory FormFieldsResponse.fromJson(dynamic json) {
    var tagObjsJson = json['formFields'] as List;
    List<FeedbackResponse> requestlist = tagObjsJson.map((tagJson) => FeedbackResponse.fromJson(tagJson)).toList();
    return FormFieldsResponse(requestlist);
  }

}

class FeedbackResponse
{
  String str_type;
  String str_label;
  //bool bl_required;
  String str_name;
  List<RequstOptions> ll_options;
  FeedbackResponse(this.str_type,this.str_label,this.str_name,this.ll_options);
  factory FeedbackResponse.fromJson(dynamic json) {
    print("popo====${json.containsKey("options")}");
    if(json.containsKey("options")==true)
    {
      print("popo====if");
      var tagObjsJson = json['options'] as List;
      List<RequstOptions> optionlist = tagObjsJson.map((tagJson) => RequstOptions.fromJson(tagJson)).toList();
      return FeedbackResponse(json['type'] as String,json['label'] as String,json['name'] as String,optionlist);

    }else{
      print("popo====else");
      List<RequstOptions> optionlist=[];
      return FeedbackResponse(json['type'] as String,json['label'] as String,json['name'] as String,optionlist);
    }

  }

}

class OtpResponse{
  String str_status;
  String str_token, str_usertype;
  //int sec;
  //String vechno;

  OtpResponse(this.str_status,this.str_token,this.str_usertype);

  factory OtpResponse.fromJson(dynamic json) {
    //LoginResponse(json['status'] as String,json['token'] as String);
    return OtpResponse(json['status'] as String,json['token'] as String,json['userType'] as String);
  }

}
class Otpverifydata{
  OtpResponse otpResponse;
  Otpverifydata(this.otpResponse);
  factory Otpverifydata.fromJson(dynamic json) {
    //LoginResponse(json['status'] as String,json['token'] as String);
    return Otpverifydata(OtpResponse.fromJson(json['data']));
  }


}
class RequstOptions{
  String str_name;
  String str_value;

  RequstOptions(this.str_name, this.str_value);
  factory RequstOptions.fromJson(dynamic json) {
    return RequstOptions(json['name'] as String,json['value'] as String);
  }

}


class RequestStatusList{
  String str_status;
  List<RequestStatusListData> ll_statusdata;

  RequestStatusList(this.str_status,this.ll_statusdata);
  factory RequestStatusList.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    List<RequestStatusListData> statuslist = tagObjsJson.map((tagJson) => RequestStatusListData.fromJson(tagJson)).toList();
    return RequestStatusList(json['status'] as String,statuslist);
  }
}

class RequestStatusListData{
  int int_status;
  int int_reqstatus;
  String str_user;
  String str_currentlocation;
  String str_latlong;
  String str_date;
  String str_message;
  String str_requestid;
  String str_curshift;
  String str_selshift;
  RequestStatusListData(this.int_status,this.int_reqstatus,this.str_user,this.str_currentlocation,this.str_latlong,this.str_date,this.str_message,this.str_requestid,this.str_curshift,this.str_selshift);
  factory RequestStatusListData.fromJson(dynamic json){
    return RequestStatusListData(json['status'] as int,json['reqStatus'] as int,json['user'] as String,json['currentLocation'] as String,json['latLong'] as String,json['date'] as String,json['message'] as String,json['requestID'] as String,json['Current shift'] as String,json['Select shift'] as String);
  }
}
class Activetripresponse{
  String str_status;
  List<ActivetripResponsedata>activetripResponsedata;


  Activetripresponse(this.str_status, this.activetripResponsedata);

  factory Activetripresponse.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    List<ActivetripResponsedata> data = tagObjsJson.map((tagJson) => ActivetripResponsedata.fromJson(tagJson)).toList();

    return Activetripresponse(json['status'] as String,data);
  }



}

class ActivetripResponsedata{
 List<Routeinfo>  routeinfo;
  //Pickupinfo pickupinfo;
  List<Pickupinfo> pickupinfo;
  ActivetripResponsedata(this.routeinfo,this.pickupinfo);

  factory ActivetripResponsedata.fromJson(dynamic json) {
    var tagObjsJson = json['pickupInfo'] as List;
    var routeinfoObjsJson = json['routeInfo'] as List;
    List<Pickupinfo> data = tagObjsJson.map((tagJson) => Pickupinfo.fromJson(tagJson)).toList();
    List<Routeinfo> routeinfodata = routeinfoObjsJson.map((tagJson) => Routeinfo.fromJson(tagJson)).toList();
    return ActivetripResponsedata(routeinfodata,data);
  }

}

class Routeinfo{

  //String  title,starttime,endtime,transitmode;
  String  title;
  String  starttime;
  String  endtime;
  String  transitmode;
  int fromDate;
  String str_id;
  String str_vechregno;
  String routeType;
  int  startTS;
  List<LocationInfo> locationinfo;



  Routeinfo(this.title,this.starttime,this.endtime,this.fromDate,this.transitmode,this.str_id,
      this.str_vechregno,this.routeType,this.startTS,this.locationinfo);
  factory Routeinfo.fromJson(dynamic json) {
    var tagObjsJson = json['locInfo'] as List;
    List<LocationInfo> locinfodatadata = tagObjsJson.map((tagJson) => LocationInfo.fromJson(tagJson)).toList();
    return Routeinfo(json['title'] as String,json['startTimeStr'] as String,json['endTimeStr'] as String,
        json['fromDate'] as int,json['trasitMode'] as String,json['routeID'] as String,
        json['vehRegNo'] as String,json['routeType'] as String,json['startTS'] as int,locinfodatadata);
  }

}

class Pickupinfo{
  //String location,title,routeID,vehRegNo,eta,pickupid;
  String location;
  String title;
  String routeID;
  String vehRegNo;
  String eta;
  String pickupid;
  double lat,lng;


  int pickuppointStatus;
  //List<PickupinfoEmployees>pickupinfoEmployees;
  List<dynamic> ll_assignedemployees;

  Pickupinfo(this.location, this.title, this.routeID, this.vehRegNo, this.eta,this.pickuppointStatus,this.ll_assignedemployees,this.pickupid,this.lat,this.lng);
  factory Pickupinfo.fromJson(dynamic json) {
    //var tagObjsJson = json['employees'] as List;
    var tagsJson;
    if(json.containsKey("assignedEmployees")==true)
      {
        tagsJson = json['assignedEmployees'] as List;
      }else
        {
          tagsJson=[];
        }

   // List<PickupinfoEmployees> pickupinfoEmployees = tagObjsJson.map((tagJson) => PickupinfoEmployees.fromJson(tagJson)).toList();
    return Pickupinfo(json['location'] as String,json['title'] as String,json['routeID'] as String,json['vehRegNo'] as String,json['eta'] as String,json['pickuppointStatus'] as int,tagsJson,json['pickuppointID'] as String,json['lat'] as double,json['lng'] as double);
  }


}
class PickupinfoEmployees{
 // String str_empid,str_gender;
  String str_empid;
  String str_gender;

  PickupinfoEmployees(this.str_empid, this.str_gender);

  factory PickupinfoEmployees.fromJson(dynamic json) {
    return PickupinfoEmployees(json['employeeID'] as String,json['gender'] as String);
  }

}

class RouteListResponse{
  String str_status;
  List<RoutelistResponsedata> routelistResponsedata;


  RouteListResponse(this.str_status, this.routelistResponsedata);

  factory RouteListResponse.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    List<RoutelistResponsedata> data = tagObjsJson.map((tagJson) => RoutelistResponsedata.fromJson(tagJson)).toList();
    return RouteListResponse(json['status'] as String,data);
  }
}
class RoutelistResponsedata{

  String str_title,str_transitmode,str_starttime,str_endtime,str_orgname;
  List<dynamic> ll_vehicles;
  int fromdate;

  RoutelistResponsedata(this.str_title, this.str_transitmode,this.str_starttime, this.str_endtime,this.str_orgname,this.fromdate,this.ll_vehicles);

  factory RoutelistResponsedata.fromJson(dynamic json) {
    var tagsJson = json['vehicle'] as List;
    return RoutelistResponsedata(json['title'] as String,json['trasitMode'] as String,json['startTimeStr'] as String,json['endTimeStr'] as String,json['orgName'] as String,json['fromDate'] as int,tagsJson);
  }
}

class ScandataResponse{
  String str_status;
  List<ScandataResponse> scandataResponse;


  ScandataResponse(this.str_status, this.scandataResponse);

  factory ScandataResponse.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    List<ScandataResponse> data = tagObjsJson.map((tagJson) => ScandataResponse.fromJson(tagJson)).toList();
    return ScandataResponse(json['status'] as String,data);
  }
}
class Scandata{

}
class LocationInfo{
  Startlocation startlocation;
  Endlocation endlocation;
  LocationInfo(this.startlocation,this.endlocation);
  factory LocationInfo.fromJson(dynamic json) {
    return LocationInfo(Startlocation.fromJson(json['startLoc']),Endlocation.fromJson(json['endLoc']));
  }

}
class Startlocation
{
  double lat;
  double lng;
  String name;
  String title;
  Startlocation(this.lat, this.lng, this.name,this.title);
  factory Startlocation.fromJson(dynamic json) {
    return Startlocation(json['lat'] as double,json['lng'] as double,json['name'] as String,json['title'] as String);
  }

}
class Endlocation
{
  double lat;
  double lng;
  String name;
  String title;

  Endlocation(this.lat, this.lng, this.name,this.title);
  factory Endlocation.fromJson(dynamic json) {
    return Endlocation(json['lat'] as double,json['lng'] as double,json['name'] as String,json['title'] as String);
  }

}
class WayPointsResponse{
  String str_status;
  //List<List<double>> ll_complaintdata;
  //List<WaypoinData> waypoinData;
  List<dynamic> ll_latlng;

  WayPointsResponse(this.str_status,this.ll_latlng);

  factory WayPointsResponse.fromJson(dynamic json) {
    var tagObjsJson = json['data'] as List;
    return WayPointsResponse(json['status'] as String,tagObjsJson);
  }
}
class RoutedataResponse
{
  String str_status;
  //List<RouteData> ll_routedata;
  //ComplaintStatus complaintStatus;
  RouteData routeData;

  RoutedataResponse(this.str_status,this.routeData);

  factory RoutedataResponse.fromJson(dynamic json) {
    //var tagObjsJson = json['routeData'] as List;
    //List<RouteData> requestlist = tagObjsJson.map((tagJson) => RouteData.fromJson(tagJson)).toList();
    return RoutedataResponse(json['status'] as String,RouteData.fromJson(json['routeData']));
  }
}
class RouteData{

  List<dynamic> ll_vehicles;


  /*RouteData(this.tittle, this.fromdate, this.str_starttime, this.str_endtime,
      this.routeid, this.ll_vehicles, this.str_trasitMode);*/
  RouteData(this.ll_vehicles);
  factory RouteData.fromJson(dynamic json) {
    var tagObjsJson = json['objKeys'] as List;
    return RouteData(tagObjsJson);
  }

}
class EmployeeAddObject{
  var empaddobject;
  EmployeeAddObject(this.empaddobject);
  Map toJson(){

    return{'routeInfo':empaddobject};
  }
}

/*class EmployeeRouteinfo{

  String? routeID,vehRegNo,routeName,lat,lng,scanTime,transitMode;

  EmployeeRouteinfo(this.routeID, this.vehRegNo, this.routeName, this.lat,
      this.lng, this.scanTime, this.transitMode);

}*/
