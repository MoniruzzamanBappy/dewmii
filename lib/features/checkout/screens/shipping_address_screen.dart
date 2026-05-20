import 'package:dewmii/features/checkout/screens/add_edit_address_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/address_model.dart';

class ShippingAddressScreen extends StatefulWidget {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;

  const ShippingAddressScreen({
    super.key,
    required this.addresses,
    this.selectedAddress,
  });

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  late List<AddressModel> addresses;
  AddressModel? selectedAddress;

  @override
  void initState() {
    super.initState();
    addresses = List.from(widget.addresses);
    selectedAddress = widget.selectedAddress;
  }

  Future<void> openAddEditAddress({AddressModel? address}) async {
    final result = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(builder: (_) => AddEditAddressScreen(address: address)),
    );

    if (result != null) {
      setState(() {
        final index = addresses.indexWhere((item) => item.id == result.id);
        if (index >= 0) {
          addresses[index] = result;
        } else {
          addresses.add(result);
        }
        selectedAddress = result;
      });
    }
  }

  void selectAndReturn(AddressModel address) {
    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Address'),
        actions: [
          IconButton(
            onPressed: () => openAddEditAddress(),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: addresses.isEmpty
          ? _AddressEmptyState(onAdd: () => openAddEditAddress())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              children: [
                ...addresses.map((address) {
                  final isSelected = selectedAddress?.id == address.id;
                  return _AddressTile(
                    address: address,
                    selected: isSelected,
                    onTap: () {
                      setState(() => selectedAddress = address);
                      selectAndReturn(address);
                    },
                    onEdit: () => openAddEditAddress(address: address),
                  );
                }),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => openAddEditAddress(),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add New Address'),
                ),
              ],
            ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressModel address;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _AddressTile({
    required this.address,
    required this.selected,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = selected ? AppColors.primary : (dark ? AppColors.darkBorder : AppColors.lightBorder);
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: selected ? 1.6 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(address.type == 'office' ? Icons.business_rounded : Icons.home_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(address.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                        if (address.isDefault)
                          const Chip(
                            label: Text('Default'),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(address.phone, style: TextStyle(color: secondary, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(address.fullAddress, style: TextStyle(color: secondary, height: 1.35)),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressEmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _AddressEmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off_rounded, size: 72, color: AppColors.primary),
            const SizedBox(height: 18),
            const Text('No address added yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Add your delivery address to continue checkout.', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Address'),
            ),
          ],
        ),
      ),
    );
  }
}
