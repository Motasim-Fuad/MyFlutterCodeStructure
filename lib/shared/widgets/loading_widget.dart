import 'package:flutter/material.dart';

// =========================================
// LOADING WIDGET - Loading state show kore
// =========================================
class LoadingWidget extends StatelessWidget {
  final String message; // Loading message

  const LoadingWidget({
    Key? key,
    this.message = 'Loading...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spinner
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          // Message
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}