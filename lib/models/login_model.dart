import 'package:BeauT_Stylist/helpers/network-mappers.dart';
import 'package:intl/intl.dart';

/*
class UserResponse extends BaseMappable {
  bool status;
  String errNum;
  String msg;
  User user;

  UserResponse({this.status, this.errNum, this.msg, this.user});

  UserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errNum'] = this.errNum;
    data['msg'] = this.msg;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    return UserResponse(status: status, msg: msg, errNum: errNum, user: user);
  }
}

class User {
  int id;
  String ownerName;
  String beautName;
  String email;
  String mobile;
  String photo;
  String instaLink;
  String address;
  String longitude;
  String latitude;
  int appCommission;
  int status;
  String statusUpdatedAt;
  int cityId;
  int isActive;
  int isBlocked;
  String accessToken;

  User(
      {this.id,
      this.ownerName,
      this.beautName,
      this.email,
      this.mobile,
      this.photo,
      this.instaLink,
      this.address,
      this.longitude,
      this.latitude,
      this.appCommission,
      this.status,
      this.statusUpdatedAt,
      this.cityId,
      this.isActive,
      this.isBlocked,
      this.accessToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerName = json['owner_name'];
    beautName = json['beaut_name'];
    email = json['email'];
    mobile = json['mobile'];
    photo = json['photo'];
    instaLink = json['insta_link'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    appCommission = json['app_commission'];
    status = json['status'];
    statusUpdatedAt = json['status_updated_at'];
    cityId = json['city_id'];
    isActive = json['is_active'];
    isBlocked = json['is_blocked'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_name'] = this.ownerName;
    data['beaut_name'] = this.beautName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['photo'] = this.photo;
    data['insta_link'] = this.instaLink;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['app_commission'] = this.appCommission;
    data['status'] = this.status;
    data['status_updated_at'] = this.statusUpdatedAt;
    data['city_id'] = this.cityId;
    data['is_active'] = this.isActive;
    data['is_blocked'] = this.isBlocked;
    data['access_token'] = this.accessToken;
    return data;
  }
}
*/

class UserResponse extends BaseMappable{
  bool status;
  String errNum;
  String msg;
  User user;

  UserResponse({this.status, this.errNum, this.msg, this.user});

  UserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errNum'] = this.errNum;
    data['msg'] = this.msg;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    return UserResponse(status: status,errNum: errNum,msg: msg,user: user);
  }
}

class User {
  int id;
  String ownerName;
  String beautName;
  String email;
  String mobile;
  String photo;
  String instaLink;
  String address;
  String longitude;
  String latitude;
  int appCommission;
  int status;
  String statusUpdatedAt;
  int cityId;
  int isActive;
  int visits;
  int isBlocked;
  String accessToken;
  int reviewsCount;
  List<PaymentMethods> paymentMethods;
  List<Rates> rates;
  int serviceLocation;
  User(
      {this.id,
        this.ownerName,
        this.beautName,
        this.email,
        this.mobile,
        this.photo,
        this.instaLink,
        this.address,
        this.longitude,
        this.latitude,
        this.serviceLocation,
        this.appCommission,
        this.status,
        this.statusUpdatedAt,
        this.cityId,
        this.isActive,
        this.visits,
        this.isBlocked,
        this.accessToken,
        this.reviewsCount,
        this.paymentMethods,
        this.rates});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerName = json['owner_name'];
    beautName = json['beaut_name'];
    email = json['email'];
    mobile = json['mobile'];
    photo = json['photo'];
    instaLink = json['insta_link'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    appCommission = json['app_commission'];
    status = json['status'];
    statusUpdatedAt = json['status_updated_at'];
    cityId = json['city_id'];
    isActive = json['is_active'];
    visits = json['visits'];
    serviceLocation = json['service_location'];
    isBlocked = json['is_blocked'];
    accessToken = json['access_token'];
    reviewsCount = json['reviews_count'];
    if (json['payment_methods'] != null) {
      paymentMethods = new List<PaymentMethods>();
      json['payment_methods'].forEach((v) {
        paymentMethods.add(new PaymentMethods.fromJson(v));
      });
    }
    if (json['rates'] != null) {
      rates = new List<Rates>();
      json['rates'].forEach((v) {
        rates.add(new Rates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_name'] = this.ownerName;
    data['beaut_name'] = this.beautName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['photo'] = this.photo;
    data['insta_link'] = this.instaLink;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['app_commission'] = this.appCommission;
    data['status'] = this.status;
    data['status_updated_at'] = this.statusUpdatedAt;
    data['city_id'] = this.cityId;
    data['is_active'] = this.isActive;
    data['service_location'] = this.serviceLocation;
    data['visits'] = this.visits;
    data['is_blocked'] = this.isBlocked;
    data['access_token'] = this.accessToken;
    data['reviews_count'] = this.reviewsCount;
    if (this.paymentMethods != null) {
      data['payment_methods'] =
          this.paymentMethods.map((v) => v.toJson()).toList();
    }
    if (this.rates != null) {
      data['rates'] = this.rates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentMethods {
  int id;
  String nameAr;
  String nameEn;

  PaymentMethods({this.id, this.nameAr, this.nameEn});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_ar'] = this.nameAr;
    data['name_en'] = this.nameEn;
    return data;
  }
}

class Rates {
  int id;
  int value;
  String comment;
  int orderNum;
  int beauticianId;
  int userId;
  String createdAt;

  Rates(
      {this.id,
        this.value,
        this.comment,
        this.orderNum,
        this.beauticianId,
        this.userId,
        this.createdAt});

  Rates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    comment = json['comment'];
    orderNum = json['order_num'];
    beauticianId = json['beautician_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['comment'] = this.comment;
    data['order_num'] = this.orderNum;
    data['beautician_id'] = this.beauticianId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    return data;
  }
}