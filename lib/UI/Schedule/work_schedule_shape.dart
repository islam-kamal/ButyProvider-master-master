import 'dart:convert';
import 'dart:ui' as ui;
import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/Bolcs/schedule_bloc.dart';
import 'package:BeauT_Stylist/NetWorkUtil.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/AppLoader.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/LoadingDialog.dart';
import 'package:BeauT_Stylist/UI/Schedule/schedule_data_model.dart';
import 'package:BeauT_Stylist/UI/Schedule/work_schedule_model.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/hom_page.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/main_page.dart';
import 'package:BeauT_Stylist/UI/component/customText.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/helpers/static_data.dart';
import 'package:BeauT_Stylist/models/dayes_model.dart';
import 'package:BeauT_Stylist/models/times.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' as intl;

class WorkScheduleShape extends StatefulWidget {
  @override
  _WorkScheduleShapeState createState() => _WorkScheduleShapeState();
}

class _WorkScheduleShapeState extends State<WorkScheduleShape>
    with TickerProviderStateMixin {
  DateTime _currentDate = DateTime.now();
  CalendarController _calendarController;
  AnimationController _animationController;
  List<Days> days = [];


  List<String> time;
  String selected_delivery_time;
  String selected_delivery_date;
  List<String> day_name;
  int day;
  String today_date;
  String week_day;
  int select_day;
  List<String>  listOfDatesOfMonth;
  _onSelected_day(int index) {
    setState(() {

      select_day = index;
    });
  }


  String name, chossed_date, from, to;

  WorkScheduleModel hours = WorkScheduleModel();
  bool isloading = true;
  List<bool> time_stauts;
  List<String> provider_closed_times;
  List<int> provider_closed_times_status;
  var week_day_name;




  List<String> dates;

  List schedul_list;

  List times = ["10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM", "02:30 PM", "03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM", "07:00 PM","07:30 PM","08:00 PM","08:30 PM","09:00 PM","09:30 PM","10:00 PM","10:30 PM","11:00 PM", "11:30 PM"];

  List<int> selected_days_weekday;
  @override
  void initState() {
    selected_days_weekday = new List<int>();
    listOfDatesOfMonth = new List<String>();
    dates = new List();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    chossed_date = formatter.format(now);
    dates.add(chossed_date);
    print(chossed_date);
    getAllTimes(
      date: '05-08-2021'
    );
    get_all_dates_of_month(
      month: chossed_date.substring(2,10)
    );

    provider_closed_times = new List<String>();
    provider_closed_times_status = new List<int>();
    schedul_list = new  List();


    day_name = ['السبت','الأحد','الاثنين','الثلاثاء','الاربعاء','الخميس','الجمعة'];
    _calendarController = CalendarController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage == "ar"
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              "${allTranslations.text("Appointment")}",
              style: TextStyle(color: Colors.white),
            )),
        body: BlocListener<ScheduleBloc, AppState>(
          bloc: schedule_bloc,
          listener: (context, state) {
            if(state is Loading){
              AppLoader();
            }else if(state is Done){
              var data = state.model as WorkScheduleModel;

              errorDialog(
                  context: context,
                  text: data.msg,
                  function: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context)=>MainPage()
                    ));
                  }
              );
            }else if(state is ErrorLoading){
              var data = state.model as WorkScheduleModel;
              if(data.status == false){
                errorDialog(
                  context: context,
                  text: data.msg,

                );
              }
            }
          },
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: MyText(
                  text: allTranslations.text("Please choose the days and times you will not receive reservations"),
                  color: Colors.black,
                  size: 14,
                  weight: FontWeight.bold,
                ),
              ),
              _buildTableCalendar(),

              ChosseDayOptions(),

              TimesView()
            ],
          ),
        ),
      ),
    );
  }

  void showdialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 20,
            child: Container(
                height: 290,
                width: 120,
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    CustomButton(
                      text: "${allTranslations.text("this_day")}",
                    ),
                    CustomButton(
                      text: "${allTranslations.text("all_dayes")}",
                    ),
                  ],
                )),
          );
        });
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      startDay: DateTime.now(),
      calendarController: _calendarController,
      locale: allTranslations.currentLanguage,
       weekendDays:     selected_days_weekday ,
      daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Color(0xFFBABDC3), fontSize: 12),
          weekdayStyle: TextStyle(color: Color(0xFFBABDC3), fontSize: 12)),
      startingDayOfWeek: StartingDayOfWeek.saturday,
      onUnavailableDaySelected: () {
        print("ssss");
      },
      calendarStyle: CalendarStyle(
          highlightToday: false,
          selectedColor: Theme.of(context).primaryColor,
          outsideDaysVisible: false,
          weekendStyle: TextStyle(color: Colors.black),
          holidayStyle: TextStyle(color: Color(0xFFBABDC3))),
      
      headerStyle:
      HeaderStyle(formatButtonVisible: false, centerHeaderTitle: true),
      onDaySelected: (date, events, holidays) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          chossed_date = formatter.format(date);
          dates.clear();
          dates.add(chossed_date);
          getAllTimes(
              date: chossed_date
          );
          hours.schedule==null? null :    _onSelected_day(day_name.indexOf(hours.schedule.dayName));
             var day_nam = DateFormat('EEEE','ar_SA').format(date);
         select_day = day_name.indexOf(day_nam);

        });
        print("chossed_date : ${chossed_date}");
      },
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  '${date.day}',
                  style:
                  TextStyle(color: Colors.white).copyWith(fontSize: 16.0),
                ),
              ),
            ),
          );
        },
        weekendDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  '${date.day}',
                  style:
                  TextStyle(color: Colors.white).copyWith(fontSize: 16.0),
                ),
              ),
            ),
          );
        },

    ),

    );
  }




  Widget ChosseDayOptions() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var now = new DateTime.now();
    week_day = intl.DateFormat('EEEE').format(now);
    day = now.day;

    return  Container(
        padding: EdgeInsets.only(right: width * .03, left: width * .03),

        color: Colors.white,
        width: width ,
        height: height*.15,
        child:ListView.builder(
            shrinkWrap: true,
            itemCount: day_name.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){

                      var weekday;
                      _onSelected_day(index);
                      print("sss : ${day_name[index]}");
                      switch(index){
                        case 0 :
                          weekday =6;
                          break;
                        case 1 :
                          weekday = 7;
                          break;
                        case 2 :
                          weekday = 1;
                          break;
                        case 3 :
                          weekday = 2;
                          break;
                        case 4 :
                          weekday = 3;
                          break;
                        case 5:
                          weekday = 4;
                          break;
                        case 6 :
                          weekday = 5;
                          break;
                      }
                      selected_days_weekday.add(weekday);

                      List<DateTime> calemndar_dates_list = new List<DateTime>();
                      listOfDatesOfMonth.forEach((element) {
                        var parsedDate = DateFormat('d-M-yyyy').parse(element);
                        if(parsedDate.weekday == weekday){
                          _calendarController.setSelectedDay(
                            DateTime(parsedDate.year, parsedDate.month, parsedDate.day),
                            runCallback: true,
                          );
                          _calendarController.visibleDays.add(parsedDate);
                          calemndar_dates_list.add(parsedDate);
                          dates.add(element);
                          getAllTimes(
                              date: element
                          );
                        }
                      });

                      print("###dates### :${dates}");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(

                            text: "${day_name[index]}",
                            size: height*.018,
                            color: select_day==index?Theme.of(context).primaryColor :Colors.grey,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                      height: height * .06,
                      width: width * .2,
                      decoration: BoxDecoration(
                          border: Border.all(color:select_day==index ?
                          Theme.of(context).primaryColor : Colors.grey, width: height * .002),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(height * .01),
                          )),
                    ),
                  ),
                  SizedBox(width: width*.02,),

                ],
              );
            }));

  }


  Widget TimesView() {

    return isloading == true
        ? AppLoader()
        : hours.schedule == null? Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: times.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 16 / 4),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${times[index]}",
                        textDirection: ui.TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: StaticData.time_stauts[index],
                        onChanged: (value){
                          setState(() {
                            StaticData.time_stauts[index] =! StaticData.time_stauts[index];
                            provider_closed_times.add(times[index]);
                            provider_closed_times_status.add(StaticData.time_stauts[index]==false? 0 : 1);
                          });
                        },
                        activeTrackColor: Colors.grey.shade400,
                        activeColor: Theme.of(context).primaryColor,
                      ),

                    ],
                  ),
                );
              }),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          save_schedule_button()
        ],
      ),
    )

    : Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: times.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 16 / 4),
              itemBuilder: (context, index) {
                var element_index;
                times.forEach((element) {
                  element_index=  times.indexOf(element);

                  for(int i=0;i<hours.schedule.times.length;i++){
                    if(element == hours.schedule.times[i].time){
                      StaticData.time_stauts[element_index] = hours.schedule.times[i].status == 0?false :true;
                    }
                  }
                });
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${times[index]}",
                      textDirection: ui.TextDirection.ltr,
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: StaticData.time_stauts[index],
                      onChanged: (value){
                        setState(() {
                          StaticData.time_stauts[index] =! StaticData.time_stauts[index];
                          print("radio : ${StaticData.time_stauts[index]}");
                          provider_closed_times.add(times[index]);
                          provider_closed_times_status.add(StaticData.time_stauts[index]==false?0 :1);
                        });
                      },
                      activeTrackColor: Colors.grey.shade400,
                      activeColor: Theme.of(context).primaryColor,
                    ),

                  ],
                );
              }),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          save_schedule_button()
        ],
      ),
    );
  }


  Widget save_schedule_button(){
    schedul_list.add(ScheduleDataModel(
      status: provider_closed_times_status,
       times: provider_closed_times
    ).toJson());
    return   Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        CustomButton(
          width: MediaQuery.of(context).size.width/3,
          onBtnPress: () {
            print("provider_closed_times_status : ${provider_closed_times_status}");
            print("provider_closed_times : ${provider_closed_times}");
            print("schedul_list : ${schedul_list}");
            print("dates : ${dates}");

            schedule_bloc.add(UploadScheduleEvent(
                day_date: dates,
                schedule_data: schedul_list
            ));
          },
          text: allTranslations.text("Save"),
        )
      ],
    );
  }

  void getAllTimes({String date}) async {
    print("Times");
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    Map<String, String> headers = {
      'Authorization': token,
    };
    NetworkUtil _util = NetworkUtil();
    Response response =
        await _util.get("http://beauty.wothoq.co/api/beautician/work-schedule/beautician_schedule?day_date=${date}", headers: headers);
    print(response.statusCode);
    if (response.data != null) {
      print("Done");
      setState(() {
        StaticData.time_stauts=[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false, false,false,false,false,false,false,false,false,false];
        hours = WorkScheduleModel.fromJson(json.decode(response.toString()));
        isloading = false;
        hours.schedule==null? null :   _onSelected_day(day_name.indexOf(hours.schedule.dayName));

          if(hours.schedule == null){
            StaticData.time_stauts=[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false, false,false,false,false,false,false,false,false,false];

          }

      });
    } else {
      print("ERROR");
      print(response.data.toString());
    }
  }

  void get_all_dates_of_month({String month}){
  // Take the input year, month number, and pass it inside DateTime()
  var mon =month.substring(1,3);
  var year =month.substring(4,8);
print("year : ${int.parse(year)}");
  print("mon : ${int.parse(mon)}");
  var now = DateTime(int.parse(year), int.parse(mon));
//var now = DateTime(2021,7);
  // Getting the total number of days of the month
  var totalDays = daysInMonth(now);
print("totalDays : ${totalDays}");
  // Stroing all the dates till the last date
  // since we have found the last date using generate
  var listOfDates = new List<int>.generate(totalDays, (i) => i + 1);
    listOfDatesOfMonth = new List<String>.generate(totalDays+1, (i) => "${(i+1)<10? '0${i+1}':i}${month}");
  print(listOfDatesOfMonth);
}


}
// this returns the last date of the month using DateTime
   int daysInMonth(DateTime date){
  var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
  var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}

