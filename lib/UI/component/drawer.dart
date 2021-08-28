import 'dart:async';

import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/UI/Auth/spash.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/reservations/reservations.dart';
import 'file:///D:/Wothoq%20Tech/Buty/code/ButyProvider-master-master/lib/UI/side_menu/service_location.dart';
import 'package:BeauT_Stylist/UI/side_menu/call_us.dart';
import 'package:BeauT_Stylist/UI/side_menu/change_lang.dart';
import 'package:BeauT_Stylist/UI/side_menu/edit_profile.dart';
import 'package:BeauT_Stylist/UI/side_menu/images.dart';
import 'package:BeauT_Stylist/UI/side_menu/services.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bottom_nav_bar/notifications.dart';

class MyDrawer extends StatefulWidget {
  final int rate;
  final String name;
  final String image;

  const MyDrawer({Key key, this.rate, this.name, this.image}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  void getServiceLocation()async{

  }

  @override
  Widget build(BuildContext context) {
    print("rate : ${widget.rate}");
    return Drawer(
      child: Container(
          color: Theme.of(context).primaryColor,
          child: SingleChildScrollView(
            child: Column(
              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: NetworkImage(widget.image), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20)),
                ),
                Text(
                  "${widget.name}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      Text(
                        "${widget.rate}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                itemRow("${allTranslations.text("edit_profile")}",
                    Icons.person_outline, EditProfile()),
                itemRow(
                    "${allTranslations.text("images")}", Icons.image, Images()),
                itemRow("${allTranslations.text("notifications")}",
                    Icons.notifications, Notifications()),
                itemRow("${allTranslations.text("service location")}",
                    Icons.location_on, ServiceLocation(
                    )),
                itemRow("${allTranslations.text("orders")}",
                    Icons.list, Reservation()),
                // itemRow("${allTranslations.text("services")}", Icons.content_cut,
                //     MyService()),
                itemRow("${allTranslations.text("change_language")}",
                    Icons.language, ChangeLanguage()),
                itemRow(
                    "${allTranslations.text("call_us")}", Icons.call, CallUs()),


                itemRow("${allTranslations.text("log_out")}", Icons.exit_to_app,
                    Splash())
              ],
            ),
          )),
    );
  }

  Widget itemRow(String lable, IconData icon, Widget page) {
    return InkWell(
      onTap: () async {
        if (lable == allTranslations.text("log_out")) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
            SizedBox(width: 20),
            Text(
              lable,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
