import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/Bolcs/deletNotificationBloc.dart';
import 'package:BeauT_Stylist/Bolcs/notificationBloc.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/AppLoader.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/EmptyItem.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/LoadingDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/on_done_dialog.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/hom_page.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/main_page.dart';
import 'package:BeauT_Stylist/UI/component/drawer.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/models/NotificationResponse.dart';
import 'package:BeauT_Stylist/models/general_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    notificationBloc.add(Hydrate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //        allTranslations.text("notifications"),
              //       style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       " مسح جميع الاشعارات ",
              //       style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
              BlocListener<NotificationBloc, AppState>(
                bloc: notificationBloc,
                listener: (context, state) {},
                child: BlocBuilder(
                  bloc: notificationBloc,
                  builder: (context, state) {
                    var data = state.model as NotificationResponse;
                    return data == null
                        ? AppLoader()
                        : data.notifications == null
                            ? Center(
                                child: EmptyItem(
                                text:allTranslations.currentLanguage=="ar"?"لا توجد اشعارات" :"No Notifications  ",
                              ))
                            : AnimationLimiter(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: data.notifications.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: notificationItem(
                                            data.notifications[index].user.name,
                                            data.notifications[index].title,
                                            data.notifications[index].message,
                                            data.notifications[index].id,
                                            data.notifications[index].time),
                                      ),
                                    );
                                  },
                                ),
                              );
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget notificationItem(String ButyName, String title, String body, int id,String time) {
    return BlocListener(
      bloc: deleteNotificationBloc,
      listener: (context, state) {
        var data = state.model as GeneralResponse;
        if (state is Loading) showLoadingDialog(context);
        if (state is ErrorLoading) {
          Navigator.of(context).pop();
          errorDialog(
            context: context,
            text: data.msg,
          );
        }
        if (state is Done) {
          Navigator.of(context).pop();
          onDoneDialog(context: context, text: allTranslations.text("Notification deleted successfully"),
          function: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=>Notifications()
            ));
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "${title}",
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
    ),
    Container(
        alignment: allTranslations.currentLanguage=='ar'?Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          onTap: () {
            deleteNotificationBloc.UpdateId(id);
            deleteNotificationBloc.add(Click());
          },
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        )

    ),

  ],
),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "${body}",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              alignment: allTranslations.currentLanguage=='en'?Alignment.centerLeft : Alignment.centerRight,
              child: Text(
                "${time}",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
