import 'dart:io';



import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:travelday/Utils/Validation.dart';
import 'package:travelday/Views/Assignedroute.dart';
import 'package:travelday/Views/ProfileDetailsScreen.dart';
import 'package:travelday/Views/fav.dart';


class NavigationDrawerNew extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalkey;
  final String name;

  NavigationDrawerNew(this.globalkey, this.name);

  @override
  _NavigationDrawer createState() => _NavigationDrawer(this.globalkey);
}

class _NavigationDrawer extends State<NavigationDrawerNew> {
  final GlobalKey<ScaffoldState> globa_lkey;
  _NavigationDrawer(this.globa_lkey);
  String?  version;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersionnumber();


  }
  Future<void> getVersionnumber() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
     version = packageInfo.version;
     print("Version------->>>>${ version}");
     setState(() {
     });
    //String buildNumber = packageInfo.buildNumber;

  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
       /* Container(
          child: new DrawerHeader(
            child: Container(
              child: Text(
                'Drawer Header',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              alignment: Al
ignment.centerLeft,
              height: 10,
            ),
            decoration: BoxDecoration(color: Colors.blueGrey),
          ),
          height: 80,
        ),*/
        Container(

          height: 145.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF013B46),Color(0xFF013B46)],
                //begin: FractionalOffset.center,
                //end: FractionalOffset.bottomLeft,
              ),
              ),
          child: Center(
            child: DrawerHeader(

                child: Column(
                  children: [

                    //Icon(Icons.person_pin,size: 70,color: Colors.white,),
                    Container(
                        padding:EdgeInsets.only(top: 10) ,
                        alignment: Alignment.center,
                        height: 70,
                        width: 70,
                        child: Image.asset('images/profile.png')),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                      child: Text(widget.name, style: TextStyle(color: Colors.white)),
                    )

                  ],
                ),

                /*decoration: BoxDecoration(

                    image: DecorationImage(
                    image:  AssetImage(""),


                )),*/
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0)),
          ),
        ),

        //CustomListTile(Icons.home_outlined,globa_lkey, 'All Vehicles', () => {}),

        //Divider(),
        //CustomListTile(Icons.alt_route_outlined,globa_lkey, 'Route Info', () => {}),
        //CustomListTile(Icons.directions_car_outlined,globa_lkey, 'Pickup Point', () => {}),
        //CustomListTile(Icons.departure_board_outlined,globa_lkey, 'Boarding & Drop Point', () => {}),
        //Divider(),
        //CustomListTile(Icons.alt_route_outlined,globa_lkey, 'Route List', () => {}),
        //CustomListTile(Icons.list_alt_outlined,globa_lkey, 'Employee Attendance', () => {}),
        //CustomListTile(Icons.notifications_none_outlined,globa_lkey, 'Notifications', () => {}),
        //CustomListTile(Icons.view_list,globa_lkey, 'Attendance', () => {}),
        //CustomListTile(Icons.bluetooth,globa_lkey, 'Ibeacon List', () => {}),
        CustomListTile(Icons.perm_identity_outlined,globa_lkey, 'Profile', () => {}),
        CustomListTile(Icons.phone,globa_lkey, 'Emergency Contact', () => {}),
        CustomListTile(Icons.favorite,globa_lkey, 'Favourites', () => {}),
        //CustomListTile(Icons.construction_rounded,globa_lkey, 'Break Down', () => {}),
        //CustomListTile(Icons.location_on_outlined,globa_lkey, 'Upcoming Routes', () => {}),
        //CustomListTile(Icons.location_on_outlined,globa_lkey, 'Tracking', () => {}),

        Divider(),
        //CustomListTile(Icons.dynamic_feed,globa_lkey, 'Request List', () => {}),
        //CustomListTile(Icons.list,globa_lkey, 'Request Status List', () => {}),

        //Divider(),
        CustomListTile(Icons.apps,globa_lkey, 'App Version $version', () => {}),
        CustomListTile(Icons.logout,globa_lkey, 'Logout', () => {}),
        Divider(),

      ]),
    );
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function ontap;
  final GlobalKey<ScaffoldState> globalkey;

  CustomListTile(this.icon,this.globalkey, this.text, this.ontap );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
            Navigator.of(context).pop();
            if (text == "All Vehicles") {
              print("home");
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VehicleListScreen()),
              );*/

            }else if(text=="Route List")
            {

              print("Route Summary");
             /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RouteSummaryScreen()),
              ).then((value) => debugPrint("ON Back called"));
            */
            }
            else if(text=="Employee Attendance")
            {
            print("Employee Attendance");

            /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployeeList()),
            );*/

            }
            else if(text=="Profile")
              {
                print("profile");

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetailScreen()),
                );

              }
            else if(text=="Emergency Contact")
            {
              //print("Break Down");

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmergencyContactList()),
              );

            }
            else if(text=="Request Status List")
            {
              print("Upcomming Routes");

              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestStatus()),
              );*/

            }
            else if(text=="Ibeacon List")
            {
              print("Ibeacon List");

              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ibeaconlist()),
              );*/

            }
            else if(text=="Pickup Point")
            {
              print("Pickup");
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PickupScreen()),
              ).then((value) => debugPrint("ON Back called"));*/

            }else if(text=="Route Info")
            {
              print("Route Info");
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RouteInfo()),
              ).then((value) => debugPrint("ON Back called"));*/

            }
            else if(text=="Boarding & Drop Point")
            {
              print("Boarding");



            }
            else if(text=="Notifications")
            {
              print("Notifications");
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );*/

            }
            else if(text=="Request List")
            {
              print("Complaint");
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComplaintListScreen()),
              );*/

            } else if(text=="Favourites")
            {
              print("Complaint");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteListScreen()),
              );


            }
            /*else if(text=="Attendance")
            {
              print("Attendance");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttendanceMyApp()),
              );

            }*/
            else if(text=="Logout")
            {
              //Navigator.of(context).pop();
              if(Platform.isAndroid)
              {
                Validation.onAlertButtonsPressed(globalkey.currentState!.context);
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScrollContainerPage()),
                );*/
              }else if(Platform.isIOS)
              {
                Validation.showIOSAlertDialog(context,globalkey);
              }
            }
          },
          child: Container(
              margin: EdgeInsets.all(10.0),
            height: 35,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: text=="Boarding & Drop Point"?Image.asset('images/dropblack.png',height: 25,width: 25,):Icon(icon,size:25,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(text,style: TextStyle(fontSize: 16),),
                ),
              ],
            ),
          )),
    );
  }
}
