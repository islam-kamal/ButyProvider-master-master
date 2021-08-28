import 'dart:io';

import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:BeauT_Stylist/Bolcs/get_images_bloc.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/AppLoader.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomBottomSheet.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/CustomButton.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/ErrorDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/LoadingDialog.dart';
import 'package:BeauT_Stylist/UI/CustomWidgets/on_done_dialog.dart';
import 'package:BeauT_Stylist/UI/bottom_nav_bar/main_page.dart';
import 'package:BeauT_Stylist/helpers/appEvent.dart';
import 'package:BeauT_Stylist/helpers/appState.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/models/all_images_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../NetWorkUtil.dart';

class Images extends StatefulWidget {
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  List<File> images = [];
  final picker = ImagePicker();
  File _image;

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery , imageQuality: 100 , );
    setState(() {
      pickedFile == null ? null : images.add(File(pickedFile.path));
    });
    _cropImage(
        path: pickedFile.path,
        type: 'services'
    );
    pickedFile == null ? null : addSalonImages();
  }

  void addSalonImages() async {
    List<MultipartFile> _photos = [];
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    showLoadingDialog(context);

    FormData formData =
        FormData.fromMap({"lang": allTranslations.currentLanguage});
    Map<String, String> headers = {
      'Authorization': token,
    };
    for (int i = 0; i < images.length; i++) {
      _photos.add(MultipartFile.fromFileSync(images[i].path,
          filename: "${images[i].path}.jpg"));
      formData.files.add(MapEntry("photos[${i}]", _photos[i]));
    }

    NetworkUtil _util = NetworkUtil();
    Response response = await _util.post("beautician/gallery/store",
        body: formData, headers: headers);
    print(response.statusCode);
    if (response.data["status"] != false) {
      print("Done");
      Navigator.pop(context);
      onDoneDialog(
          context: context,
          text: "${response.data["msg"]}",
          function: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Images()));
          });
    } else {
      print("ERROR");
      print(response.data.toString());
      Navigator.pop(context);
      errorDialog(context: context, text: response.data["msg"]);
    }
  }

  void deleteImage(int id, Function onDone) async {
    showLoadingDialog(context);
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);

    FormData formData = FormData.fromMap(
        {"lang": allTranslations.currentLanguage, "gallery_id": id});
    Map<String, String> headers = {
      'Authorization': token,
    };
    NetworkUtil _util = NetworkUtil();
    Response response = await _util.post("beautician/gallery/destroy",
        body: formData, headers: headers);
    print(response.statusCode);
    if (response.data["status"] != false) {
      onDone();
    } else {
      print("ERROR");
      Navigator.pop(context);
      errorDialog(context: context, text: response.data["msg"]);
      print(response.data.toString());
    }
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
  void initState() {
    getImagesBloc.add(Hydrate());
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPage(
                            index: 0,
                          )));
                },
                child:   allTranslations.currentLanguage == "ar"
                    ? Icon(Icons.arrow_forward_ios) : Icon(Icons.arrow_back_ios),),
            ],
            centerTitle: true,
            title: Text(
              allTranslations.text("images"),
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
        body: ListView(
          children: [
            InkWell(
              onTap: getImage,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${allTranslations.text("add_Image")}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            BlocListener<GetImagesBloc, AppState>(
              bloc: getImagesBloc,
              listener: (context, state) {},
              child:  BlocBuilder(
                bloc: getImagesBloc,
                builder: (context, state) {
                  if (state is Loading) {
                    return Center(
                      child: SpinKitFadingCircle(color: Theme.of(context).primaryColor),
                    );
                  } else if (state is Done) {
                    var data = state.model as GallaryResponse;
                    if (data.gallery == null) {
                      return Container();

                    }
                    else {
                      return  AnimationLimiter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.gallery.length,
                          itemBuilder: (context, index) {

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: Stack(
                                children: [
                                  Card(
                                    child: Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(data
                                                  .gallery[index].photo))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      CustomSheet(
                                          context: context,
                                          hight: MediaQuery.of(context).size.height / 4,
                                          widget: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(vertical: 20),
                                                child: Text(
                                                  "هل انت متأكد من حذف الصورة",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  CustomButton(
                                                    onBtnPress: () {
                                                      Navigator.pop(context);
                                                      print("Deleting Image ======> ${data.gallery[index].id}");
                                                      deleteImage(data.gallery[index].id, () {
                                                        print("Done");
                                                        Navigator.pop(
                                                            context);
                                                        onDoneDialog(
                                                            context: context,
                                                            text:
                                                            "تم الحذف بنجاح",
                                                            function: () {
                                                              setState(() {
                                                                data.gallery.removeAt(index);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                      });
                                                    },
                                                    text: "نعم ",
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        2.7,
                                                  ),
                                                  CustomButton(
                                                    onBtnPress: () {
                                                      Navigator.pop(context);
                                                    },
                                                    text: "لا",
                                                    color: Colors.white,
                                                    borderColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    textColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        2.7,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 130, right: 20, left: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(),
                                          Card(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    50)),
                                            child: Container(
                                              child: Center(
                                                child: Icon(Icons.delete),
                                              ),
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );


                          },
                        ),
                      );
                    }
                  } else if (state is ErrorLoading) {
                    return Container();
                  } else {
                    return Center(
                      child: SpinKitFadingCircle(color: Theme.of(context).primaryColor),
                    );
                  }
                },
              )


             /* BlocBuilder(
                bloc: getImagesBloc,
                builder: (context, state) {
                  var data = state.model as GallaryResponse;
                  print(" data.gallery : ${ data.gallery}");
                  return data == null
                      ? AppLoader()
                      :   AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data.gallery.length,
                            itemBuilder: (context, index) {

                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: Stack(
                                    children: [
                                      Card(
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(data
                                                      .gallery[index].photo))),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          CustomSheet(
                                              context: context,
                                              hight: MediaQuery.of(context).size.height / 3,
                                              widget: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 20),
                                                    child: Text(
                                                      "هل انت متأكد من حذف الصورة",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      CustomButton(
                                                        onBtnPress: () {
                                                          Navigator.pop(context);
                                                          print(
                                                              "Deleting Image ======> ${data.gallery[index].id}");
                                                          deleteImage(
                                                              data.gallery[index]
                                                                  .id, () {
                                                            print("Done");
                                                            Navigator.pop(
                                                                context);
                                                            onDoneDialog(
                                                                context: context,
                                                                text:
                                                                "تم الحذف بنجاح",
                                                                function: () {
                                                                  setState(() {
                                                                    data.gallery
                                                                        .removeAt(
                                                                        index);
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                          });
                                                        },
                                                        text: "نعم ",
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                            2.7,
                                                      ),
                                                      CustomButton(
                                                        onBtnPress: () {
                                                          Navigator.pop(context);
                                                        },
                                                        text: "لا",
                                                        color: Colors.white,
                                                        borderColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                        textColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                        width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                            2.7,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 130, right: 20, left: 20),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(),
                                              Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        50)),
                                                child: Container(
                                                  child: Center(
                                                    child: Icon(Icons.delete),
                                                  ),
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );


                            },
                          ),
                        );
                },
              ),*/
            ),
          ],
        ),
      ),
    );
  }
}
