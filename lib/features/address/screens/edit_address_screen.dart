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
      setState(() => addressDetails = result);

      if (result != null) {
        nameController.text = result.name;
        phoneController.text = result.phone;
        divisionController.text = result.division;
        cityController.text = result.city;
        areaController.text = result.area;
        addressLineController.text = result.addressLine;
        postalCodeController.text = result.postalCode;
        type = result.type;
        isDefault = result.isDefault;
      }
    } catch (_) {
      // Keep screen usable with the address passed from the list screen.
    } finally {
      if (mounted) setState(() => isDetailsLoading = false);
    }
  }

  Future<void> updateAddress() async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

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
      if (mounted) setState(() => isLoading = false);
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

  String? _required(String label, String? value) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  String? _phoneValidator(String? value) {
    final requiredError = _required('Phone', value);
    if (requiredError != null) return requiredError;
    final normalized = value!.replaceAll(RegExp(r'[\s\-()]'), '');
    if (normalized.length < 8) return 'Enter a valid phone number';
    return null;
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
        minLines: maxLines > 1 ? 2 : 1,
        maxLines: maxLines,
        textInputAction: maxLines > 1
            ? TextInputAction.done
            : TextInputAction.next,
        validator: validator ?? (value) => _required(label, value),
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayAddress = addressDetails ?? widget.address;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Address')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: FilledButton.icon(
          onPressed: isLoading ? null : updateAddress,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                )
              : const Icon(Icons.done_all_rounded),
          label: Text(isLoading ? 'Updating...' : 'Update Address'),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _AddressHero(
              title: 'Update delivery details',
              subtitle: displayAddress.fullAddress,
              icon: type.toLowerCase() == 'office'
                  ? Icons.business_center_rounded
                  : Icons.home_rounded,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: isDetailsLoading
                  ? Padding(
                      key: const ValueKey('loading-details'),
                      padding: const EdgeInsets.only(top: 14),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(minHeight: 6),
                      ),
                    )
                  : const SizedBox(height: 18),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.65),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_note_rounded, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Editing ${displayAddress.name}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _field(
                    label: 'Name',
                    controller: nameController,
                    icon: Icons.person_rounded,
                  ),
                  _field(
                    label: 'Phone',
                    controller: phoneController,
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    validator: _phoneValidator,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          label: 'Division',
                          controller: divisionController,
                          icon: Icons.map_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          label: 'City',
                          controller: cityController,
                          icon: Icons.location_city_rounded,
                        ),
                      ),
                    ],
                  ),
                  _field(
                    label: 'Area',
                    controller: areaController,
                    icon: Icons.explore_rounded,
                  ),
                  _field(
                    label: 'Address Line',
                    controller: addressLineController,
                    icon: Icons.edit_location_alt_rounded,
                    maxLines: 2,
                  ),
                  _field(
                    label: 'Postal Code',
                    controller: postalCodeController,
                    icon: Icons.local_post_office_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 2),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: const InputDecoration(
                      labelText: 'Address Type',
                      prefixIcon: Icon(Icons.category_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'home', child: Text('Home')),
                      DropdownMenuItem(value: 'office', child: Text('Office')),
                    ],
                    onChanged: (value) =>
                        setState(() => type = value ?? 'home'),
                  ),
                  const SizedBox(height: 14),
                  Material(
                    color: Colors.transparent,
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: isDefault,
                      title: const Text('Set as default address'),
                      subtitle: const Text(
                        'Use this automatically during checkout',
                      ),
                      secondary: Icon(
                        Icons.verified_rounded,
                        color: colorScheme.primary,
                      ),
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
}

class _AddressHero extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _AddressHero({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.72),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      height: 1.35,
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
}
