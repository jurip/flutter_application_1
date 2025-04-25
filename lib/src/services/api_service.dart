import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class ApiService {
  static const String _baseUrl = 'https://ru.api.dev.photograf.io/v1/jobEvaluation/images';

  Future<ApiResponse> fetchImages({String? continuationToken}) async {
    if(continuationToken != null) {
      continuationToken = Uri.encodeComponent(continuationToken);
    }
    final uri = continuationToken != null 
    
        ? Uri.parse('$_baseUrl?continuationToken=$continuationToken') 
        : Uri.parse(_baseUrl);
        
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load images');
    }
  }
}