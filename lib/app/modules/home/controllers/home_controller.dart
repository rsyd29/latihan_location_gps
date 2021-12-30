import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var latitude = 'Getting Latitude...'.obs;
  var longitude = 'Getting Longitude...'.obs;
  var address = 'Getting Address...'.obs;

  late StreamSubscription<Position> streamSubscription;

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude.value = 'Latitude: ${position.latitude}';
      longitude.value = 'Longitude: ${position.longitude}';
      getAddressFromLatLong(position);
    });
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    var administrativeArea = place.administrativeArea;
    var name = place.name;
    var isoCountryCode = place.isoCountryCode;
    var postalCode = place.postalCode;
    var street = place.street;
    var country = place.country;
    var locality = place.locality;
    var subAdministrativeArea = place.subAdministrativeArea;
    var subLocality = place.subLocality;
    var subThoroughfare = place.subThoroughfare;
    var thoroughfare = place.thoroughfare;

    address.value =
        '\nadministrativeArea: $administrativeArea\n\nname: $name\n\nisoCountryCode: $isoCountryCode\n\npostalCode: $postalCode\n\nstreet: $street\n\ncountry: $country\n\nlocality: $locality\n\nsubAdministrativeArea: $subAdministrativeArea\n\nsubLocality: $subLocality\n\nsubThoroughfare: $subThoroughfare\n\nthoroughfare: $thoroughfare';
  }
}
