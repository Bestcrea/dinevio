import 'package:customer/services/gemini_chat_service.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotController extends GetxController {
  final GeminiChatService _chatService = GeminiChatService();
  
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Add initial greeting
    messages.add(ChatMessage(
      text: _chatService.getInitialGreeting(),
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  /// Send a message to the chatbot
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    try {
      // Add user message
      final userMessage = ChatMessage(
        text: text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      );
      messages.add(userMessage);
      
      // Show loading
      isLoading.value = true;
      errorMessage.value = '';
      
      // Prepare conversation history (last 10 messages for context)
      // Get messages before the current one, in chronological order
      final historyMessages = messages
          .take(messages.length - 1) // Exclude the message we just added
          .toList();
      
      // Take last 10 messages for context (if more than 10 exist)
      final recentMessages = historyMessages.length > 10
          ? historyMessages.sublist(historyMessages.length - 10)
          : historyMessages;
      
      final history = recentMessages.map((msg) => {
            'role': msg.isUser ? 'user' : 'model',
            'text': msg.text,
          }).toList();
      
      // Get response from Gemini
      final response = await _chatService.sendMessage(
        text.trim(),
        conversationHistory: history,
      );
      
      // Add bot response
      final botMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(botMessage);
    } catch (e) {
      errorMessage.value = e.toString();
      // Add error message to chat
      messages.add(ChatMessage(
        text: 'Sorry, I encountered an error. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear chat history
  void clearChat() {
    messages.clear();
    // Add initial greeting again
    messages.add(ChatMessage(
      text: _chatService.getInitialGreeting(),
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }
}

