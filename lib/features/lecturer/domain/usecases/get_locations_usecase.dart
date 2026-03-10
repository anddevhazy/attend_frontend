import 'package:attend/features/lecturer/data/data_sources/local/location_local_data_source.dart';
import 'package:attend/features/location/location_entity.dart';

class GetLocationsUsecase {
  final LocationLocalDataSource local;

  GetLocationsUsecase({required this.local});

  Future<List<LocationEntity>> call() async {
    return await local.getLocations();
  }
}
