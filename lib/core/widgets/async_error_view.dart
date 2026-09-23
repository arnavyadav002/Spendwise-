import 'package:flutter/material.dart';

import '../errors/bank_error.dart';

class AsyncErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const AsyncErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    String message = 'An error occurred';
    if (error is BankError) {
      message = (error as BankError).message;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
