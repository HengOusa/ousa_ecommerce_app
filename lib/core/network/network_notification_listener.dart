import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'network_service.dart';
import 'network_status.dart';

// Connect this key to your MaterialApp.
final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class NetworkNotificationListener extends StatefulWidget {
  const NetworkNotificationListener({super.key, required this.child});

  final Widget child;

  @override
  State<NetworkNotificationListener> createState() =>
      _NetworkNotificationListenerState();
}

class _NetworkNotificationListenerState
    extends State<NetworkNotificationListener> {
  StreamSubscription<NetworkStatus>? _subscription;

  @override
  void initState() {
    super.initState();

    // Listen for network changes globally.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final networkService = context.read<NetworkService>();

      _subscription = networkService.statusStream.listen(_showNotification);
    });
  }

  void _showNotification(NetworkStatus status) {
    final messenger = appScaffoldMessengerKey.currentState;

    if (messenger == null) return;

    // Replace the previous notification if the status changes again.
    messenger.hideCurrentSnackBar();

    final isConnected = status == NetworkStatus.connected;

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isConnected
            ? Colors.green.shade700
            : Colors.red.shade700,
        duration: Duration(seconds: isConnected ? 3 : 5),
        content: Row(
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isConnected
                    ? 'Internet connection restored'
                    : 'No internet connection',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
