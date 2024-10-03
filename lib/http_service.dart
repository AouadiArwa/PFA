import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/predict-sales/';

  Future<List<dynamic>> fetchSalesPrediction() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load predictions: ${response.body} ${response.statusCode} ');

      }
    } catch (e) {
      print('Error: $e ');
      throw Exception('Failed to load predictions: $e ');
    }
  }
}
