import 'package:cubit_boiler_plate/constants/api_path.dart';
import 'package:cubit_boiler_plate/constants/shared_pref_constants.dart';
import 'package:cubit_boiler_plate/features/auth/model/user.dart';
import 'package:cubit_boiler_plate/utils/dio_client.dart';
import 'package:cubit_boiler_plate/utils/pref_utils.dart';

class AuthRepository {
  AuthRepository({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;
  final PrefUtils _prefUtils = PrefUtils();

  Future<User?> getUser() async {
    try {
      final user = _prefUtils.getMapValue(SharedPrefConstants.userData);

      if (user.isEmpty) {
        return null;
      }

      return User.fromJson(user);
    } catch (e) {
      throw Exception('Could not fetch user details. Please try again.');
    }
  }

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiPath.login,
        data: {
          "username": email,
          "password": password,
        },
      );

      final user = User.fromJson(response);
      final accessToken = response['accessToken'];

      _prefUtils.setMapValue(
        key: SharedPrefConstants.userData,
        value: user.toJson(),
      );
      _prefUtils.setString(
        key: SharedPrefConstants.accessToken,
        value: accessToken,
      );

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      await _dioClient.post(
        ApiPath.register,
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "phone": phone,
          "password": password,
        },
      );

      return;
    } catch (e) {
      rethrow;
    }
  }
}
