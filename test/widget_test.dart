import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

String generateSignature(String path, String verb, String token,
    String timestamp, String body, String secret) {
  String message =
      'path=$path&verb=$verb&token=$token&timestamp=$timestamp&body=$body';
  print(message);

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
  String path = '/v1/briva';
  String verb = 'POST';

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

    DateTime localTime = DateTime.now();
    DateTime utcTime = localTime.toUtc();
    String timestamp =
        DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'').format(utcTime);

    final data = jsonEncode({
      "institutionCode": "J104408",
      "brivaNo": "77777",
      "custCode": "1255",
      "nama": "John Doe",
      "amount": "20000",
      "keterangan": "",
      "expiredDate": "2023-02-29 09:57:26"
    });

    String token = 'Bearer$accessToken';
    String signature =
        generateSignature(path, verb, token, timestamp, data, consumerSecret);

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'BRI-Timestamp': timestamp,
      'BRI-Signature': signature,
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: data,
    );

    print('Generated signature: $signature');

    print(response.body);
  } else {
    throw Exception('Failed to obtain access token: ${resp.statusCode}');
  }
}
