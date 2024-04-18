import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  final String? apiKey;

  QuoteService({this.apiKey});

  Future<String> fetchDailyQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.quotable.io/random'),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse['content'];
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      throw Exception('Error fetching quote: $e');
    }
  }
}
