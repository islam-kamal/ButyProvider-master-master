import 'dart:convert';

import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/Bolcs/signupBloc.dart';
import 'package:BeauT_Stylist/NetWorkUtil.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/helpers/static_data.dart';
import 'package:BeauT_Stylist/models/cites_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cities extends StatefulWidget{
   int user_city;
  Cities({this.user_city});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Cities_State();
  }
  
}

class Cities_State extends State<Cities>{
  int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<CitiesResponse>(
      future: getAllCities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data.cities.length != 0) {
              _currentIndex ==1? widget.user_city : _currentIndex;
              return  Container(
                height: MediaQuery.of(context).size.width /3,
                child: ListView.builder(
                    itemCount: snapshot.data.cities.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        value: snapshot.data.cities[index].id,
                        groupValue: widget.user_city,
                        onChanged: (ind) {
                          setState(() {
                            widget.user_city = ind;
                            StaticData.city_id = widget.user_city;
                          });

                          signUpBloc.updateCityId(snapshot.data.cities[index].id);
                          print("city_id :: ${snapshot.data.cities[index].id}");
                        },
                        activeColor: Colors.green,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${snapshot.data.cities[index].nameEn} ",
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      );

                    }),
              );
            } else {
              return   Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Text(
                        allTranslations.text( "no_city" ),
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                      )
                    ],
                  ),
                ),
              );
            }
          } else {
            return    Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Text(
                      allTranslations.text( "no_city" ),
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                    )
                  ],
                ),
              ),
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );


  }


  Future<CitiesResponse> getAllCities() async {
    print("In CITIES Service");
    Response response = await NetworkUtil.internal().get(
      "cities/get-all-cities?lang=${allTranslations.currentLanguage}",
    );
    print("STATUS CODE =========> ${response.statusCode}");
    print("RESPONSE =========> ${response}");

    return CitiesResponse.fromJson(json.decode(response.toString()));
  }


}