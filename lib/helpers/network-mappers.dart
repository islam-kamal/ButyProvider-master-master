import 'dart:convert';

// Handler for the network's request.
abstract class RequestMappable {
  Map<String, dynamic> toJson();
}

abstract class Mappable<T> {
  factory Mappable(Mappable type, String data) {
    print("** 5**");

    if (type is BaseMappable) {
      print("** 6**");

      Map<String, dynamic> mappingData = json.decode(data);
      print("** 7**");
      print("** mappingData ** :${mappingData}");
      print("**** type ** ${type.fromJson(mappingData)}");
      return type.fromJson(mappingData);
    } else if (type is ListMappable) {
      print("** 8**");

      Iterable iterableData = json.decode(data);
      return type.fromJsonList(iterableData);
    }
    print("I Couldn't Parser");
    return null;
  }
}

abstract class BaseMappable<T> implements Mappable {
  Mappable fromJson(Map<String, dynamic> json);
}

abstract class ListMappable<T> implements Mappable {
  Mappable fromJsonList(List<dynamic> json);
}
