import 'package:get/get.dart' ;
import 'package:shop_passport/core/services/theme_service.dart';

class ThemeBuinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThemeService());
  }

}