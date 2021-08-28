
import 'package:BeauT_Stylist/Base/AllTranslation.dart';

class CitiesResponse {
  bool status;
  String errNum;
  String msg;
  List<Cities> cities;

  CitiesResponse({this.status, this.errNum, this.msg, this.cities});

  CitiesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    if (json['cities'] != null) {
      cities = new List<Cities>();
      json['cities'].forEach((v) {
        cities.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errNum'] = this.errNum;
    data['msg'] = this.msg;
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  int id;
  String nameEn;
  String countryEn;

  Cities({this.id, this.nameEn, this.countryEn});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn =allTranslations.currentLanguage =="ar"? json['name_ar'] :json['name_en'];
    countryEn =allTranslations.currentLanguage =="ar"? json['country_ar'] : json['country_en'];
    print("nameEn : $nameEn");
    print("name_ar : ${json['name_ar']}");
    print("name_en : ${json['name_en']}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_en'] = this.nameEn;
    data['country_en'] = this.countryEn;
    return data;
  }
}
