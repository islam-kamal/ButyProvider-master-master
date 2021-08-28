import 'dart:convert';
import 'dart:io';

import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/NetWorkUtil.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomBottomSheet.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomTextFormField.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/LoadingDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/on_done_dialog.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/main_page.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/models/categories_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  String name_ar, name_en, desc_ar, desc_en, price, time, cat_name;

  int location_id, cat_id, location;
  bool at_home = true;

  final picker = ImagePicker();
  File imagee;
  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
       );

    setState(() {
      if (pickedFile != null) {
        imagee = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  CategoriesResponse ress = CategoriesResponse();

  void getCats() async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    Map<String, String> headers = {
      'Authorization': token,
    };
    NetworkUtil _util = NetworkUtil();
    Response response = await _util.get("beautician/categories/get-categories",
        headers: headers);
    print(response.statusCode);
    if (response.data != null) {
      print("Done");
      setState(() {
        ress = CategoriesResponse.fromJson(json.decode(response.toString()));
      });
    } else {
      print("ERROR");
      print(response.data.toString());
    }
  }

  @override
  void initState() {
    getCats();
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
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child:   allTranslations.currentLanguage == "ar"
                    ? Icon(Icons.arrow_forward_ios) : Icon(Icons.arrow_back_ios),),
            ],
            centerTitle: true,
            title: Text(
              allTranslations.text("add_services"),
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
        body: SingleChildScrollView(
            child: Column(
          children: [
            categoriesWidgets(),
            Column(
              crossAxisAlignment: allTranslations.currentLanguage =='ar'? CrossAxisAlignment.start :CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05,left: MediaQuery.of(context).size.width * 0.05),
                  child: Text("${allTranslations.text("service_name")}",style: TextStyle(fontWeight: FontWeight.bold)),),
                CustomTextField(
              //    label: "${allTranslations.text("service_name")}",
                  hint: allTranslations.text( "Bride package, hair cut, hairdryer..." ),
                  value: (String val) {
                    setState(() {
                      name_ar = val;
                    });
                  },
                ),
              ],
            ),

            Column(
              crossAxisAlignment: allTranslations.currentLanguage =='ar'? CrossAxisAlignment.start :CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05,left: MediaQuery.of(context).size.width * 0.05),
                  child: Text("${allTranslations.text("details")}",style: TextStyle(fontWeight: FontWeight.bold),),),
                CustomTextField(
                  lines: 3,
                  hint: allTranslations.text("The service includes make-up, eyelashes" )
                 ,
                  value: (String val) {
                    setState(() {
                      desc_ar = val;
                    });
                  },
                ),
              ],
            ),


           Column(
             crossAxisAlignment: allTranslations.currentLanguage =='ar'? CrossAxisAlignment.start :CrossAxisAlignment.start,
             children: [
               Padding(
                 padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05,left: MediaQuery.of(context).size.width * 0.05),
                 child: Text("${allTranslations.text("price")}",style: TextStyle(fontWeight: FontWeight.bold)),
               ),
               CustomTextField(
                 value: (String val) {
                   setState(() {
                     price = val;
                   });
                 },
                 inputType: TextInputType.number,
                 hint: " 150 ${allTranslations.text("sar")}",
               ),
             ],
           ),
            Column(
              crossAxisAlignment: allTranslations.currentLanguage =='ar'? CrossAxisAlignment.start :CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05,left: MediaQuery.of(context).size.width * 0.05),
                  child: Text("${allTranslations.text("service_time")}",style: TextStyle(fontWeight: FontWeight.bold)),),
                CustomTextField(
                  value: (String val) {
                    setState(() {
                      time = val;
                    });
                  },
                  inputType: TextInputType.number,
                  hint: "60 ${allTranslations.text( "min")}",
                )
              ],
            ),
         SizedBox(height: 20,),
            CustomButton(
              onBtnPress: () {
                addService();
              },
              text: "${allTranslations.text("add")}",
            )
          ],
        )),
      ),
    );
  }

  Widget SellectImage() {
    return InkWell(
        onTap: getImage,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(imagee == null
                      ? " ${allTranslations.text("service_image")} "
                      : "${allTranslations.text("done_image")}"),
                  imagee == null
                      ? Icon(Icons.image)
                      : Icon(
                          Icons.done_outline,
                          color: Theme.of(context).primaryColor,
                        )
                ],
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5)),
          ),
        ));
  }

  Widget categoriesWidgets() {
    return InkWell(
      onTap: () {
        CustomSheet(
            context: context,
            widget: ListView.builder(
                itemCount: ress.categories.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            cat_name = ress.categories[index].name;
                            cat_id = ress.categories[index].id;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          ress.categories[index].name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider()
                    ],
                  );
                }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cat_name ?? " ${allTranslations.text("choose_cat")}"),
                Icon(Icons.keyboard_arrow_down)
              ],
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

/*  Widget service_address() {
    return Container(
      width: double.infinity,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  at_home = false;
                  location = 1;
                });
              },
              child: Row(
                children: [
                  at_home == true
                      ? Icon(
                          Icons.check_box_outline_blank,
                          color: Theme.of(context).primaryColor,
                        )
                      : Icon(
                          Icons.check_box,
                          color: Theme.of(context).primaryColor,
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(allTranslations.text("at_buty")),
                  ),
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
                ],
              ),
            ),
            SizedBox(width: 20,),
            InkWell(
              onTap: () {
                setState(() {
                  at_home = true;
                  location = 0;
                });
              },
              child: Row(
                children: [
                  at_home == true
                      ? Icon(
                          Icons.check_box,
                          color: Theme.of(context).primaryColor,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Theme.of(context).primaryColor,
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(allTranslations.text("at_home")),
                  ),
                  Container(
                    child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.home,
                          color: Theme.of(context).primaryColor,
                        )),
                    decoration: BoxDecoration(
                        color: Colors.grey[50], shape: BoxShape.circle),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  void addService() async {
    showLoadingDialog(context);
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    int id = await mSharedPreferenceManager.readInteger(CachingKey.USER_ID);
    print("IDDDDDD  =====> ${id}");
    FormData formData = FormData.fromMap({
      "lang": allTranslations.currentLanguage,
      "name_ar": name_ar,
   //   "name_en": name_en,
      // "details_en": desc_ar,
      "details_ar": desc_ar,
      "category_id": cat_id,
      "price": price,
      "estimated_time": time,
    //  "location": at_home == true ? 0 : 1,
  //    "service_icon": imagee == null ? null : await MultipartFile.fromFile(imagee.path),
      "beautician_id": id
    });
    Map<String, String> headers = {
      'Authorization': token,
    };
    NetworkUtil _util = NetworkUtil();
    Response response = await _util.post("beautician/services/store",
        body: formData, headers: headers);
    print(response.statusCode);
    if (response.data["status"] != false) {
      Navigator.pop(context);

      onDoneDialog(
          context: context,
          text: response.data["msg"],
          function: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(
                    index: 2,
                  ),
                ),
                (Route<dynamic> route) => false);
          });
    } else {
      print("ERROR");
      Navigator.pop(context);
      errorDialog(
          context: context,
          text: response.data["msg"],
          function: () {
            Navigator.pop(context);
          });
      print(response.data.toString());
    }
  }
}
