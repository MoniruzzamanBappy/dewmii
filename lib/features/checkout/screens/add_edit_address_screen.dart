import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/address_model.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController divisionController;
  late final TextEditingController cityController;
  late final TextEditingController areaController;
  late final TextEditingController addressLineController;
  late final TextEditingController postalCodeController;

  String type = 'home';
  bool isDefault = false;

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    nameController = TextEditingController(
      text: address?.name ?? 'Rahim Uddin',
    );
    phoneController = TextEditingController(
      text: address?.phone ?? '+8801712345678',
    );
    divisionController = TextEditingController(
      text: address?.division ?? 'Dhaka',
    );
    cityController = TextEditingController(text: address?.city ?? 'Dhaka');
    areaController = TextEditingController(text: address?.area ?? 'Mirpur');
    addressLineController = TextEditingController(
      text: address?.addressLine ?? 'House 10, Road 5, Mirpur 10',
    );
    postalCodeController = TextEditingController(
      text: address?.postalCode ?? '1216',
    );

    type = address?.type ?? 'home';
    isDefault = address?.isDefault ?? false;
  }

  void saveAddress() {
    if (!formKey.currentState!.validate()) return;

    final address = AddressModel(
      id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch,
      userId: widget.address?.userId ?? 1,
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

    AppToast.show(
      context,
      message: widget.address == null
          ? 'Address added successfully'
          : 'Address updated successfully',
      type: ToastType.success,
    );

    Navigator.pop(context, address);
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
    final isEdit = widget.address != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Address' : 'Add Address')),
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
            const SizedBox(height: 4),
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
              onPressed: saveAddress,
              child: Text(isEdit ? 'Update Address' : 'Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}
