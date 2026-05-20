import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../checkout/models/address_model.dart';

class AddressApiService {
  final ApiClient _apiClient;

  AddressApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiClient.get(ApiConstants.addresses);
    final data = _extractData(response);

    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => AddressModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    if (data is Map && data['addresses'] is List) {
      return (data['addresses'] as List)
          .whereType<Map>()
          .map((item) => AddressModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return [];
  }

  Future<AddressModel?> getAddressDetails(int addressId) async {
    final response = await _apiClient.get(
      ApiConstants.addressDetails(addressId),
    );
    return parseAddress(response);
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
    final data = _extractData(response);

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final nestedAddress = map['address'];

      if (nestedAddress is Map) {
        return AddressModel.fromJson(Map<String, dynamic>.from(nestedAddress));
      }

      return AddressModel.fromJson(map);
    }

    return null;
  }

  int? parseDeletedAddressId(Map<String, dynamic> response) {
    final data = _extractData(response);
    if (data is Map) {
      return _asInt(
        data['deleted_address_id'] ?? data['id'] ?? data['address_id'],
      );
    }
    return _asInt(response['deleted_address_id'] ?? response['id']);
  }

  int? parseDefaultAddressId(Map<String, dynamic> response) {
    final data = _extractData(response);
    if (data is Map) {
      return _asInt(
        data['default_address_id'] ?? data['id'] ?? data['address_id'],
      );
    }
    return _asInt(response['default_address_id'] ?? response['id']);
  }

  dynamic _extractData(Map<String, dynamic> response) {
    return response['data'] ??
        response['result'] ??
        response['address'] ??
        response;
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
