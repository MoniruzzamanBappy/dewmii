import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../checkout/models/address_model.dart';
import '../services/address_api_service.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final AddressApiService service = AddressApiService();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: 'Rahim Uddin');
  final phoneController = TextEditingController(text: '+8801712345678');
  final divisionController = TextEditingController(text: 'Dhaka');
  final cityController = TextEditingController(text: 'Dhaka');
  final areaController = TextEditingController(text: 'Dhanmondi');
  final addressLineController = TextEditingController(
    text: 'House 22, Road 7, Dhanmondi',
  );
  final postalCodeController = TextEditingController(text: '1209');

  String type = 'home';
  bool isDefault = false;
  bool isLoading = false;

  Future<void> saveAddress() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final address = AddressModel(
        id: 0,
        userId: 1,
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

      final response = await service.addAddressDemo(address: address);

      final addedAddress = service.parseAddress(response);

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Address added successfully',
        type: ToastType.success,
      );

      Navigator.pop(context, addedAddress ?? address);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Add Address')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
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
              onPressed: isLoading ? null : saveAddress,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}
