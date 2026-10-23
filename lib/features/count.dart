import 'package:ecom_app/features/cout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Count extends StatelessWidget {
  const Count({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count: ${context.watch<CoutProvider>().count}',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
                context.read<CoutProvider>().increment();
              },
              child: const Text('Increment Count'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CoutProvider>().decrement();
              },
              child: const Text('Decrement Count'),
            ),
          ],
        ),
      ),
    );
  }
}
