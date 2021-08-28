import 'package:BeauT_Stylist/helpers/network-mappers.dart';

class ScheduleDataModel extends BaseMappable{
  List<String> times;
  List<int> status;

  ScheduleDataModel({this.times, this.status});

  ScheduleDataModel.fromJson(Map<String, dynamic> json) {
    times = json['times'].cast<String>();
    status = json['status'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['times'] = this.times;
    data['status'] = this.status;
    return data;
  }

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    times = json['times'].cast<String>();
    status = json['status'].cast<int>();
    return ScheduleDataModel(status: status,times: times);
  }
}