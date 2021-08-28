import 'package:BeauT_Stylist/helpers/network-mappers.dart';


class UpadteProfileResponse extends BaseMappable{
  var status;
  var errNum;
  var msg;
  Beautician beautician;

  UpadteProfileResponse({this.status, this.errNum, this.msg, this.beautician});

  UpadteProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    beautician = json['beautician'] != null
        ? new Beautician.fromJson(json['beautician'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errNum'] = this.errNum;
    data['msg'] = this.msg;
    if (this.beautician != null) {
      data['beautician'] = this.beautician.toJson();
    }
    return data;
  }
  @override
  Mappable fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    print("beautician 1");

    beautician = json['beautician'] != null ? new Beautician.fromJson(json['beautician']) : null;
    print("beautician 11");

    return UpadteProfileResponse(
        status: status, msg: msg, errNum: errNum, beautician: beautician);
  }

}

class Beautician {
  var id;
  var ownerName;
  var beautName;
  var email;
  var mobile;
  var photo;
  var instaLink;
  var address;
  var longitude;
  var latitude;
  var appCommission;
  var status;
  var statusUpdatedAt;
  var cityId;
  var isActive;
  var visits;
  var isBlocked;
  var serviceLocation;
  var reviewsCount;
  List<PaymentMethods> paymentMethods;
  List<Rates> rates;

  Beautician(
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
        this.visits,
        this.isBlocked,
        this.serviceLocation,
        this.reviewsCount,
        this.paymentMethods,
        this.rates});

  Beautician.fromJson(Map<String, dynamic> json) {
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
    print("beautician 6-1 (${json['city_id']})");
    cityId = json['city_id'];
    print("beautician 6-2");
    isActive = json['is_active'];
    print("beautician 7");
    visits = json['visits'];
    isBlocked = json['is_blocked'];
    serviceLocation = json['service_location'];
    reviewsCount = json['reviews_count'];
    print("beautician 8");
    if (json['payment_methods'] != null) {
      paymentMethods = new List<PaymentMethods>();
      json['payment_methods'].forEach((v) {
        paymentMethods.add(new PaymentMethods.fromJson(v));
      });
    }
    print("beautician 9");
    if (json['rates'] != null) {
      rates = new List<Rates>();
      json['rates'].forEach((v) {
        rates.add(new Rates.fromJson(v));
      });
    }
    print("beautician 10");
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
    data['visits'] = this.visits;
    data['is_blocked'] = this.isBlocked;
    data['service_location'] = this.serviceLocation;
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
  var id;
  var nameAr;
  var nameEn;

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
  var id;
  var value;
  var comment;
  var orderNum;
  var beauticianId;
  var userId;
  var createdAt;

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