import 'dart:io';

import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/Bolcs/getpayment%20methods%20bloc.dart';
import 'package:BeauT_Stylist/Bolcs/signupBloc.dart';
import 'package:BeauT_Stylist/UI/Auth/check_code.dart';
import 'package:BeauT_Stylist/UI/Auth/sign_up.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/AppLoader.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomTextFormField.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/models/general_response.dart';
import 'package:BeauT_Stylist/models/provider_payment_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class CompleteSignUp extends StatefulWidget {
  @override
  _CompleteSignUpState createState() => _CompleteSignUpState();
}

class _CompleteSignUpState extends State<CompleteSignUp> {
  File _image;
  final picker = ImagePicker();
  List<File> photos = [];
  List<int> paymentMethdos = [];
  GlobalKey<FormState> key = GlobalKey();
  bool acceptTerms = false;
  List<PaymentMethods> list = [
    PaymentMethods(
        isSellected: false, id: 1, name: allTranslations.text("at_buty")),
    PaymentMethods(
        isSellected: false, id: 1, name: allTranslations.text("at_home"))
  ];
  List<File> images = [];

  Widget drowGallaryBox() {
    return ListView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              width: 100,
              height: MediaQuery.of(context).size.height / 7.5,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      images.removeAt(index);
                    });
                  },
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  )),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: FileImage(images[index]),
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black45, BlendMode.darken))),
            ),
          );
        });
  }

  Future addImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,);
 /*   setState(() {
      pickedFile == null ? null : images.add(File(pickedFile.path));
    });*/
 _cropImage(
   path: pickedFile.path,
   type: 'services'
 );
  }

  @override
  void initState() {
    allPaymentMethods.add(Hydrate());
    super.initState();
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
              width: 150,
              height: 30,
            ),
          actions: [
            allTranslations.currentLanguage == "ar"? Padding(padding: EdgeInsets.only(right: 5),
              child:  InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                },
                child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
              ),) : Padding(padding: EdgeInsets.only(left: 5),
              child:  InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                },
                child: Icon(Icons.arrow_back_ios,color: Colors.white,),
              ),)
          ],
        ),
        body: BlocListener(
          bloc: signUpBloc,
          listener: (context, state) {
            var data = state.model as GeneralResponse;
            if (state is ErrorLoading) {
              Navigator.of(context).pop();
              errorDialog(
                context: context,
                text: data.msg,
              );
            }
            if (state is Done) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckCode(
                      email: "karimmtahaa96@gmail.com",
                    ),
                  ));
            }
          },
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      : NetworkImage("")),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ),
                  ),
                  rowItem(Icons.person, allTranslations.text("account_name")),
                  CustomTextField(
                    dir: TextDirection.ltr,
                    validate: (String val) {
                      if (val.isEmpty || val.contains("@") == false) {
                        return "This Filed Must Contains ${"@"}  And Must Be In English ";
                      }
                    },
                    hint: "@username",
                    inputType: TextInputType.emailAddress,
                    value: (String val) {
                      signUpBloc.updateButeName(val);
                    },
                  ),
                  rowItem(Icons.person, allTranslations.text("name")),
                  CustomTextField(
                    validate: (String val) {
                      if (val.isEmpty) {
                        return "${allTranslations.text("complete_data")}";
                      }
                    },
                    hint: allTranslations.text("name"),
                    inputType: TextInputType.emailAddress,
                    value: (String val) {
                      signUpBloc.updateName(val);
                    },
                  ),
                  rowItem(Icons.perm_media, allTranslations.text("insta_link")),
                  CustomTextField(
          /*          validate: (String val) {
                      if (val.isEmpty) {
                        return "${allTranslations.text("insta_link_validator")}";
                      }
                    },*/
                    hint: allTranslations.text("insta_link"),
                    inputType: TextInputType.emailAddress,
                    value: (String val) {
                      signUpBloc.updateInstalink(val);
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Text(
                      allTranslations.text("payment_methods"),
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  paymentmethods(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Text(
                      allTranslations.text("service_address"),
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  service_address(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Text(
                      allTranslations.text("last_works"),
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 7.3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          InkWell(
                            onTap: addImage,
                            child: Container(
                              width: 100,
                              height: MediaQuery.of(context).size.height / 7.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: Center(
                                child: Icon(Icons.add),
                              ),
                            ),
                          ),
                          drowGallaryBox(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: checkBoxAndAccept() ,
                  ),
                  CustomButton(
                    onBtnPress: () {
                      if (!key.currentState.validate()) {
                        return;
                      } else {
                        signUpBloc.updateImages(images);
                        signUpBloc.updatepayment(paymentMethdos);
                        signUpBloc.updateimagee(_image);
                        signUpBloc.add(Click());
                      }
                    },
                    text: "${allTranslations.text("register")}",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rowItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Row(
        children: [
          SizedBox(
            width: 2,
          ),
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          )
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
                            if (data.paymentMethods[index].isSellected ==
                                false) {
                              setState(() {
                                data.paymentMethods[index].isSellected = true;
                                paymentMethdos
                                    .add(data.paymentMethods[index].id);
                              });
                            } else {
                              setState(() {
                                data.paymentMethods[index].isSellected = false;
                              });
                              for (int i = 0;
                                  i <= data.paymentMethods.length;
                                  i++) {
                                if (data.paymentMethods[i].isSellected ==
                                    false) {
                                  paymentMethdos.removeAt(i);
                                  print(paymentMethdos.toString());
                                }
                              }
                            }
                            print(paymentMethdos);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(data.paymentMethods[index].name),
                              ),
                              data.paymentMethods[index].isSellected == false
                                  ? Icon(
                                      Icons.check_box_outline_blank,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : Icon(
                                      Icons.check_box,
                                      color: Theme.of(context).primaryColor,
                                    )
                            ],
                          ),
                        );
                      }),
            );
          }),
    );
  }

  Widget service_address() {
    return Container(
      width: double.infinity,
      height: 60,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  list[index].isSellected = !list[index].isSellected;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    list[index].isSellected == false
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
                      child: Text(list[index].name),
                    ),
                    index == 0
                        ? Container(
                            child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.directions_car,
                                  color: Theme.of(context).primaryColor,
                                )),
                            decoration: BoxDecoration(
                                color: Colors.grey[50], shape: BoxShape.circle),
                          )
                        : Container(
                            child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.home,
                                  color: Theme.of(context).primaryColor,
                                )),
                            decoration: BoxDecoration(
                                color: Colors.grey[50], shape: BoxShape.circle),
                          ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget checkBoxAndAccept() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Theme(
              data: ThemeData(
                  unselectedWidgetColor: Colors.grey,
                  primaryColor: Colors.grey,
                  accentColor: Theme.of(context).primaryColor),
              child: Checkbox(
                  value: acceptTerms,
                  tristate: false,
                  onChanged: (bool value) {
                    setState(() {
                      acceptTerms = !acceptTerms;
                      print(acceptTerms);
                    });
                  })),
          Text(
            allTranslations.text("Accept terms & conditions *"),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: (){
              _launchURL(allTranslations.currentLanguage == 'ar' ? 'https://beauty.wothoq.co/terms-beaut/ar' : 'https://beauty.wothoq.co/terms-beaut/en');
            },
            child: Text("  ${allTranslations.text("Click Here")}",style: TextStyle(color: Theme.of(context).primaryColor),),
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
