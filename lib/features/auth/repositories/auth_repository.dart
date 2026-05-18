import '../models/auth_response_model.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _authApiService;

  AuthRepository(this._authApiService);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) {
    return _authApiService.login(email: email, password: password);
  }

  Future<AuthResponseModel> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) {
    return _authApiService.register(
      username: username,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }

  Future<UserModel> getLoggedInUser({String? token}) {
    return _authApiService.getLoggedInUser(token: token);
  }

  Future<Map<String, dynamic>> logout({String? token}) {
    return _authApiService.logout(token: token);
  }

  Future<TokenModel> refreshToken({required String refreshToken}) {
    return _authApiService.refreshToken(refreshToken: refreshToken);
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) {
    return _authApiService.forgotPassword(email: email);
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _authApiService.verifyOtp(email: email, otp: otp);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String resetToken,
    required String password,
  }) {
    return _authApiService.resetPassword(
      email: email,
      resetToken: resetToken,
      password: password,
    );
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    String? token,
  }) {
    return _authApiService.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      token: token,
    );
  }
}
