import 'package:flutter/material.dart';
import 'package:flutter_ai/theme/constants.dart';

class StreamLoadingIndicator extends StatelessWidget {
  const StreamLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.m,
          height: AppSpacing.m,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
        AppGaps.wS,
        Text(
          'Thinking...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
