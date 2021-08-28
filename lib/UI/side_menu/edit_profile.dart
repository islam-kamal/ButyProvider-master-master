import 'dart:convert';
import 'dart:io';
import 'package:BeauT_Stylist/Bolcs/getpayment%20methods%20bloc.dart';
import 'package:BeauT_Stylist/models/login_model.dart' as login_model;

import 'package:BeauT_Stylist/Bolcs/signupBloc.dart';
import 'package:BeauT_Stylist/Bolcs/update_profile_bloc.dart';
import 'package:BeauT_Stylist/UI/Auth/cities.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/AppLoader.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomTextFormField.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/LoadingDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/on_done_dialog.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/main_page.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/helpers/static_data.dart';
import 'package:BeauT_Stylist/models/login_model.dart';
import 'package:BeauT_Stylist/models/provider_payment_methods.dart';
import 'package:BeauT_Stylist/models/updateProfileResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String type = "data";
  GlobalKey<FormState> dataKey = GlobalKey();
  GlobalKey<FormState> passKey = GlobalKey();
  List<int> paymentMethdos = [];

  String name, email, phone, user_image,account_name;
  int city_id;
  File _image;
  final picker = ImagePicker();
  List<File> images = [];


  @override
  void initState() {
    getFromCash();
    allPaymentMethods.add(Hydrate());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:allTranslations.currentLanguage == "ar" ? TextDirection.rtl :TextDirection.ltr,
      child: Directionality(
          textDirection: allTranslations.currentLanguage == "ar"
              ? TextDirection.rtl
              : TextDirection.ltr,
          child:Scaffold(
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
                allTranslations.text("edit_profile"),
                style: TextStyle(color: Colors.white, fontSize: 14),
              )),
          body: ListView(
            children: [

              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = "data";
                      });
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            allTranslations.text("edit_profile"),
                            style: TextStyle(
                                fontWeight: type == "data"
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 2,
                            color:
                                type == "data" ? Colors.black : Colors.grey[200],
                          )
                        ],
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      color: Colors.grey[200],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = "last";
                      });
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            allTranslations.text("password"),
                            style: TextStyle(
                                fontWeight: type == "last"
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 2,
                            color:
                                type == "last" ? Colors.black : Colors.grey[200],
                          )
                        ],
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),

              type == "data" ? editDataView(name, email, phone) : passView(),

              SizedBox(
                height: 20,
              ),

              BlocListener(
                bloc: updateProfileBloc,
                listener: (context, state) {
                  var data = state.model as UpadteProfileResponse;
                  if (state is Loading) {
                    showLoadingDialog(context);
                    print("@@@@@ Loading ");

                  } else if (state is ErrorLoading) {
                    Navigator.pop(context);
                    errorDialog(
                      context: context,
                      text: data.msg,
                    );
                    print("Dialoggg");
                  } else if (state is Done) {
                    print("@@@@@ Done @@@@@@@2");
                    var data = state.model as UpadteProfileResponse;
                    print("data-------- ${data.beautician}");
                    sharedPreferenceManager.writeData(CachingKey.USER_NAME, data.beautician.ownerName);
                    sharedPreferenceManager.writeData(CachingKey.EMAIL, data.beautician.email);
                    sharedPreferenceManager.writeData(CachingKey.MOBILE_NUMBER, data.beautician.mobile);
                    sharedPreferenceManager.writeData(CachingKey.USER_IMAGE, data.beautician.photo);
                    sharedPreferenceManager.writeData(CachingKey.ACCOUNT_NAME, data.beautician.beautName);
                    sharedPreferenceManager.writeData(CachingKey.CITY_ID, data.beautician.cityId);

                    StaticData.service_location = data.beautician.serviceLocation;
                    StaticData.payment_method = data.beautician.paymentMethods.cast<login_model.PaymentMethods>();
                    onDoneDialog(
                        context: context,
                        text: data.msg,
                        function: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(
                                  index: 0,
                                ),
                              ),
                              (Route<dynamic> route) => false);
                        });
                    print("&&&&&&&& Done @@@@@@@2");

                  }
                },
                child: CustomButton(
                  onBtnPress: () {
                    if (type == "data") {
                      if (!dataKey.currentState.validate()) {
                        return;
                      } else {
                        updateProfileBloc.add(Click(
                          paymentMethdos: paymentMethdos,
                          user_photo: _image
                        ));
                      }
                    } else {
                      if (!passKey.currentState.validate()) {
                        return;
                      } else {
                        print("profile 1");
                        updateProfileBloc.add(Click(
                        ));
                        print("profile 2");
                      }
                    }
                  },
                  text: allTranslations.text("change"),
                ),
              ),

            ],
          ))),
    );
  }

  Widget rowItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: TextStyle(fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  Widget editDataView(String name, String email, String phone) {
    return Form(
      key: dataKey,
      child: Column(
        children: [
          InkWell(
            onTap: getImage,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Container(
                  child: Center(
                    child: _image == null
                        ? Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    )
                        : SizedBox(),
                  ),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image != null
                              ? FileImage(_image)
                              : NetworkImage(user_image)),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: rowItem(Icons.account_circle, allTranslations.text("account_name")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              value: (String val) {
                updateProfileBloc.updateBeautName(val);
              },
              validate: (String val) {
                if (val.isNotEmpty && val.length < 3) {
                  return "      ";
                }
              },
              hint: "${account_name ?? " "}",
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: rowItem(Icons.person, allTranslations.text("name")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              value: (String val) {
                updateProfileBloc.updateName(val);
              },
              validate: (String val) {
                if (val.isNotEmpty && val.length < 3) {
                  return "      ";
                }
              },
              hint: "${name ?? " "}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: rowItem(Icons.phone, allTranslations.text("phone")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              value: (String val) {
                print("mobile-value : ${val}");
                updateProfileBloc.updateMobile(val);
              },
              validate: (String val) {
                if (val.isNotEmpty && val.length < 10) {
                  return "      ";
                }
              },
              hint: "+${phone ?? ""}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: rowItem(Icons.mail, allTranslations.text("email")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              value: (String val) {
                updateProfileBloc.updateEmail(val);
              },
              validate: (String val) {
                if (val.isNotEmpty && val.contains("@") == false) {
                  return "      ";
                }
              },
              hint: "${email}",
            ),
          ),
          Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
            children: [
              rowItem(Icons.location_city, allTranslations.text("city")),
              Cities(
                 user_city: city_id,
              ),
            ],
          ),),
          //-------------- update payment methods -----------------------------
          paymentmethods(),

        ],
      ),
    );
  }

  Widget passView() {
    return Form(
      key: passKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                rowItem(Icons.lock, allTranslations.text("current_password")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              value: (String val) {
                updateProfileBloc.updateCurrentPassword(val);
              },
              validate: (String val) {
                if (val.isNotEmpty && val.length < 8) {
                  return "      ";
                }
              },
              secureText: true,
              hint: "*****************",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: rowItem(Icons.lock, allTranslations.text("new_password")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              value: (String val) {
                updateProfileBloc.updateNewPassword(val);
              },
              validate: (String val) {
                if (val.isNotEmpty && val.length < 8) {
                  return "      ";
                }
              },
              secureText: true,
              hint: "*****************",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: rowItem(
                Icons.lock, allTranslations.text("confirm_new_password")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              value: (String val) {
                updateProfileBloc.updateConfirmPassword(val);
              },
              validate: (String val) {
                if (val.isNotEmpty && val.length < 8) {
                  return "      ";
                }
              },
              secureText: true,
              hint: "*****************",
            ),
          ),
        ],
      ),
    );
  }


  Widget paymentmethods() {
    return BlocListener(
      bloc: allPaymentMethods,
      listener: (context, state) {},
      child: BlocBuilder(
          bloc: allPaymentMethods,
          builder: (context, state) {
            var data = state.model as ProviderPaymentMethodResponse;
            data.paymentMethods[0].isSellected = true;
            return Container(
              height: 50,
              child: data == null
                  ? AppLoader()
                  : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.paymentMethods.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (data.paymentMethods[index].isSellected == false) {
                          setState(() {
                            data.paymentMethods[index].isSellected = true;
                            paymentMethdos.add(data.paymentMethods[index].id);
                          });
                        } else {
                          setState(() {
                            data.paymentMethods[index].isSellected = false;
                          });
                          for (int i = 0; i <= data.paymentMethods.length; i++) {
                            if (data.paymentMethods[i].isSellected ==
                                false) {
                              paymentMethdos.removeAt(i);
                              print(paymentMethdos.toString());
                            }
                          }
                        }
                        print("paymentMethdos : $paymentMethdos");
                      },
                      child: Row(
                        children: [

                      Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10),
                      child:data.paymentMethods[index].isSellected == false
                              ? Icon(
                            Icons.check_box_outline_blank,
                            color: Theme.of(context).primaryColor,
                          )
                              : Icon(
                            Icons.check_box,
                            color: Theme.of(context).primaryColor,
                          ),
                      ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0),
                            child: Text(data.paymentMethods[index].name),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }),
    );
  }


  getFromCash() async {
    String _name, _email, _phone,_user_image, _account_name;
    var mSharedPreferenceManager = SharedPreferenceManager();

    _email = await mSharedPreferenceManager.readString(CachingKey.EMAIL);
    _phone = await mSharedPreferenceManager.readString(CachingKey.MOBILE_NUMBER);
    _name = await mSharedPreferenceManager.readString(CachingKey.USER_NAME);
    _user_image =  await mSharedPreferenceManager.readString(CachingKey.USER_IMAGE);
    _account_name = await mSharedPreferenceManager.readString(CachingKey.ACCOUNT_NAME);
    city_id  =  StaticData.city_id;

    setState(() {
      name = _name;
      email = _email;
      phone = _phone;
      user_image = _user_image;
      account_name = _account_name;
    });
    print(" payment_method : ${  StaticData.payment_method}");

  }

  Future addImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
       );
    /*   setState(() {
      pickedFile == null ? null : images.add(File(pickedFile.path));
    });*/
    _cropImage(
        path: pickedFile.path,
        type: 'services'
    );
  }
  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

    setState(() {
      if (pickedFile != null) {
        //  _image = File(pickedFile.path);
        _cropImage(
            path: pickedFile.path,
            type: 'profile'
        );
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> _cropImage({String path,String type}) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    setState(() {
      if(type == 'profile'){
        if (croppedFile != null) {
          _image = croppedFile;

        }
      }else{
        if (croppedFile != null) {
          images.add(File(croppedFile.path));
          croppedFile = null;
        }
      }

    });

  }
}
