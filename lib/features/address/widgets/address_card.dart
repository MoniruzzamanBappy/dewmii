import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../checkout/models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;
  final VoidCallback? onTap;

  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = address.isDefault;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDefault ? AppColors.primary : AppColors.lightBorder,
            width: isDefault ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isDefault
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.softMuted,
                  child: Icon(
                    address.type == 'office'
                        ? Icons.business_rounded
                        : Icons.home_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    address.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.phone_rounded,
                  size: 18,
                  color: AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  address.phone,
                  style: const TextStyle(
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.fullAddress,
                    style: const TextStyle(
                      color: AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
            if (!isDefault) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onSetDefault,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Set as Default'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
