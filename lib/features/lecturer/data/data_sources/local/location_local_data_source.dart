import 'package:attend/features/location/location_entity.dart';

class Locations {
  static const List<LocationEntity> locations = [
    LocationEntity(locationId: "69afbf98d957effbf4125c0a", name: "Anenih"),
    LocationEntity(
      locationId: "69afbfadd957effbf4125c0c",
      name: "Engineering Auditorium",
    ),
  ];
}

class LocationLocalDataSource {
  Future<List<LocationEntity>> getLocations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Locations.locations;
  }
}
