import 'package:flutter/material.dart';

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
    setState(() => isLoading = true);

    try {
      final result = await service.getAddresses();
      if (!mounted) return;
      setState(() => addresses = result);
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

  Route<T> _slideRoute<T>(Widget child) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, animation, _) => child,
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> openAddAddress() async {
    final result = await Navigator.push<AddressModel>(
      context,
      _slideRoute(const AddAddressScreen()),
    );

    if (result != null) {
      setState(() {
        final normalized = result.isDefault
            ? _clearDefault(addresses)
            : addresses;
        final exists = normalized.any((item) => item.id == result.id);
        addresses = exists
            ? normalized
                  .map((item) => item.id == result.id ? result : item)
                  .toList()
            : [result, ...normalized];
      });
    }
  }

  Future<void> openEditAddress(AddressModel address) async {
    final result = await Navigator.push<AddressModel>(
      context,
      _slideRoute(EditAddressScreen(address: address)),
    );

    if (result != null) {
      setState(() {
        final normalized = result.isDefault
            ? _clearDefault(addresses)
            : addresses;
        addresses = normalized
            .map((item) => item.id == address.id ? result : item)
            .toList();
      });
    }
  }

  Future<void> deleteAddress(AddressModel address) async {
    setState(() => isActionLoading = true);

    try {
      final response = await service.deleteAddressDemo(addressId: address.id);
      final deletedId = service.parseDeletedAddressId(response) ?? address.id;

      if (!mounted) return;
      setState(
        () => addresses = addresses
            .where((item) => item.id != deletedId)
            .toList(),
      );

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
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> setDefaultAddress(AddressModel address) async {
    setState(() => isActionLoading = true);

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
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> confirmDelete(AddressModel address) async {
    final colorScheme = Theme.of(context).colorScheme;
    final shouldDelete = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Delete this address?',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  '${address.name}\n${address.fullAddress}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldDelete == true) deleteAddress(address);
  }

  List<AddressModel> _clearDefault(List<AddressModel> items) {
    return items.map((item) => item.copyWith(isDefault: false)).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final defaultCount = addresses.where((item) => item.isDefault).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: isLoading ? null : fetchAddresses,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Add address',
            onPressed: openAddAddress,
            icon: const Icon(Icons.add_location_alt_rounded),
          ),
        ],
      ),
      floatingActionButton: addresses.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: openAddAddress,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Address'),
            ),
      body: RefreshIndicator(
        onRefresh: fetchAddresses,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          child: isLoading
              ? const _AddressSkeletonList(key: ValueKey('loading'))
              : addresses.isEmpty
              ? _EmptyAddresses(
                  key: const ValueKey('empty'),
                  onAdd: openAddAddress,
                )
              : ListView(
                  key: const ValueKey('content'),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                  children: [
                    _SummaryCard(
                      count: addresses.length,
                      defaultCount: defaultCount,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: isActionLoading
                          ? Padding(
                              key: const ValueKey('action-loading'),
                              padding: const EdgeInsets.only(
                                top: 14,
                                bottom: 6,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: const LinearProgressIndicator(
                                  minHeight: 6,
                                ),
                              ),
                            )
                          : const SizedBox(height: 18),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Saved Addresses',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${addresses.length} total',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(addresses.length, (index) {
                      final address = addresses[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(
                          milliseconds: 260 + (index * 45).clamp(0, 240),
                        ),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 18 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: AddressCard(
                          address: address,
                          isBusy: isActionLoading,
                          onEdit: () => openEditAddress(address),
                          onDelete: () => confirmDelete(address),
                          onSetDefault: () => setDefaultAddress(address),
                        ),
                      );
                    }),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int count;
  final int defaultCount;

  const _SummaryCard({required this.count, required this.defaultCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
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
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count saved ${count == 1 ? 'address' : 'addresses'}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  defaultCount > 0
                      ? 'Default address is ready for checkout.'
                      : 'Choose a default address for faster checkout.',
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
    );
  }
}

class _EmptyAddresses extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyAddresses({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 95),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1),
          duration: const Duration(milliseconds: 520),
          curve: Curves.elasticOut,
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer.withValues(alpha: 0.65),
            ),
            child: Icon(
              Icons.location_off_rounded,
              size: 62,
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'No saved addresses',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add your delivery address once and use it quickly during checkout.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_location_alt_rounded),
          label: const Text('Add Address'),
        ),
      ],
    );
  }
}

class _AddressSkeletonList extends StatelessWidget {
  const _AddressSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget block({double height = 18, double width = double.infinity}) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(999),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemBuilder: (_, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.65,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: block(width: 160)),
                ],
              ),
              const SizedBox(height: 16),
              block(width: 210),
              const SizedBox(height: 10),
              block(height: 16),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: block(height: 42)),
                  const SizedBox(width: 10),
                  Expanded(child: block(height: 42)),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemCount: 4,
    );
  }
}
