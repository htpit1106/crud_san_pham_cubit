import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:login_demo/core/constants/key_constants.dart';

abstract class Failure extends Equatable {
  final String message;

  // You could add more properties like statusCode, stackTrace etc.

  const Failure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message; // Simple representation
}

class ServerFailure extends Failure {
  const ServerFailure({String message = 'An API error occurred'})
    : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Could not connect to the network'})
    : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Could not access local cache'})
    : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'The requested item was not found'})
    : super(message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({String message = 'An unexpected error occurred'})
    : super(message);
}

class ApiFailure extends Failure {
  const ApiFailure({String message = 'An unexpected error occurred'})
    : super(message);
}

Failure mapExceptionToFailure(dynamic e) {
  // Add more specific exception handling (e.g., for DioError, SocketException)
  if (e is FormatException) {
    return ServerFailure(message: "bad response format");
  }

  if (e is SocketException) {
    return ServerFailure(message: "Connection timed out");
  }

  if (e is DioException) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkFailure(message: "Connection timed out");
    }

    dynamic messageKey = e.response?.data['error_key'];
    dynamic message = e.response?.data['message'];
    if (messageKey is List &&
        messageKey.isNotEmpty &&
        messageKey.first is String) {
      return mapMessageKeyFailure(messageKey.first, message);
    } else if (messageKey is String) {
      return mapMessageKeyFailure(messageKey, message);
    }
  }
  return UnexpectedFailure(message: "An unexpected error occurred");

  // Add more checks based on the exceptions your ApiClient might throw
  // For example, if ApiClient throws specific exceptions for status codes:
  // if (e is NotFoundException) return const NotFoundFailure();
  // if (e is NetworkException) return const NetworkFailure();
}

Failure mapMessageKeyFailure(String? messageKey, String? message) {
  if (messageKey == null) return const UnexpectedFailure();
  switch (messageKey) {
    case KeyConstants.errInvalidAccessToken:
      return ApiFailure(
        message:
            message ?? "Your access token has expired. Please log in again.",
      );
    case KeyConstants.errorInvalidLoginInfo:
      return ApiFailure(
        message:
            message ??
            "Invalid username or password. Please check your credentials and try again.",
      );

    default:
      return UnexpectedFailure(message: "An unexpected error occurred");
  }
}
