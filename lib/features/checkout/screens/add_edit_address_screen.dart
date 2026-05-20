import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
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

    nameController = TextEditingController(text: address?.name ?? '');
    phoneController = TextEditingController(text: address?.phone ?? '');
    divisionController = TextEditingController(text: address?.division ?? '');
    cityController = TextEditingController(text: address?.city ?? '');
    areaController = TextEditingController(text: address?.area ?? '');
    addressLineController = TextEditingController(text: address?.addressLine ?? '');
    postalCodeController = TextEditingController(text: address?.postalCode ?? '');
    type = address?.type ?? 'home';
    isDefault = address?.isDefault ?? false;
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
      message: widget.address == null ? 'Address added successfully' : 'Address updated successfully',
      type: ToastType.success,
    );

    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Address' : 'Add Address')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: saveAddress,
          icon: const Icon(Icons.check_circle_rounded),
          label: Text(isEdit ? 'Update Address' : 'Save Address'),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: dark ? AppColors.darkHeroGradient : AppColors.heroGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      isEdit ? 'Update your delivery details' : 'Add a new delivery address',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              surface: surface,
              border: border,
              child: Column(
                children: [
                  _field(label: 'Full name', controller: nameController, icon: Icons.person_rounded),
                  _field(label: 'Phone number', controller: phoneController, icon: Icons.phone_rounded, keyboardType: TextInputType.phone),
                  _field(label: 'Division', controller: divisionController, icon: Icons.map_rounded),
                  _field(label: 'City', controller: cityController, icon: Icons.location_city_rounded),
                  _field(label: 'Area', controller: areaController, icon: Icons.place_rounded),
                  _field(
                    label: 'Address line',
                    controller: addressLineController,
                    icon: Icons.home_rounded,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                  ),
                  _field(label: 'Postal code', controller: postalCodeController, icon: Icons.local_post_office_rounded, keyboardType: TextInputType.number),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              surface: surface,
              border: border,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address type', style: TextStyle(color: secondary, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _TypeChip(label: 'Home', value: 'home', selected: type == 'home', onTap: () => setState(() => type = 'home'))),
                      const SizedBox(width: 10),
                      Expanded(child: _TypeChip(label: 'Office', value: 'office', selected: type == 'office', onTap: () => setState(() => type = 'office'))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Material(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    child: SwitchListTile.adaptive(
                      value: isDefault,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                      title: const Text('Set as default address', style: TextStyle(fontWeight: FontWeight.w800)),
                      onChanged: (value) => setState(() => isDefault = value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int minLines = 1,
    int maxLines = 1,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        textInputAction: textInputAction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) return '$label is required';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color surface;
  final Color border;

  const _SectionCard({required this.child, required this.surface, required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
