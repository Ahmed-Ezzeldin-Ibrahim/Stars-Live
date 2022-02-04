import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper{

  static String _location;
  static double _lat;
  static double _long;

  static getUserCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      ///Here you have choose level of distance
      print('posistion ${position}');
      _lat = position.latitude;
      _long = position.longitude;

      List newPlace = await await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark placeMark = newPlace[0];
      String compeletAddressInfor = '${placeMark.subThoroughfare} ${placeMark.thoroughfare}, ${placeMark.subLocality} ${placeMark.locality}, ${placeMark.subAdministrativeArea} ${placeMark.administrativeArea}, ${placeMark.postalCode} ${placeMark.country},';
      print('compeletAddressInfor' + compeletAddressInfor);
      String specificAddress = '${placeMark.subThoroughfare}${placeMark.thoroughfare}/${placeMark.locality}/${placeMark.country}';
      _location = placeMark.country;
    } catch (e) {
      print(e);
    }
  }

 static String get locationAddress => _location;
 static double get lat => _lat;
 static double get long => _long;
}