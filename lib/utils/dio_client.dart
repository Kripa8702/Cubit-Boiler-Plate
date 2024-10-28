import 'package:cubit_boiler_plate/config/flavour_config.dart';
import 'package:cubit_boiler_plate/constants/shared_pref_constants.dart';
import 'package:cubit_boiler_plate/exceptions/api_exception.dart';
import 'package:cubit_boiler_plate/models/common_response.dart';
import 'package:cubit_boiler_plate/utils/colored_logs.dart';
import 'package:cubit_boiler_plate/utils/pref_utils.dart';
import 'package:dio/dio.dart';

class DioClient {
  Dio _dio = Dio();

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: FlavorConfig.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 5000),
      validateStatus: (int? status) {
        return status != null;
      },
    ));

    _dio.options.headers = headers;
  }


  Map<String, String> get headers {
    final accessToken = PrefUtils().getString(SharedPrefConstants.accessToken);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? extraHeaders,
    String? customInvalidDataMessage,
  }) async {
    try {
      ColoredLogs.debug(
          "<----- Request: $endpoint \n Body: $queryParameters \n Headers: ${headers..addAll(extraHeaders ?? {})}");

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headers..addAll(extraHeaders ?? {}),
        ),
      );

      ColoredLogs.debug("\n-----> Status Code: ${response.statusCode}");
      ColoredLogs.debug("-----> Response ${response.data}");

      if (response.statusCode == 200) {
        final res = CommonResponse.fromJson(response.data);
        if (!res.success) {
          throw ApiException(res.message, status: response.statusCode);
        }
        return res.data;
      } else if (response.statusCode == 500) {
        throw ApiException("Internal Server Error",
            status: response.statusCode);
      } else {
        throw ApiException(response.data["message"],
            status: response.statusCode);
      }
    } on ApiException catch (e) {
      ColoredLogs.error(e.message);
      throw ApiException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? extraHeaders,
    String? customInvalidDataMessage,
    String? customNotFoundMessage,
  }) async {
    try {
      ColoredLogs.debug(
          "<----- Request: $endpoint \n Body: $data \n Headers:  ${headers..addAll(extraHeaders ?? {})}");

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: headers..addAll(extraHeaders ?? {}),
        ),
      );

      ColoredLogs.debug("\n-----> Status Code: ${response.statusCode}");
      ColoredLogs.debug("-----> Response ${response.data}");

      if (response.statusCode == 200) {
        /// Common Response is the based on the accepted response format from the server side. It is changed here to accommodate dummy API response
        /// Comment the below lines to use this response format
        // final res = CommonResponse.fromJson(response.data);
        // if (!res.success) {
        //   throw ApiException(res.message, status: response.statusCode);
        // }
        // return res.data;

        /// And remove the below line
        return response.data;
      } else if (response.statusCode == 500) {
        throw ApiException("Internal Server Error",
            status: response.statusCode);
      } else {
        throw ApiException(response.data["message"],
            status: response.statusCode);
      }
    } on ApiException catch (e) {
      ColoredLogs.error(e.message);
      throw ApiException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      ColoredLogs.debug("<----- Request: $endpoint \n Body: $data");

      final response = await _dio.put(endpoint, data: data);

      ColoredLogs.debug("\n-----> Status Code: ${response.statusCode}");
      ColoredLogs.debug("-----> Response ${response.data}");

      if (response.statusCode == 200) {
        final res = CommonResponse.fromJson(response.data);
        if (!res.success) {
          throw ApiException(res.message, status: response.statusCode);
        }
        return res.data;
      } else if (response.statusCode == 500) {
        throw ApiException("Internal Server Error",
            status: response.statusCode);
      } else {
        throw ApiException(response.data["message"],
            status: response.statusCode);
      }
    } on ApiException catch (e) {
      ColoredLogs.error(e.message);
      throw ApiException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      ColoredLogs.debug("<----- Request: $endpoint");

      final response = await _dio.delete(endpoint);

      ColoredLogs.debug("\n-----> Status Code: ${response.statusCode}");
      ColoredLogs.debug("-----> Response ${response.data}");

      if (response.statusCode == 200) {
        final res = CommonResponse.fromJson(response.data);
        if (!res.success) {
          throw ApiException(res.message, status: response.statusCode);
        }
        return res.data;
      } else if (response.statusCode == 500) {
        throw ApiException("Internal Server Error",
            status: response.statusCode);
      } else {
        throw ApiException(response.data["message"],
            status: response.statusCode);
      }
    } on ApiException catch (e) {
      ColoredLogs.error(e.message);
      throw ApiException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }
}
