import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../checkout/models/address_model.dart';
import '../services/address_api_service.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressModel address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final AddressApiService service = AddressApiService();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController divisionController;
  late final TextEditingController cityController;
  late final TextEditingController areaController;
  late final TextEditingController addressLineController;
  late final TextEditingController postalCodeController;

  late String type;
  late bool isDefault;

  bool isLoading = false;
  bool isDetailsLoading = true;

  AddressModel? addressDetails;

  Future<void> fetchDetails() async {
    try {
      final result = await service.getAddressDetails(widget.address.id);

      if (!mounted) return;

      setState(() {
        addressDetails = result;
      });
    } catch (_) {
      // Keep screen usable with passed address if demo details fails.
    } finally {
      if (mounted) {
        setState(() {
          isDetailsLoading = false;
        });
      }
    }
  }

  Future<void> updateAddress() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final updatedLocalAddress = widget.address.copyWith(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        division: divisionController.text.trim(),
        city: cityController.text.trim(),
        area: areaController.text.trim(),
        addressLine: addressLineController.text.trim(),
        postalCode: postalCodeController.text.trim(),
        type: type,
        isDefault: isDefault,
      );

      final response = await service.updateAddressDemo(
        address: updatedLocalAddress,
      );

      final updatedAddress = service.parseAddress(response);

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Address updated successfully',
        type: ToastType.success,
      );

      Navigator.pop(context, updatedAddress ?? updatedLocalAddress);
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    nameController = TextEditingController(text: address.name);
    phoneController = TextEditingController(text: address.phone);
    divisionController = TextEditingController(text: address.division);
    cityController = TextEditingController(text: address.city);
    areaController = TextEditingController(text: address.area);
    addressLineController = TextEditingController(text: address.addressLine);
    postalCodeController = TextEditingController(text: address.postalCode);

    type = address.type;
    isDefault = address.isDefault;

    fetchDetails();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    divisionController.dispose();
    cityController.dispose();
    areaController.dispose();
    addressLineController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }

          return null;
        },
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = addressDetails;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Address')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (isDetailsLoading) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 14),
            ],
            if (details != null) ...[
              Text(
                'Editing: ${details.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
            ],
            _field(label: 'Name', controller: nameController),
            _field(
              label: 'Phone',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            _field(label: 'Division', controller: divisionController),
            _field(label: 'City', controller: cityController),
            _field(label: 'Area', controller: areaController),
            _field(label: 'Address Line', controller: addressLineController),
            _field(label: 'Postal Code', controller: postalCodeController),
            DropdownButtonFormField<String>(
              initialValue: type,
              decoration: const InputDecoration(labelText: 'Address Type'),
              items: const [
                DropdownMenuItem(value: 'home', child: Text('Home')),
                DropdownMenuItem(value: 'office', child: Text('Office')),
              ],
              onChanged: (value) {
                setState(() {
                  type = value ?? 'home';
                });
              },
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              value: isDefault,
              title: const Text('Set as default address'),
              onChanged: (value) {
                setState(() {
                  isDefault = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : updateAddress,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Update Address'),
            ),
          ],
        ),
      ),
    );
  }
}
