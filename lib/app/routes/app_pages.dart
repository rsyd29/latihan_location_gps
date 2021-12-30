import 'package:get/get.dart';

import 'package:latihan_location_gps/app/modules/home/bindings/home_binding.dart';
import 'package:latihan_location_gps/app/modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
