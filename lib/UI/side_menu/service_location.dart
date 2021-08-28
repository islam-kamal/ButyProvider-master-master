import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/Bolcs/deletNotificationBloc.dart';
import 'package:BeauT_Stylist/Bolcs/notificationBloc.dart';
import 'package:BeauT_Stylist/NetWorkUtil.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/AppLoader.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomTextFormField.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/EmptyItem.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/LoadingDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/on_done_dialog.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/hom_page.dart';
import 'package:BeauT_Stylist/UI/component/drawer.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/helpers/static_data.dart';
import 'package:BeauT_Stylist/models/NotificationResponse.dart';
import 'package:BeauT_Stylist/models/general_response.dart';
import 'package:BeauT_Stylist/repo/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class ServiceLocation extends StatefulWidget {
  @override
  _ServiceLocationState createState() => _ServiceLocationState();
}

class _ServiceLocationState extends State<ServiceLocation> {
  int at_home ;
  String price;
  @override
  void initState() {
    at_home =   StaticData.service_location;
    notificationBloc.add(Hydrate());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("###### at_home : ${at_home}");
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Image.asset(
              "assets/images/header.png",
              fit: BoxFit.contain,
              width: 100,
              height: 30,
            ),
            actions: [
              InkWell(
                child: allTranslations.currentLanguage == "ar"
                    ? Icon(Icons.arrow_forward_ios) : Icon(Icons.arrow_back_ios),
                onTap: (){
                  Navigator.pop(context);
                },
              )
            ],

          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  service_address(),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Padding(
                    //  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05,left: MediaQuery.of(context).size.width * 0.05),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: allTranslations.currentLanguage =='ar'? CrossAxisAlignment.end :CrossAxisAlignment.start,
                        children: [
                         Row(
                              children: [
                                Icon(Icons.attach_money,size: 20,  color: Theme.of(context).primaryColor,),
                                Text("${allTranslations.text("price")}"),
                              ],

                          ),
                          CustomTextField(
                            value: (String val) {
                              setState(() {
                                price = val;
                              });
                            },
                            hint: '${StaticData.app_commision} ${allTranslations.text( "sar")}',
                             inputType: TextInputType.number,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  CustomButton(
                    onBtnPress: () {
                      print("price : $price");

                      addService(
                          app_commission: price,
                        service_location: at_home,
                      );
                    },
                    text: "${allTranslations.text( "Save")}",
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  Widget service_address() {
    return Container(
      width: double.infinity,
     // height: MediaQuery.of(context).size.width * 0.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  at_home = 1;
                  StaticData.service_location = at_home;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.directions_car,
                              color: Theme.of(context).primaryColor,
                            )),
                        decoration: BoxDecoration(
                            color: Colors.grey[50], shape: BoxShape.circle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(allTranslations.text("at_buty")),
                      ),
                    ],
                  ),
                  at_home == 1
                      ? Icon(
                    Icons.check_box,
                    color: Theme.of(context).primaryColor,
                  )
                      : Icon(
                    Icons.check_box_outline_blank,
                    color: Theme.of(context).primaryColor,
                  ),

                ],
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: () {
                setState(() {
                  at_home = 0;
                  StaticData.service_location = at_home;

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                Row(
                  children: [
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.home,
                            color: Theme.of(context).primaryColor,
                          )),
                      decoration: BoxDecoration(
                          color: Colors.grey[50], shape: BoxShape.circle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(allTranslations.text("at_home")),
                    ),
                  ],
                ),
                  at_home == 0
                      ? Icon(
                    Icons.check_box,
                    color: Theme.of(context).primaryColor,
                  )
                      : Icon(
                    Icons.check_box_outline_blank,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: () {
                setState(() {
                  at_home = 2;
                  StaticData.service_location = at_home;

                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.border_all,
                              color: Theme.of(context).primaryColor,
                            )),
                        decoration: BoxDecoration(
                            color: Colors.grey[50], shape: BoxShape.circle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(allTranslations.text("both")),
                      ),
                    ],
                  ),
                  at_home == 2
                      ? Icon(
                    Icons.check_box,
                    color: Theme.of(context).primaryColor,
                  )
                      : Icon(
                    Icons.check_box_outline_blank,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addService({String app_commission,int service_location}) async {
    StaticData.app_commision = int.parse(app_commission);
    showLoadingDialog(context);
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token = await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    var userResponee = await UserDataRepo.UpdateProfileApi(
      app_commission: app_commission,
      service_location: service_location
    );
    if (userResponee.status == true) {
      Navigator.pop(context);

      onDoneDialog(
          context: context,
          text: userResponee.msg,
          function: () {
            Navigator.pop(context);
          });
    } else if (userResponee.status == false) {
      print("ERROR");
      Navigator.pop(context);
      errorDialog(
          context: context,
          text: userResponee.msg,
          function: () {
            Navigator.pop(context);
          });
      print(userResponee.msg);
    }
    /*  Map<String, String> headers = {
      'Authorization': token,

    };


    NetworkUtil _util = NetworkUtil();
    Response response = await _util.post("https://beauty.wothoq.co/api/beautician/profile/update",
        headers: headers);
    print(response.statusCode);
    if (response.data["status"] != false) {
      Navigator.pop(context);

      onDoneDialog(
          context: context,
          text: response.data["msg"],
          function: () {
            Navigator.pop(context);
          });
    }
    else {
      print("ERROR");
      Navigator.pop(context);
      errorDialog(
          context: context,
          text: response.data["msg"],
          function: () {
            Navigator.pop(context);
          });
      print(response.data.toString());
    }*/
  }
}
