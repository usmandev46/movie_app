import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../helpers/network_helper.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
  }

  Future<Map<String, dynamic>?> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        CancelToken? cancelToken,
      }) async {
    return _request(
      url,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
    );
  }


  Future<Map<String, dynamic>?> post(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        CancelToken? cancelToken,
      }) async {
    return _request(
      url,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>?> put(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        CancelToken? cancelToken,
      }) async {
    return _request(
      url,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>?> patch(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        CancelToken? cancelToken,
      }) async {
    return _request(
      url,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>?> delete(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        CancelToken? cancelToken,
      }) async {
    return _request(
      url,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>?> _request(
      String url, {
        required String method,
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        CancelToken? cancelToken,
      }) async {
    try {
      final hasInternet = await NetworkHelper.hasInternet();
      if (!hasInternet) {
        NetworkHelper.showError("No Internet connection", errorKey: "NO_INTERNET");
        return null;
      }

      if (kDebugMode) {
        print("------------- api url $url");
        print("------------- api data $data");
      }

      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(method: method, headers: headers),
      );

      if (kDebugMode) {
        print("------------- response data ${response.data}");
      }
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data is String) {
          return jsonDecode(response.data);
        }
        return response.data;
      }

      NetworkHelper.showError(
        "${response.statusCode} ${response.statusMessage}",
        errorKey: "HTTP_${response.statusCode}",
      );
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return null;

      String message = "Something went wrong";
      String errorKey = "GENERIC";

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = "Connection Timeout";
        errorKey = "TIMEOUT";
      } else if (e.type == DioExceptionType.badResponse) {
        switch (e.response?.statusCode) {
          case 400:
            message = "Invalid request. Please check your input.";
            errorKey = "400";
            break;
          case 403:
            message = "You don't have permission to perform this action.";
            errorKey = "403";
            break;
          case 404:
            message = "Requested resource not found.";
            errorKey = "404";
            break;
          case 500:
            message = "Server is currently unavailable. Try again later.";
            errorKey = "500";
            break;
          case 503:
            message = "Service temporarily unavailable. Please try later.";
            errorKey = "503";
            break;
        }
      } else if (e.type == DioExceptionType.unknown) {
        message = "No Internet Connection";
        errorKey = "NO_INTERNET";
      }

      if (e.response?.statusCode == 401 && e.response?.data != null) {
        return e.response?.data;
      }

      NetworkHelper.showError(message, errorKey: errorKey);
      return null;
    } catch (_) {
      NetworkHelper.showError("Unexpected error", errorKey: "UNEXPECTED",);
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadFile(
      String url, {
        required FormData formData,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      final hasInternet = await NetworkHelper.hasInternet();
      if (!hasInternet) {
        NetworkHelper.showError(
          "No Internet connection",
          errorKey: "NO_INTERNET",
        );
        return null;
      }

      final response = await _dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {
            ...?headers,
            'Content-Type': 'multipart/form-data',
          },
          // validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response.data;
      }

      switch (response.statusCode) {
        case 400:
          NetworkHelper.showError(
            "Invalid upload data",
            errorKey: "400",
          );
          break;

        case 403:
          NetworkHelper.showError(
            "You don't have permission to upload this file.",
            errorKey: "403",
          );
          break;
        case 404:
          NetworkHelper.showError(
            "Upload API not found.",
            errorKey: "404",
          );
          break;
        case 413:
          NetworkHelper.showError(
            "File size too large.",
            errorKey: "413",
          );
          break;
        default:
          NetworkHelper.showError(
            "Upload failed. Please try again.",
            errorKey: "UPLOAD_ERROR",
          );
      }

      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return null;
      }

      String message = "File upload failed";
      String errorKey = "UPLOAD_ERROR";

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        message = "Upload timeout. Please try again.";
        errorKey = "TIMEOUT";
      } else if (e.type == DioExceptionType.unknown) {
        message = "No Internet connection";
        errorKey = "NO_INTERNET";
      }

      NetworkHelper.showError(message, errorKey: errorKey);
      return null;
    } catch (_) {
      NetworkHelper.showError(
        "Unexpected error occurred",
        errorKey: "UNEXPECTED",
      );
      return null;
    }
  }


  Future<bool> downloadFile(
      String url,
      String savePath, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async
  {
    try {
      final hasInternet = await NetworkHelper.hasInternet();
      if (!hasInternet) {
        NetworkHelper.showError(
          "No Internet connection",
          errorKey: "NO_INTERNET",
        );
        return false;
      }

      await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
          followRedirects: false,
          // validateStatus: (status) => status != null && status < 500,
        ),
      );

      return true;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return false;
      }

      String message = "File download failed";
      String errorKey = "DOWNLOAD_ERROR";

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = "Download timeout. Please try again.";
        errorKey = "TIMEOUT";
      } else if (e.type == DioExceptionType.badResponse) {
        switch (e.response?.statusCode) {

          case 403:
            message = "You don't have permission to download this file.";
            errorKey = "403";
            break;
          case 404:
            message = "File not found.";
            errorKey = "404";
            break;
          case 500:
            message = "Server error. Please try later.";
            errorKey = "500";
            break;
          default:
            message = "Unexpected server response.";
            errorKey = "SERVER_ERROR";
        }
      } else if (e.type == DioExceptionType.unknown) {
        message = "No Internet connection";
        errorKey = "NO_INTERNET";
      }

      NetworkHelper.showError(message, errorKey: errorKey);
      return false;
    } catch (_) {
      NetworkHelper.showError(
        "Unexpected error occurred",
        errorKey: "UNEXPECTED",
      );
      return false;
    }
  }

}
