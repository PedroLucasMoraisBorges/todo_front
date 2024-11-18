import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future<http.Response> get({required String url});
  Future<http.Response> delete({required String url});
  Future<http.Response> post(
      {required String url, required Map<String, dynamic> body});

  put({required String url, required Map<String, dynamic> body}) {}
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<http.Response> get({required String url}) async {
    return await client.get(Uri.parse(url));
  }

  @override
  Future<http.Response> delete({required String url}) async {
    return await client.delete(Uri.parse(url));
  }

  @override
  Future<http.Response> post(
      {required String url, required Map<String, dynamic> body}) async {
    return await client.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json"
      }, // Certificando-se de que o corpo seja interpretado como JSON
      body: jsonEncode(body), // Converte o corpo em JSON
    );
  }

  Future<http.Response> put(
      {required String url, required Map<String, dynamic> body}) async {
    return await client.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json"
      }, // Certificando-se de que o corpo seja interpretado como JSON
      body: jsonEncode(body), // Converte o corpo em JSON
    );
  }
}
