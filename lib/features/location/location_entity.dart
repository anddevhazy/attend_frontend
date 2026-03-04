import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String locationId;
  final String? name;

  const LocationEntity({required this.locationId, this.name});

  @override
  List<Object?> get props => [locationId, name];
}
