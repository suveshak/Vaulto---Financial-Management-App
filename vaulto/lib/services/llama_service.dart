import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/ai_connection_provider.dart';

class LlamaService {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  Future<String> getChatResponse(
      String userMessage, AIConnectionProvider connectionProvider) async {
    int retryCount = 0;
    final baseUrl = connectionProvider.fullUrl;

    while (retryCount < _maxRetries) {
      try {
        final response = await http
            .post(
              Uri.parse('$baseUrl/chat/completions'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'model': 'llama-3.1-8b-lexi-uncensored-v2',
                'messages': [
                  {
                    'role': 'system',
                    'content':
                        'You are a helpful financial assistant. Provide clear, concise, and practical financial advice. Always consider the Indian context and use INR currency. Be friendly and professional.'
                  },
                  {'role': 'user', 'content': userMessage}
                ],
                'temperature': 0.7,
                'max_tokens': -1,
                'stream': false
              }),
            )
            .timeout(const Duration(seconds: 60));

        if (response.statusCode == 200) {
          connectionProvider.setConnectionStatus(true);
          final data = jsonDecode(response.body);
          if (data['choices'] != null &&
              data['choices'].isNotEmpty &&
              data['choices'][0]['message'] != null) {
            return data['choices'][0]['message']['content'];
          } else {
            throw Exception('Invalid response format from Llama API');
          }
        } else if (response.statusCode == 404) {
          throw Exception(
              'Llama API endpoint not found. Please ensure the server is running at $baseUrl');
        } else if (response.statusCode == 503) {
          throw Exception('Llama API service is temporarily unavailable');
        } else {
          throw Exception(
              'Failed to get response from Llama API. Status code: ${response.statusCode}');
        }
      } on http.ClientException catch (e) {
        connectionProvider.setConnectionStatus(false);
        if (retryCount < _maxRetries - 1) {
          retryCount++;
          await Future.delayed(_retryDelay);
          continue;
        }
        throw Exception(
            'Connection error: ${e.message}. Please check if the Llama server is running at $baseUrl');
      } on FormatException catch (e) {
        throw Exception('Invalid response format: ${e.message}');
      } on Exception catch (e) {
        if (retryCount < _maxRetries - 1) {
          retryCount++;
          await Future.delayed(_retryDelay);
          continue;
        }
        rethrow;
      }
    }

    throw Exception(
        'Failed to connect to Llama API after $_maxRetries attempts');
  }
}
