import 'package:BeauT_Stylist/helpers/network-mappers.dart';

class WorkScheduleModel extends BaseMappable {
  bool status;
  String errNum;
  String msg;
  Schedule schedule;

  WorkScheduleModel({this.status, this.errNum, this.msg, this.schedule});

  WorkScheduleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    schedule = json['schedule'] != null
        ? new Schedule.fromJson(json['schedule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errNum'] = this.errNum;
    data['msg'] = this.msg;
    if (this.schedule != null) {
      data['schedule'] = this.schedule.toJson();
    }
    return data;
  }

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    schedule = json['schedule'] != null
        ? new Schedule.fromJson(json['schedule'])
        : null;
    return WorkScheduleModel(status: status,schedule: schedule,msg: msg,errNum: errNum);
  }
}

class Schedule {
  int id;
  String dayName;
  String dayDate;
  int beauticianId;
  String createdAt;
  Null deletedAt;
  List<Times> times;

  Schedule(
      {this.id,
        this.dayName,
        this.dayDate,
        this.beauticianId,
        this.createdAt,
        this.deletedAt,
        this.times});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayName = json['day_name'];
    dayDate = json['day_date'];
    beauticianId = json['beautician_id'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    if (json['times'] != null) {
      times = new List<Times>();
      json['times'].forEach((v) {
        times.add(new Times.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day_name'] = this.dayName;
    data['day_date'] = this.dayDate;
    data['beautician_id'] = this.beauticianId;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    if (this.times != null) {
      data['times'] = this.times.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Times {
  int id;
  String time;
  int status;
  int scheduleId;

  Times({this.id, this.time, this.status, this.scheduleId});

  Times.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    status = json['status'];
    scheduleId = json['schedule_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['status'] = this.status;
    data['schedule_id'] = this.scheduleId;
    return data;
  }
}