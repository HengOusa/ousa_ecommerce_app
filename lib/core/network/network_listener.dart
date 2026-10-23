import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'network_service.dart';
import 'network_status.dart';

class NetworkListener extends StatelessWidget {
  const NetworkListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final networkService = context.read<NetworkService>();

    return StreamBuilder<NetworkStatus>(
      stream: networkService.statusStream,
      initialData: networkService.currentStatus,
      builder: (context, snapshot) {
        final status = snapshot.data ?? NetworkStatus.disconnected;

        final isConnected = status == NetworkStatus.connected;

        return Column(
          children: [
            if (!isConnected)
              MaterialBanner(
                content: const Text(
                  'No internet connection. Please check your network.',
                ),
                leading: const Icon(Icons.wifi_off, color: Colors.white),
                backgroundColor: Colors.red.shade700,
                contentTextStyle: const TextStyle(color: Colors.white),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await networkService.checkConnection();
                    },
                    child: const Text(
                      'CHECK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
