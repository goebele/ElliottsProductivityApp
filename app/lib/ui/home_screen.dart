import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers.dart';

/// Placeholder until M1 brings the tree and node detail.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final identity = ref.watch(identityProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (identity) {
            AsyncData(:final value) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.homeReady, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  SelectableText(l10n.homeUserId(value.userId)),
                  SelectableText(l10n.homeDeviceId(value.deviceId)),
                ],
              ),
            AsyncError(:final error) => Text(
                l10n.startupError(error.toString()),
                textAlign: TextAlign.center,
              ),
            _ => const CircularProgressIndicator(),
          },
        ),
      ),
    );
  }
}
