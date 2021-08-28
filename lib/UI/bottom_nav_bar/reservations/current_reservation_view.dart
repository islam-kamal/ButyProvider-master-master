import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/Bolcs/canselOrderBloc.dart';
import 'package:BeauT_Stylist/Bolcs/get_current_orders_bloc.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/AppLoader.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomBottomSheet.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomTextFormField.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/EmptyItem.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/LoadingDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/on_done_dialog.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/models/current_ordera_model.dart' as cureent_model;
import 'package:BeauT_Stylist/models/general_response.dart';
import 'package:BeauT_Stylist/models/order_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:BeauT_Stylist/models/current_ordera_model.dart';

class CurrentReservationView extends StatefulWidget {
  @override
  _CurrentReservationViewState createState() => _CurrentReservationViewState();
}

class _CurrentReservationViewState extends State<CurrentReservationView> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  List<Marker> _markers;

  @override
  void initState() {
    _markers = <Marker>[];
    currentOrdersBloc.add(CurrentReservatiosnEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: currentOrdersBloc,
        builder: (context, state) {
      if (state is Loading) {
        return AppLoader();
      } else if (state is Done) {
        var data = state.model as CurrentOrdersResponse;
        if (data.orders == null) {
          return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 150),
            child: Center(
                child: Text(allTranslations.currentLanguage == "en"
                    ? "No Reservations"
                    : "ليس لديك طلبات حالية حتي الان")),
          );
        } else {
         return StreamBuilder<CurrentOrdersResponse>(
            stream: currentOrdersBloc.subject,
            builder: (context,snapshot){
              if(snapshot.hasData){
                if (snapshot.data.orders.isEmpty) {
                  return  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 150),
                    child: Center(
                        child: Text(allTranslations.currentLanguage == "en"
                            ? "No Reservations"
                            : "ليس لديك طلبات حالية حتي الان")),
                  );
                }else{
                  return  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.orders.length,
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
                                    "# ${snapshot.data.orders[index].orderNum}",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                orderLayer(
                                    Icons.person,
                                    snapshot.data.orders[index].user.name?? //--------------------------- edit with username
                                        " كريم طه"),
                                Row(
                                  children: [
                                    orderLayer(Icons.calendar_today,
                                        snapshot.data.orders[index].date),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    orderLayer(Icons.timer,
                                        snapshot.data.orders[index].time),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "${allTranslations.text("status")}   :       "),
                                    Text(
                                        "${snapshot.data.orders[index].paymentStatus} "),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "${allTranslations.text("order_status")}   :       "),
                                    Text(
                                        "${snapshot.data.orders[index].orderStatus} "),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "${allTranslations.text("service_address")}   : "),
                                    Text(
                                        "${snapshot.data.orders[index].locationType} "),
                                  ],
                                ),

                                services(snapshot.data.orders[index].services),


                                snapshot.data.orders[index].userLocation == null ?  Container()
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
                                      name: snapshot.data.orders[index].userLocation.address,
                                      lat: double.parse(snapshot.data.orders[index].userLocation.latitude),
                                      lang:  double.parse(snapshot.data.orders[index].userLocation.longitude),
                                    ),
                                  ],
                                ),



                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child:   Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      CustomButton(
                                        onBtnPress: () {
                                          canselOrderbloc.updateId(snapshot.data.orders[index].id);
                                          canselOrderbloc.updateStatus(4);
                                          canselOrderbloc.add(Click());
                                        },
                                        text: allTranslations.text("Completed"),
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
                                                  id : snapshot.data.orders[index].id,
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
                                )

                              ],
                            ),
                          ),
                        );
                      });
                }
              }else{
                return AppLoader();
              }

            },
          );
        }
      }else if(state is ErrorLoading){
        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 150),
          child: Center(
              child: Text(allTranslations.currentLanguage == "en"
                  ? "No Reservations"
                  : "ليس لديك طلبات حالية حتي الان")),
        );
      }else{
        return AppLoader();

      }
    });



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
                Navigator.pop(context);
                Navigator.pop(context);
                currentOrdersBloc.add(Hydrate());
              });
        }
      },
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
    );
  }

  Widget services(List<cureent_model.Services> services){

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
                                      '${services[i].price}  ${allTranslations.text('sar')}  ',
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
}
