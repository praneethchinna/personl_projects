import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dioProvider = Provider<Dio>((ref) {
  final logger = PrettyDioLogger(
    enabled: kDebugMode,
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    error: true,
    compact: true,
    maxWidth: 90,
    logPrint: (s) => log(s.toString()),
    filter: (options, args) {
      return !args.isResponse || !args.hasUint8ListData;
    },
  );

  return Dio(BaseOptions(
    baseUrl: 'http://3.82.180.105:8000/api',
    connectTimeout: const Duration(seconds: 20), // Connection timeout
    receiveTimeout: const Duration(seconds: 20), // Response timeout
    headers: {'Content-Type': 'application/json'}, // Default headers
  ))
    ..interceptors.addAll([logger]);
});
