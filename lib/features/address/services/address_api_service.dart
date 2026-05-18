import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../checkout/models/address_model.dart';

class AddressApiService {
  final ApiClient _apiClient;

  AddressApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiClient.get(ApiConstants.addresses);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<AddressModel?> getAddressDetails(int addressId) async {
    final response = await _apiClient.get(
      ApiConstants.addressDetails(addressId),
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return AddressModel.fromJson(data);
  }

  Future<Map<String, dynamic>> addAddressDemo({
    required AddressModel address,
  }) async {
    return _apiClient.get(ApiConstants.addressAdd);
  }

  Future<Map<String, dynamic>> updateAddressDemo({
    required AddressModel address,
  }) async {
    return _apiClient.get(ApiConstants.addressUpdate);
  }

  Future<Map<String, dynamic>> deleteAddressDemo({
    required int addressId,
  }) async {
    return _apiClient.get(ApiConstants.addressDelete);
  }

  Future<Map<String, dynamic>> setDefaultAddressDemo({
    required int addressId,
  }) async {
    return _apiClient.get(ApiConstants.addressSetDefault);
  }

  AddressModel? parseAddress(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return AddressModel.fromJson(data);
  }

  int? parseDeletedAddressId(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return data['deleted_address_id'];
  }

  int? parseDefaultAddressId(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return data['default_address_id'];
  }
}
