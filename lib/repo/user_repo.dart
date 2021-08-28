import 'dart:io';

import 'package:BeauT_Stylist/Base/NetworkUtil.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/models/NotificationResponse.dart';
import 'package:BeauT_Stylist/models/general_response.dart';
import 'package:BeauT_Stylist/models/login_model.dart';
import 'package:BeauT_Stylist/models/provider_payment_methods.dart';
import 'package:BeauT_Stylist/models/updateProfileResponse.dart';
import 'package:BeauT_Stylist/models/user_profile_response.dart';
import 'package:dio/dio.dart';
import 'package:BeauT_Stylist/Base/AllTranslation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserDataRepo {
  static Future<UserResponse> LOGIN(String email, String password) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    SharedPreferences preferences = await SharedPreferences.getInstance();
print("====== msgToken : ${ preferences.getString("msgToken")}");
    print(token);
    FormData data = FormData.fromMap({
      "email": email,
      "password": password,
      "deviceToken": preferences.getString("msgToken")==null?'device token' :preferences.getString("msgToken"),
    });
    return NetworkUtil.internal().post(
      UserResponse(),
      "beautician/auth/login",
      body: data,
    );
  }

//-------------------------------------------------------------------------------

  static Future<GeneralResponse> ForgetPassword(String email) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    FormData data = FormData.fromMap({
      "email": email,
    });
    return NetworkUtil.internal().post(
      GeneralResponse(),
      "beautician/auth/send-code",
      body: data,
    );
  }

//-------------------------------------------------------------------------------

  static Future<GeneralResponse> ResendCode(String email) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    FormData data = FormData.fromMap({
      "email": email,
    });
    return NetworkUtil.internal().post(
      GeneralResponse(),
      "beautician/auth/send-code",
      body: data,
    );
  }

//-------------------------------------------------------------------------------
  static Future<GeneralResponse> CheckCode(String code) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var email = await mSharedPreferenceManager.readString(CachingKey.EMAIL);
    print(email);
    FormData data = FormData.fromMap(
        {"email": email, "code": code, "lang": allTranslations.currentLanguage});
    return NetworkUtil.internal().post(
      GeneralResponse(),
      "beautician/auth/code-check",
      body: data,
    );
  }

//-------------------------------------------------------------------------------
  static Future<GeneralResponse> ActiveAccountFunction(String code) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var email = await mSharedPreferenceManager.readString(CachingKey.EMAIL);
    print(email);
    FormData data = FormData.fromMap(
        {"email": email, "code": code, "lang": allTranslations.currentLanguage});
    return NetworkUtil.internal().post(
      GeneralResponse(),
      "beautician/auth/code-check",
      body: data,
    );
  }

//-------------------------------------------------------------------------------
  static Future<GeneralResponse> RestePassword(
      String password, String confirmPassword) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var email = await mSharedPreferenceManager.readString(CachingKey.EMAIL);
    print(email);
    FormData data = FormData.fromMap({
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      "lang": allTranslations.currentLanguage
    });
    return NetworkUtil.internal().post(
      GeneralResponse(),
      "beautician/auth/reset-password",
      body: data,
    );
  }

//-------------------------------------------------------------------------------
  static Future<UpadteProfileResponse> UpdateProfileApi({
    String name,
    String email,
    String newPassword,
    String mobile,
    String currentPassword,
    String confirmPassword,
    int city_id,
    List<int> paymentMethdos,
    String beaut_name,
    File photo,
    String app_commission,
    int service_location
  }
      ) async {
    print("profile 1-2-1");

    var mSharedPreferenceManager = SharedPreferenceManager();
    var email = await mSharedPreferenceManager.readString(CachingKey.EMAIL);
    var token = await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);

    print("paymentMethdos : ${paymentMethdos}");

    print(token);
    Map<String, String> headers = {
      'Authorization': token,
    };

    FormData data = FormData.fromMap({
     "owner_name": name,
   "update_email": email,
    "mobile": mobile,
   "update_password": newPassword,
    "update_password_confirmation": confirmPassword,
      "current_password": currentPassword,
       "lang": allTranslations.currentLanguage,
      "city_id" : city_id,
       "payment_method" : paymentMethdos,
     "beaut_name" :beaut_name,
     "update_photo":  photo==null ? null : await MultipartFile.fromFile(photo.path),
      "service_location" : service_location,
      "app_commission" : app_commission
    });
    print("profile 1-2-3");

    return NetworkUtil.internal().post(
        UpadteProfileResponse(), "https://beauty.wothoq.co/api/beautician/profile/update",
        body: data, headers: headers);

  }

//-------------------------------------------------------------------------------
  static Future<UserProfileResoonse> GetProfileApi() async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    Map<String, String> headers = {
      'Authorization': token,
    };
    return NetworkUtil.internal()
        .post(UserProfileResoonse(), "beautician/user/get-user", headers: headers);
  }

//-------------------------------------------------------------------------------

  static Future<GeneralResponse> SIGNUP({
   String owner_name ,
    String beaut_name ,
    String email,
    String password ,
    String mobile ,
    String address ,
    double lat ,
    double lng ,
    List<File> photos ,
    List<int> payment ,
    int city_id ,
    String insta_link ,
    File photo
  }) async {
    List<MultipartFile> _photos = [];

    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(token);
    FormData data = FormData.fromMap({
      "owner_name": owner_name,
      "email": email,
      "password": password,
      "mobile": mobile,
      "address": address,
      "longitude": lng ?? 31.245175,
      "latitude": lat ?? 41.245175,
      "payment_method": payment,
      "beaut_name": beaut_name,
      "lang": allTranslations.currentLanguage,
      "city_id": city_id,
      "insta_link": insta_link,
      "photo": await MultipartFile.fromFile(photo.path),
      "deviceToken": preferences.getString("msgToken")==null?'device token' :preferences.getString("msgToken"),

    });
    for (int i = 0; i < photos.length; i++) {
      _photos.add(MultipartFile.fromFileSync(photos[i].path,
          filename: "${photos[i].path}.jpg"));
      data.files.add(MapEntry("photos[${i}]", _photos[i]));
      return NetworkUtil.internal().post(
        GeneralResponse(),
        "beautician/auth/signup",
        body: data,
      );
    }
  }

//-------------------------------------------------------------------------------
  static Future<NotificationResponse> GetNotifications() async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token = await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    Map<String, String> headers = {
      'Authorization': token,
    };
    return NetworkUtil.internal().get(NotificationResponse(),
        "beautician/notifications/get-beautician-notifications?lang=${allTranslations.currentLanguage}",
        headers: headers);
  }

  //-------------------------------------------------------------------------------

  static Future<GeneralResponse> ClearNotifications(int id) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    Map<String, String> headers = {
      'Authorization': token,
    };
    FormData data = FormData.fromMap({
      "notification_id": id,
    });
    return NetworkUtil.internal().post(GeneralResponse(), "beautician/notifications/delete",
        headers: headers, body: data);
  }

  static Future<ProviderPaymentMethodResponse> getPaymentMethods() async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token = await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    Map<String, String> headers = {
      'Authorization': token,
    };
    return NetworkUtil.internal().get(ProviderPaymentMethodResponse(),
        "methods/get-all-methods?lang=${allTranslations.currentLanguage}",
        headers: headers);
  }



}
