import 'package:customer/app/modules/personal_info/controllers/personal_info_controller.dart';
import 'package:get/get.dart';

class PersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
  }
}

