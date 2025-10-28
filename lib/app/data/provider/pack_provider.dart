import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos/app/data/config/env.dart';
import 'package:pos/app/data/exceptions/api_exception.dart';
import 'package:pos/app/models/subscription.dart';

class PackProvider {
  final String baseUrl = Env.apiUrl;

  Map<String, String> headers() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<PackSubscribeResponse> consumeLicence(
    String licence,
  ) async {
    final url = Uri.parse("${baseUrl}consume");
    final response = await http.post(
      url,
      headers: headers(),
      body: jsonEncode({"licence": licence}),
    );
    print("dddddddddddddddddddddddddddddddddddddddddddd");
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PackSubscribeResponse.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
       throw ApiException(error['message'] ??
          'Erreur inconnue lors de la consommation de la licence');
    }
  }
}
