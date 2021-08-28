import 'package:BeauT_Stylist/Base/NetworkUtil.dart';
import 'package:BeauT_Stylist/UI/Schedule/schedule_data_model.dart';
import 'package:BeauT_Stylist/UI/Schedule/work_schedule_model.dart';
import 'package:BeauT_Stylist/helpers/shared_preference_manger.dart';
import 'package:BeauT_Stylist/models/general_response.dart';
import 'package:dio/dio.dart';

class ScheduleRepo{

  static Future<WorkScheduleModel> upload_schedule({List<String> day_date, List schedule_data}) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token =
    await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print(token);
    FormData data = FormData.fromMap({
      "day_date": day_date,
      "data": schedule_data,
    });
    Map<String, String> headers = {
      'Authorization': token,
    };
    return NetworkUtil.internal().post(
        WorkScheduleModel(), "beautician/work-schedule/store",
        headers: headers, body: data);
  }

  static Future<ScheduleDataModel> getAllDayTimes({String date}) async {
    var mSharedPreferenceManager = SharedPreferenceManager();
    var token = await mSharedPreferenceManager.readString(CachingKey.AUTH_TOKEN);
    print("---------token----- ${token}");
    print("-------- date ------- ${date}");
    Map<String, String> headers = {
      'Authorization': token,
      'day_date': date
    };


    return NetworkUtil.internal().get(ScheduleDataModel(),
        "beautician/work-schedule/beautician_schedule",
        headers: headers);


  }
}