import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for interacting with Google Gemini AI API
/// Adapted from Python SDK example to Dart/Flutter using REST API
class GeminiChatService {
  static const String _apiKey = 'AIzaSyD60cj1JBdpZ2C6iPb6x1-Hv-lAavzdtoE';
  // Using gemini-1.5-flash for better performance and cost efficiency
  // Can be changed to gemini-1.5-pro or gemini-3-pro-preview if available
  static const String _model = 'gemini-1.5-flash';
  
  /// Send a message to Gemini AI and get a response
  Future<String> sendMessage(String userMessage, {List<Map<String, String>>? conversationHistory}) async {
    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey');
      
      // Prepare conversation context
      final contents = <Map<String, dynamic>>[];
      
      // Add conversation history if provided
      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        for (var message in conversationHistory) {
          final role = message['role'] ?? 'user';
          // Gemini API expects 'user' or 'model' roles
          contents.add({
            'role': role == 'assistant' ? 'model' : 'user',
            'parts': [
              {'text': message['text'] ?? ''}
            ]
          });
        }
      }
      
      // Add current user message
      contents.add({
        'role': 'user',
        'parts': [
          {'text': userMessage}
        ]
      });
      
      // System instruction for Dinevio assistant
      final systemInstruction = {
        'parts': [
          {
            'text': '''You are Dinevio Assistant, a helpful customer support chatbot for Dinevio, a Moroccan super app offering:
- Food delivery from restaurants
- Grocery shopping from supermarkets and stores
- Parapharmacy products
- Ride-hailing services
- Parcel delivery services
- Intercity transportation

Your role is to:
- Help users with questions about Dinevio services
- Provide information about orders, deliveries, payments
- Assist with account issues, promotions, and support
- Answer in a friendly, professional, and concise manner
- Use MAD (Moroccan Dirham) as the currency
- Be available 24/7 to help customers

Keep responses helpful, accurate, and focused on Dinevio services.'''
          }
        ]
      };
      
      // Prepare request body
      final requestBody = {
        'contents': contents,
        'systemInstruction': systemInstruction,
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };
      
      // Make API request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Extract response text (similar to Python SDK's response.text)
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          
          // Check for finish reason (blocked, safety, etc.)
          final finishReason = candidate['finishReason'];
          if (finishReason != null && finishReason != 'STOP') {
            // Handle blocked responses gracefully
            if (finishReason == 'SAFETY') {
              return 'I apologize, but I cannot provide a response to that question due to safety guidelines. Please try rephrasing your question.';
            } else if (finishReason == 'MAX_TOKENS') {
              return 'The response was too long. Please try asking a more specific question.';
            } else {
              return 'Sorry, the response was blocked: $finishReason';
            }
          }
          
          // Extract text from parts
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            final text = candidate['content']['parts'][0]['text'];
            if (text != null && text.toString().isNotEmpty) {
              return text.toString();
            }
          }
        }
        
        // No valid response found
        return 'Sorry, I couldn\'t generate a response. Please try again.';
      } else {
        // Handle API errors with better error messages
        try {
          final errorData = jsonDecode(response.body);
          final error = errorData['error'];
          final errorMessage = error?['message'] ?? 
                              error?['status'] ?? 
                              'Unknown error occurred';
          final errorCode = error?['code'] ?? response.statusCode;
          
          // Provide user-friendly error messages
          if (errorCode == 400) {
            throw Exception('Invalid request. Please check your message and try again.');
          } else if (errorCode == 401) {
            throw Exception('Authentication failed. Please contact support.');
          } else if (errorCode == 429) {
            throw Exception('Too many requests. Please wait a moment and try again.');
          } else if (errorCode >= 500) {
            throw Exception('Service temporarily unavailable. Please try again later.');
          } else {
            throw Exception('Gemini API error ($errorCode): $errorMessage');
          }
        } catch (e) {
          // If error parsing fails, throw generic error
          if (e.toString().contains('Gemini API error') || 
              e.toString().contains('Invalid request') ||
              e.toString().contains('Authentication failed') ||
              e.toString().contains('Too many requests') ||
              e.toString().contains('Service temporarily unavailable')) {
            rethrow;
          }
          throw Exception('HTTP ${response.statusCode}: ${response.body}');
        }
      }
    } catch (e) {
      // Handle network or parsing errors
      if (e.toString().contains('Gemini API error') || 
          e.toString().contains('Invalid request') ||
          e.toString().contains('Authentication failed') ||
          e.toString().contains('Too many requests') ||
          e.toString().contains('Service temporarily unavailable') ||
          e.toString().contains('Response blocked')) {
        rethrow;
      }
      throw Exception('Failed to get response from Gemini: ${e.toString()}');
    }
  }
  
  /// Get initial greeting message
  String getInitialGreeting() {
    return 'Hello! I\'m your Dinevio assistant. How can I help you today?';
  }
}

