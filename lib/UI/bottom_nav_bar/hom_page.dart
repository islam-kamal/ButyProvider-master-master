import 'dart:convert';

import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/Bolcs/canselOrderBloc.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/AppLoader.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomBottomSheet.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomTextFormField.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/EmptyItem.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/LoadingDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/on_done_dialog.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/main_page.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/models/general_response.dart';
import 'package:BeauT_Stylist/models/home_page_response.dart' as home_model;
import 'package:BeauT_Stylist/models/home_page_response.dart';
import 'package:BeauT_Stylist/models/order_status_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../NetWorkUtil.dart';

class HomePage extends StatefulWidget {
  final bool new_order_notification;
  final int order_id;
  HomePage({this.new_order_notification=false,this.order_id});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  List<Marker> _markers;

  @override
  void initState() {
    print("home new order_id : ${widget.order_id}");
    getHomeData();
    _markers = <Marker>[];
print("order_id : ${widget.order_id}");
    super.initState();
  }

  HomePageResponse data = HomePageResponse();
  bool isLoading = true;

  void getHomeData() async {
    print("getting Cats");
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    Map<String, String> headers = {
      'Authorization': token,
    };
    NetworkUtil _util = NetworkUtil();
    Response response = await _util
        .post("beautician/home/beautician-revenue?lang=${allTranslations.currentLanguage}", headers: headers);
    print(response.statusCode);
    if (response.data != null) {
      print("Done");
      setState(() {
        data = HomePageResponse.fromJson(json.decode(response.toString()));
        isLoading = false;
        data.data.totalRate == null ? mSharedPreferenceManager.writeData(CachingKey.RATE, 0)
            : mSharedPreferenceManager.writeData(CachingKey.RATE, data.data.totalRate.value);
      });
    } else {
      print("ERROR");
      print(response.data.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Image.asset(
              "assets/images/header.png",
              fit: BoxFit.contain,
              width: 100,
              height: 30,
            )),
        body: isLoading == true
            ? AppLoader()
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: [
                  VisitsHeader(
        lable:"${allTranslations.text("confirmed_order_number")}",
                      value : data.data.visits,
                      type: "num"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Header("${allTranslations.text("total_win")}",
                          data.data.totalRevenue, "sar"),
                      Header("${allTranslations.text("rest")}",
                          data.data.totalRevenue, "sar"),
                    ],
                  ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child:   Text(
                    "${allTranslations.text( "Reservations List" )}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),

                data.data.orders.length==0 ? EmptyItem(text: allTranslations.text("no_requests"),):  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.data.orders.length,
                      itemBuilder: (context, index) {

                        return  Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey[200])),
                          // height: MediaQuery.of(context).size.height / 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "# ${data.data.orders[index].orderNum}",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                orderLayer(
                                    Icons.person,
                                    data.data.orders[index].user.name?? //--------------------------- edit with username
                                        " كريم طه"),
                                Row(
                                  children: [
                                    orderLayer(Icons.calendar_today,
                                        data.data.orders[index].date),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    orderLayer(Icons.timer,
                                        data.data.orders[index].time),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "${allTranslations.text("status")}   :       "),
                                    Text(
                                        "${data.data.orders[index].paymentStatus} "),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "${allTranslations.text("order_status")}   :       "),
                                    Text(
                                        "${data.data.orders[index].orderStatus} "),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "${allTranslations.text("service_address")}   : "),
                                    Text(
                                        "${data.data.orders[index].locationType} "),
                                  ],
                                ),

                                services(data.data.orders[index].services),


                       data.data.orders[index].userLocation == null ?  Container()
                       :      Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: Color(
                                                0xFF959090),
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            allTranslations.text('on_map'),
                                            style: TextStyle(
                                                color: Color(
                                                    0xFF292929),
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    salonLoction(
                                      name: data.data.orders[index].userLocation.address,
                                      lat: double.parse(data.data.orders[index].userLocation.latitude),
                                      lang:  double.parse(data.data.orders[index].userLocation.longitude),
                                    ),
                                  ],
                                ),


                              BlocListener(
                                bloc: canselOrderbloc,
                                listener: (context,state){
                                  var data = state.model as OrderStatusModel;
                                  if(state is Loading){
                                    showLoadingDialog(context);
                                  }else if(state is Done){
                                    Navigator.pop(context);

                                    onDoneDialog(
                                        context: context,
                                        text: data.msg,
                                        function: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                            builder: (context)=> MainPage(index: 0,),
                                          ));
                                        });
                                  }else if(state is ErrorLoading){
                                    errorDialog(
                                      context: context,
                                      text: data.msg,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child:   Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      CustomButton(
                                        onBtnPress: () {
                                          canselOrderbloc.updateId(data.data.orders[index].id);
                                          canselOrderbloc.updateStatus(1);
                                          canselOrderbloc.add(Click());

                                        },
                                        text: allTranslations.text("Accept"),
                                        color: Theme.of(context)
                                            .primaryColor,
                                        width: MediaQuery.of(context).size.width / 3,
                                        higth: MediaQuery.of(context).size.width/12,
                                      ),
                                      CustomButton(
                                        onBtnPress: () {

                                          CustomSheet(
                                              context: context,
                                              widget: cansel(
                                                  id : data.data.orders[index].id,
                                                  status: 2
                                              ),
                                              hight: MediaQuery.of(context).size.height / 2.7);
                                        },
                                        text: allTranslations.text("Refuse"),
                                        color: Colors.white,
                                        borderColor:
                                        Theme.of(context).primaryColor,
                                        textColor:
                                        Theme.of(context).primaryColor,
                                        width: MediaQuery.of(context).size.width /3,
                                        higth: MediaQuery.of(context).size.width/12,

                                      ),
                                    ],
                                  ),
                                ),
                              )


                              ],
                            ),
                          ),
                        );
                      })


                ],
              ));
  }

  Widget new_order_pop(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 20,
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text("")
              ),
            ),
          );
        });  }

  Widget orderLayer(IconData icon, String hint) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(hint),
        )
      ],
    );
  }

  Widget Header(String lable, int value, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
     //   width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.width /4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    color: Colors.grey[100],
                    height: 50,
                    width: 50,
                    child: Center(
                      child: Center(child: Icon(Icons.money_off)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          "${lable}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${value} ${type == "sar" ? allTranslations.text("sar") : allTranslations.text("visite")}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget VisitsHeader({String lable, int value, String type}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20,),
      child: Container(
        height: MediaQuery.of(context).size.width/3.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.visibility,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "${lable}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "${value}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          type == "sar"
                              ? allTranslations.text("sar")
                              : allTranslations.text("visite"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget services(List<home_model.Services> services){

    return  Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  allTranslations.text('service_name'),
                  style:
                  TextStyle(
                    color: Color(
                        0xFF292929),
                  ),),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  allTranslations.text("service_price"),
                  style:
                  TextStyle(
                    color: Color(
                        0xFF292929),
                  ),),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  allTranslations.text('persons'),
                  style:
                  TextStyle(
                    color: Color(
                        0xFF292929),
                  ),),
              ),
            )
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.only(
                        right:
                        2,
                        left:
                        2),
                    child:Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(

                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    decoration: BoxDecoration(
                                        color:
                                        Color(0xFFF6F6F6),
                                        borderRadius: BorderRadius.circular(5)),
                                    child:
                                    Text(
                                      '${ services[i].nameAr }',
                                      style: TextStyle(
                                          color: Color(0xFF403E3E),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                )
                                ,
                                SizedBox(width: 5,),
                              ],
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment:
                                    Alignment.center,
                                    decoration: BoxDecoration(
                                        color:
                                        Color(0xFFF6F6F6),
                                        borderRadius: BorderRadius.circular(5)),
                                    child:
                                    Text(
                                      '${services[i].price}  ${     allTranslations.text('sar')}  ',
                                      style: TextStyle(
                                          color: Color(0xFF403E3E),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,)
                              ],
                            )
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            //   width: MediaQuery.of(context).size.width / 3,
                            alignment:
                            Alignment.center,
                            decoration: BoxDecoration(
                                color:
                                Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(5)),
                            child:
                            Text(
                              '${services[i].personNum}',
                              style: TextStyle(
                                  color: Color(0xFF403E3E),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 5,)
              ],
            );
          },
        ),
      ],
    );
  }

  Widget salonLoction({String name, double lat, double lang}) {
    _markers.add(Marker(
        markerId: MarkerId(''),
        position: LatLng(lat, lang),
        infoWindow: InfoWindow(title: '${name}')));
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 2,
        child: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          markers: Set<Marker>.of(_markers),
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, lang),
            zoom: 11.0,
          ),
        ),
      ),
    );
  }


  Widget cansel({int id,int status}) {
    print(id);
    return BlocListener(
      bloc: canselOrderbloc,
      listener: (context, state) {
        var data = state.model as OrderStatusModel;
        if (state is Loading) {
          showLoadingDialog(context);
        } else if (state is ErrorLoading) {
          errorDialog(context: context, text: data.msg);
        } else if (state is Done) {
          Navigator.pop(context);

          onDoneDialog(
              context: context,
              text: data.msg,
              function: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=> MainPage(index: 0,),
                ));
              });
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child:  Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child:  Text(
                          allTranslations.text("validate_cansel"),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )  ),
                    Padding(padding: EdgeInsets.all(10),
                        child:CustomTextField(
                          hint: allTranslations.text("cancel reason details"),
                          inputType: TextInputType.text,
                          validate: (String val) {
                            if (val.isEmpty) {
                              return allTranslations.text("cancel reason details");
                            }
                          },
                          lines: 3,
                          value: (String val) {
                            canselOrderbloc.cancel_reason(val);
                          },
                        )  ),
                  ],
                )


            ),
            Row(
              children: [

                CustomButton(
                  onBtnPress: () {
                    Navigator.pop(context);
                  },
                  width: MediaQuery.of(context).size.width / 2.8,
                  text: allTranslations.text("no"),
                  textColor: Colors.black,
                  color: Colors.white,
                  raduis: 1,
                ),
                CustomButton(
                  onBtnPress: () {
                    canselOrderbloc.updateId(id);
                    canselOrderbloc.updateStatus(status);
                    canselOrderbloc.add(Click());
                  },
                  width: MediaQuery.of(context).size.width / 2.8,
                  text: allTranslations.text("yes"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
