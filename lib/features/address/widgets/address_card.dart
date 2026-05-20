import 'package:flutter/material.dart';

import '../../checkout/models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;
  final VoidCallback? onTap;
  final bool isBusy;

  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
    this.onTap,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDefault = address.isDefault;
    final isOffice = address.type.toLowerCase() == 'office';

    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      scale: isBusy ? 0.98 : 1,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: isBusy ? 0.72 : 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          child: Material(
            color: colorScheme.surface,
            elevation: isDefault ? 2 : 0,
            shadowColor: colorScheme.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(26),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(26),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: isDefault
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withValues(alpha: 0.7),
                    width: isDefault ? 1.6 : 1,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.surface,
                      isDefault
                          ? colorScheme.primaryContainer.withValues(alpha: 0.18)
                          : colorScheme.surfaceContainerHighest.withValues(
                              alpha: 0.2,
                            ),
                    ],
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
                            borderRadius: BorderRadius.circular(18),
                            color: colorScheme.primaryContainer.withValues(
                              alpha: 0.75,
                            ),
                          ),
                          child: Icon(
                            isOffice
                                ? Icons.business_center_rounded
                                : Icons.home_rounded,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isOffice ? 'Office address' : 'Home address',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isDefault)
                          _Chip(
                            label: 'Default',
                            icon: Icons.verified_rounded,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoLine(icon: Icons.phone_rounded, text: address.phone),
                    const SizedBox(height: 10),
                    _InfoLine(
                      icon: Icons.location_on_rounded,
                      text: address.fullAddress,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isBusy ? null : onEdit,
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            label: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isBusy ? null : onDelete,
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                            ),
                            label: const Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: isDefault
                          ? const SizedBox.shrink()
                          : Padding(
                              key: const ValueKey('set-default-button'),
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: isBusy ? null : onSetDefault,
                                  icon: const Icon(Icons.check_circle_rounded),
                                  label: const Text('Set as Default'),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final int maxLines;

  const _InfoLine({required this.icon, required this.text, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _Chip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
