import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../checkout/models/address_model.dart';
import '../services/address_api_service.dart';
import '../widgets/address_card.dart';
import 'add_address_screen.dart';
import 'edit_address_screen.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  final AddressApiService service = AddressApiService();

  bool isLoading = true;
  bool isActionLoading = false;

  List<AddressModel> addresses = [];

  Future<void> fetchAddresses() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getAddresses();

      if (!mounted) return;

      setState(() {
        addresses = result;
      });
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

  Future<void> openAddAddress() async {
    final result = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressScreen()),
    );

    if (result != null) {
      setState(() {
        final exists = addresses.any((item) => item.id == result.id);

        if (!exists) {
          addresses = [...addresses, result];
        }
      });
    }
  }

  Future<void> openEditAddress(AddressModel address) async {
    final result = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(builder: (_) => EditAddressScreen(address: address)),
    );

    if (result != null) {
      setState(() {
        addresses = addresses.map((item) {
          return item.id == address.id ? result : item;
        }).toList();
      });
    }
  }

  Future<void> deleteAddress(AddressModel address) async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.deleteAddressDemo(addressId: address.id);

      final deletedId = service.parseDeletedAddressId(response) ?? address.id;

      if (!mounted) return;

      setState(() {
        addresses = addresses.where((item) => item.id != deletedId).toList();
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Address deleted successfully',
        type: ToastType.success,
      );
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
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> setDefaultAddress(AddressModel address) async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.setDefaultAddressDemo(
        addressId: address.id,
      );

      final defaultAddressId =
          service.parseDefaultAddressId(response) ?? address.id;

      if (!mounted) return;

      setState(() {
        addresses = addresses.map((item) {
          return item.copyWith(isDefault: item.id == defaultAddressId);
        }).toList();
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Default address updated successfully',
        type: ToastType.success,
      );
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
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> confirmDelete(AddressModel address) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Address?'),
          content: Text(
            'Are you sure you want to delete ${address.name} address?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      deleteAddress(address);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            onPressed: openAddAddress,
            icon: const Icon(Icons.add_location_alt_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddAddress,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Address'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchAddresses,
              child: addresses.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 120),
                        Icon(
                          Icons.location_off_rounded,
                          size: 94,
                          color: AppColors.primary.withValues(alpha: 0.65),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'No saved addresses',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add your delivery address to make checkout faster.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.lightTextSecondary),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (isActionLoading) ...[
                          const LinearProgressIndicator(),
                          const SizedBox(height: 14),
                        ],
                        const Text(
                          'Saved Addresses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...addresses.map((address) {
                          return AddressCard(
                            address: address,
                            onEdit: isActionLoading
                                ? () {}
                                : () {
                                    openEditAddress(address);
                                  },
                            onDelete: isActionLoading
                                ? () {}
                                : () {
                                    confirmDelete(address);
                                  },
                            onSetDefault: isActionLoading
                                ? () {}
                                : () {
                                    setDefaultAddress(address);
                                  },
                          );
                        }),
                        const SizedBox(height: 90),
                      ],
                    ),
            ),
    );
  }
}
