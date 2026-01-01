import 'package:get/get.dart';
import '../controllers/intercity_parcel_controller.dart';

class IntercityParcelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntercityParcelController());
  }
}

