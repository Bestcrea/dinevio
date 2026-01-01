import 'package:customer/app/modules/chatbot/controllers/chatbot_controller.dart';
import 'package:get/get.dart';

class ChatbotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatbotController>(() => ChatbotController());
  }
}

