import 'package:BeauT_Stylist/Base/NetworkUtil.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/models/current_ordera_model.dart';
import 'package:BeauT_Stylist/models/general_response.dart';
import 'package:BeauT_Stylist/models/home_page_response.dart';
import 'package:BeauT_Stylist/models/order_status_model.dart';
import 'package:dio/dio.dart';
import 'package:BeauT_Stylist/Base/AllTranslation.dart';
class UserJourny {
//------------------------------------------------------------------------------/
  static Future<CurrentOrdersResponse> GETCURRENTORDERS() async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    Map<String, String> headers = {
      'Authorization': token,
    };
    return NetworkUtil.internal().get(CurrentOrdersResponse(),
        "beautician/orders/get-new-orders?lang=${allTranslations.currentLanguage}",
        headers: headers);
  }

  static Future<CurrentOrdersResponse> GETDONEORDERS() async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
    await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    Map<String, String> headers = {
      'Authorization': token,
      'lang':allTranslations.currentLanguage
    };

    return NetworkUtil.internal().get(
        CurrentOrdersResponse(), "beautician/orders/get-pervious-orders?lang=${allTranslations.currentLanguage}",
        headers: headers);
  }



//------------------------------------------------------------------------------/
  static Future<OrderStatusModel> CanselOrder(int id, int status,String reason) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
        await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    print("order_id : ${id}");
    print("order_status : ${status}");
    FormData data = FormData.fromMap({
      "order_id": id,
      "order_status": status,
      "cancel_reason": status == 2 ? reason : null
    });
    Map<String, String> headers = {
      'Authorization': token,
    };
    return NetworkUtil.internal().post(
        OrderStatusModel(), "beautician/orders/change-status",
        headers: headers, body: data);
  }


//------------------------------------------------------------------------------/
//   static Future<HomePageResponse> GetHomePageData() async {
//
//     print("Lang ==== >${allTranslations.currentLanguage}");
//     var mSharedPreferenceManager = SharedPreferenceManager();
//     var token =
//     await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
//     print(token);
//     Map<String, String> headers = {
//       'Authorization': token,
//     };
//
//     return NetworkUtil.internal().post(HomePageResponse(),
//         "beautician//beautician-revenue?lang=${allTranslations.currentLanguage}",
//         headers: headers);
//   }

}
