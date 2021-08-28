import 'package:BeauT_Stylist/helpers/network-mappers.dart';

class OrderStatusModel  extends BaseMappable{
  bool status;
  String errNum;
  String msg;
  Order order;

  OrderStatusModel({this.status, this.errNum, this.msg, this.order});

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errNum'] = this.errNum;
    data['msg'] = this.msg;
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    return data;
  }

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    return OrderStatusModel(status: status,msg: msg,errNum: errNum,order: order);
  }
}

class Order {
  int id;
  String date;
  String time;
  int cost;
  int orderNum;
  int appCommission;
  String paymentStatus;
  String orderStatus;
  String duration;
  int beauticianId;
  int userId;
  int paymentMethodId;
  Null cardId;
  String locationType;
  int locationId;
  String createdAt;
  UserLocation userLocation;
  User user;
  Beautician beautician;
  List<Services> services;
  PaymentMethods paymentMethod;

  Order(
      {this.id,
        this.date,
        this.time,
        this.cost,
        this.orderNum,
        this.appCommission,
        this.paymentStatus,
        this.orderStatus,
        this.duration,
        this.beauticianId,
        this.userId,
        this.paymentMethodId,
        this.cardId,
        this.locationType,
        this.locationId,
        this.createdAt,
        this.userLocation,
        this.user,
        this.beautician,
        this.services,
        this.paymentMethod});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    cost = json['cost'];
    orderNum = json['order_num'];
    appCommission = json['app_commission'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    duration = json['duration'];
    beauticianId = json['beautician_id'];
    userId = json['user_id'];
    paymentMethodId = json['payment_method_id'];
    cardId = json['card_id'];
    locationType = json['location_type'];
    locationId = json['location_id'];
    createdAt = json['created_at'];
    userLocation = json['user_location'] != null
        ? new UserLocation.fromJson(json['user_location'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    beautician = json['beautician'] != null
        ? new Beautician.fromJson(json['beautician'])
        : null;
    if (json['services'] != null) {
      services = new List<Services>();
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    paymentMethod = json['payment_method'] != null
        ? new PaymentMethods.fromJson(json['payment_method'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['cost'] = this.cost;
    data['order_num'] = this.orderNum;
    data['app_commission'] = this.appCommission;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['duration'] = this.duration;
    data['beautician_id'] = this.beauticianId;
    data['user_id'] = this.userId;
    data['payment_method_id'] = this.paymentMethodId;
    data['card_id'] = this.cardId;
    data['location_type'] = this.locationType;
    data['location_id'] = this.locationId;
    data['created_at'] = this.createdAt;
    if (this.userLocation != null) {
      data['user_location'] = this.userLocation.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.beautician != null) {
      data['beautician'] = this.beautician.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    if (this.paymentMethod != null) {
      data['payment_method'] = this.paymentMethod.toJson();
    }
    return data;
  }
}

class UserLocation {
  int id;
  String address;
  String longitude;
  String latitude;
  int userId;
  String createdAt;

  UserLocation(
      {this.id,
        this.address,
        this.longitude,
        this.latitude,
        this.userId,
        this.createdAt});

  UserLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    userId = json['user_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String mobile;
  int emailVerified;
  int block;
  Null createdAt;
  String updatedAt;

  User(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.emailVerified,
        this.block,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    emailVerified = json['email_verified'];
    block = json['block'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['email_verified'] = this.emailVerified;
    data['block'] = this.block;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Beautician {
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
  int serviceLocation;
  int reviewsCount;
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
    cityId = json['city_id'];
    isActive = json['is_active'];
    visits = json['visits'];
    isBlocked = json['is_blocked'];
    serviceLocation = json['service_location'];
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

class Services {
  String nameAr;
  String nameEn;
  String detailsEn;
  String detailsAr;
  String icon;
  int categoryId;
  String estimatedTime;
  String price;
  String bonus;
  String location;
  int serviceId;
  int personNum;

  Services(
      {this.nameAr,
        this.nameEn,
        this.detailsEn,
        this.detailsAr,
        this.icon,
        this.categoryId,
        this.estimatedTime,
        this.price,
        this.bonus,
        this.location,
        this.serviceId,
        this.personNum});

  Services.fromJson(Map<String, dynamic> json) {
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    detailsEn = json['details_en'];
    detailsAr = json['details_ar'];
    icon = json['icon'];
    categoryId = json['category_id'];
    estimatedTime = json['estimated_time'];
    price = json['price'];
    bonus = json['bonus'];
    location = json['location'];
    serviceId = json['service_id'];
    personNum = json['person_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name_ar'] = this.nameAr;
    data['name_en'] = this.nameEn;
    data['details_en'] = this.detailsEn;
    data['details_ar'] = this.detailsAr;
    data['icon'] = this.icon;
    data['category_id'] = this.categoryId;
    data['estimated_time'] = this.estimatedTime;
    data['price'] = this.price;
    data['bonus'] = this.bonus;
    data['location'] = this.location;
    data['service_id'] = this.serviceId;
    data['person_num'] = this.personNum;
    return data;
  }
}