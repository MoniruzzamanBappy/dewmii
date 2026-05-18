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
            onPressed: () {
              openAddEditAddress();
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ...addresses.map((address) {
            final isSelected = selectedAddress?.id == address.id;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.lightBorder,
                  width: isSelected ? 1.6 : 1,
                ),
              ),
              child: ListTile(
                onTap: () => selectAndReturn(address),
                contentPadding: const EdgeInsets.all(16),
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.primary : AppColors.muted,
                ),
                title: Text(
                  address.name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${address.phone}\n${address.fullAddress}'),
                ),
                trailing: IconButton(
                  onPressed: () {
                    openAddEditAddress(address: address);
                  },
                  icon: const Icon(Icons.edit_rounded),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              openAddEditAddress();
            },
            icon: const Icon(Icons.add_location_alt_rounded),
            label: const Text('Add New Address'),
          ),
        ],
      ),
    );
  }
}
