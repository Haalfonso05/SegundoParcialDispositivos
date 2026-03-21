import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../const/product_const.dart';
import '../model/product_model.dart';

class ProductService {
  ProductService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 20),
              ),
            );

  final Dio _dio;

  Future<List<ProductModel>> getProduct() async {
    try {
      final payload = await _requestPayload();
      final rawList = _extractList(payload);
      if (rawList is! List) {
        throw const FormatException('No se encontro la lista de animes.');
      }

      final result = <ProductModel>[];
      for (final rawItem in rawList) {
        if (rawItem is Map<String, dynamic>) {
          result.add(ProductModel.fromJson(rawItem));
        }
      }

      return result;
    } on DioException catch (e) {
      throw Exception('Error de conexion con el servidor: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Error de formato de datos: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al cargar series: $e');
    }
  }

  Future<List<ProductModel>> getProducts() {
    return getProduct();
  }

  Future<dynamic> _requestPayload() async {
    try {
      final response = await _dio.get<dynamic>(productConst);
      return _normalizePayload(response.data);
    } on DioException {
      if (!kIsWeb) rethrow;
    }

    final targetUrl = productConst;
    final alternatives = <String>[
      'https://corsproxy.io/?$targetUrl',
      'https://api.allorigins.win/raw?url=${Uri.encodeComponent(targetUrl)}',
    ];

    Exception? lastError;
    for (final url in alternatives) {
      try {
        final response = await _dio.get<dynamic>(url);
        return _normalizePayload(response.data);
      } on DioException catch (e) {
        lastError = Exception(e.message ?? 'Error de red al consumir la API.');
      } on FormatException catch (e) {
        lastError = Exception(e.message);
      }
    }

    throw lastError ?? Exception('No fue posible consultar el servicio remoto.');
  }

  dynamic _extractList(dynamic payload) {
    if (payload is List) {
      return payload;
    }

    if (payload is Map<String, dynamic>) {
      return payload['data'];
    }

    return null;
  }

  dynamic _normalizePayload(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is List || decoded is Map<String, dynamic>) {
        return decoded;
      }
    }

    throw const FormatException('La respuesta de la API no es valida.');
  }
}
