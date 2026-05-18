import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.get(ApiConstants.login);
    return AuthResponseModel.fromJson(response);
  }

  Future<AuthResponseModel> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final response = await _apiClient.get(ApiConstants.register);
    return AuthResponseModel.fromJson(response);
  }

  Future<UserModel> getLoggedInUser({String? token}) async {
    final response = await _apiClient.get(ApiConstants.me, token: token);

    return UserModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> logout({String? token}) async {
    return _apiClient.get(ApiConstants.logout, token: token);
  }

  Future<TokenModel> refreshToken({required String refreshToken}) async {
    final response = await _apiClient.get(ApiConstants.refreshToken);
    return TokenModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    return _apiClient.get(ApiConstants.forgotPassword);
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return _apiClient.get(ApiConstants.verifyOtp);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String resetToken,
    required String password,
  }) async {
    return _apiClient.get(ApiConstants.resetPassword);
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    String? token,
  }) async {
    return _apiClient.get(ApiConstants.changePassword, token: token);
  }
}
