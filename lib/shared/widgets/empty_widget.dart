import 'package:flutter/material.dart';

// =========================================
// EMPTY WIDGET - Empty state show kore
// =========================================
class EmptyWidget extends StatelessWidget {
  final IconData icon; // Icon
  final String message; // Main message
  final String? subMessage; // Sub message (optional)

  const EmptyWidget({
    Key? key,
    required this.icon,
    required this.message,
    this.subMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            // Main message
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            // Sub message (jodi thake)
            if (subMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                subMessage!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}