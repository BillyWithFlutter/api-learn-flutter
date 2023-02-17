import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

// Function to generate the BRI-Signature header value
String generateSignature(String method, String url, String timestamp,
    String payload, String secret) {
  // Concatenate the request components as follows:
  // [HTTP method]\n[URL]\n[BRI-Timestamp header value]\n[request payload]
  String message = '$method\n$url\n$timestamp\n$payload';

  // Generate a HMAC-SHA256 hash of the message using the consumer secret as the key
  var key = utf8.encode(secret);
  var bytes = utf8.encode(message);
  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(bytes);

  // Encode the resulting hash as Base64
  String signature = base64.encode(digest.bytes);

  return signature;
}

void main() async {
  const String consumerKey = 'Hcv9yMY5e8B3LAg54iT9DG0JtACroeXD';
  const String consumerSecret = 'GP93XAUaymaAxlHE';
  const String tokenUrl =
      'https://sandbox.partner.api.bri.co.id/oauth/client_credential/accesstoken?grant_type=client_credentials';
  const String baseUrl = 'https://sandbox.partner.api.bri.co.id/v1/briva';

  final resp = await http.post(
    Uri.parse(tokenUrl),
    headers: {
      'Authorization':
          'Basic ${base64.encode(utf8.encode('$consumerKey:$consumerSecret'))}',
    },
  );

  if (resp.statusCode == 200) {
    final body = json.decode(resp.body);
    final accessToken = body['access_token'];
    var time = DateTime.now().toIso8601String();

    final headers = {
      'content-type': 'application/json',
      'BRI-Timestamp': time,
      'BRI-Signature': 'GP93XAUaymaAxlHE',
      'Authorization': 'Bearer $accessToken',
    };

    final data = jsonEncode({
      "institutionCode": "J104408",
      "brivaNo": "77777",
      "custCode": "1255",
      "nama": "John Doe",
      "amount": "20000",
      "keterangan": "",
      "expiredDate": "2023-10-29 09:57:26"
    });

    String signature = generateSignature(
        'POST',
        'https://sandbox.partner.api.bri.co.id/v1/briva',
        time,
        data,
        consumerSecret);
    headers['BRI-Signature'] = signature;

    final response = await http.post(
      Uri.parse('$baseUrl/briva'),
      headers: headers,
      body: data,
    );

    print(response.body);
  } else {
    throw Exception('Failed to obtain access token: ${resp.statusCode}');
  }
}
