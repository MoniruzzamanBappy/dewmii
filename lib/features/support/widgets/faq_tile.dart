import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/faq_model.dart';

class FaqTile extends StatelessWidget {
  final FaqModel faq;

  const FaqTile({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(faq.category.toUpperCase()),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            faq.answer,
            style: const TextStyle(
              color: AppColors.lightTextSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
