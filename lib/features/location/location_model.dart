import 'package:attend/features/location/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({required super.locationId, required super.name});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(locationId: json['locationId'], name: json['name']);
  }
}
