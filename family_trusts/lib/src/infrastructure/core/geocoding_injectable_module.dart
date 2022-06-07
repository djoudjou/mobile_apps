import 'package:familytrusts/src/infrastructure/core/api_keys.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:injectable/injectable.dart';

@module
abstract class GeocodingInjectableModule {
  @lazySingleton
  GoogleGeocoding get googleGeocoding => GoogleGeocoding(ApiKeys.googleApiKey);
}
