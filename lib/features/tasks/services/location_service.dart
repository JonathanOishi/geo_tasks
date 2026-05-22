import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
        'Localização desabilitada. Por favor, habilite a localização para usar este recurso.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
          'Permissões de localização negadas. Por favor, permita o acesso à localização para usar este recurso.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Permissões de localização permanentemente negadas. Não podemos solicitar permissões.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
