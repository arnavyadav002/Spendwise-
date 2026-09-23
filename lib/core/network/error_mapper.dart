import 'package:dio/dio.dart';

import '../errors/bank_error.dart';

class ErrorMapper {
  static BankError map(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return const UnauthorizedError();
      }
      return NetworkError(error.message ?? 'A network error occurred');
    }
    return UnknownBankError(error.toString());
  }
}
