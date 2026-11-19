import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import '../sync/pairing.dart';
import '../sync/secure_channel.dart';
import '../sync/sync_service.dart';
import 'prompt_dialog.dart';

/// "just now", "5 minutes ago", or a date.
String syncAgo(AppLocalizations l10n, BuildContext context, DateTime when) {
  final d = DateTime.now().difference(when);
  if (d.inMinutes < 1) return l10n.syncJustNow;
  if (d.inHours < 1) return l10n.syncMinutesAgo(d.inMinutes);
  if (d.inDays < 1) return l10n.syncHoursAgo(d.inHours);
  return MaterialLocalizations.of(context).formatMediumDate(when.toLocal());
}

String _platformName(String p) => switch (p) {
  'windows' => 'Windows',
  'android' => 'Android',
  'macos' => 'Mac',
  'ios' => 'iPhone',
  'linux' => 'Linux',
  _ => p,
};

/// The sync icon in the top bar (§7.6 step 5): idle, syncing or a problem;
/// clicking it opens Devices. Also syncs when the app comes back.
class SyncStatusButton extends ConsumerStatefulWidget {
  const SyncStatusButton({super.key, required this.onOpen});

  final VoidCallback onOpen;

  @override
  ConsumerState<SyncStatusButton> createState() => _SyncStatusButtonState();
}

class _SyncStatusButtonState extends ConsumerState<SyncStatusButton> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Phones: sync only while the app is in front (battery, and nothing
    // listening on the network in the background). Desktops keep going.
    final phone = Platform.isAndroid || Platform.isIOS;
    Future<SyncService?> service() => ref.read(syncServiceProvider.future);
    _lifecycle = AppLifecycleListener(
      onResume: () async {
        final s = await service();
        if (phone) {
          await s?.resume();
        } else {
          await s?.syncNow();
        }
      },
      onHide: () async {
        if (phone) await (await service())?.suspend();
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(syncStatusProvider).value;
    if (status == null) return const SizedBox.shrink();
    final (icon, tip) = switch (status.phase) {
      SyncPhase.syncing => (Icons.sync, l10n.syncStatusSyncing),
      SyncPhase.error || SyncPhase.off => (
        Icons.sync_problem,
        l10n.syncStatusProblem(status.message ?? ''),
      ),
      _ when status.lastSync != null => (
        Icons.devices_outlined,
        l10n.syncStatusSynced(syncAgo(l10n, context, status.lastSync!)),
      ),
      _ => (Icons.devices_outlined, l10n.syncStatusNever),
    };
    return IconButton(
      tooltip: tip,
      icon: status.phase == SyncPhase.syncing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon),
      onPressed: widget.onOpen,
    );
  }
}

/// Devices (§7.2, §7.6): this device, your others, and pairing.
class DevicesPage extends ConsumerWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final service = ref.watch(syncServiceProvider).value;
    final status = ref.watch(syncStatusProvider).value;
    final known = ref.watch(knownDevicesProvider).value ?? const <Device>[];
    final nearby = ref.watch(nearbyDevicesProvider).value ?? const [];
    final me = known.where((d) => d.isThisDevice).firstOrNull;
    final others = [
      for (final d in known)
        if (!d.isThisDevice) d,
    ];
    final strangers = [
      for (final n in nearby)
        if (service != null && !service.isMine(n)) n,
    ];
    String nameOf(Device d) =>
        d.label ??
        l10n.devicesUnnamed(
          d.deviceId.substring(d.deviceId.length - 4).toUpperCase(),
        );

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      child: Text(text, style: theme.textTheme.titleMedium),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        Text(l10n.devicesView, style: theme.textTheme.headlineSmall),
        if (service == null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(l10n.devicesSyncOff),
          ),
        if (service != null) ...[
          heading(l10n.devicesThisDevice),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Icon(
                Platform.isAndroid ? Icons.phone_android : Icons.computer,
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      me?.label ?? SyncService.defaultLabel(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.devicesRename,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: () async {
                      final name = await promptText(
                        context,
                        title: l10n.devicesRename,
                        initial: me?.label ?? SyncService.defaultLabel(),
                      );
                      if (name != null && name.trim().isNotEmpty) {
                        await service.setLabel(name.trim());
                      }
                    },
                  ),
                ],
              ),
              subtitle: Text(
                [
                  if (status?.lastSync case final at?)
                    l10n.devicesLastSync(syncAgo(l10n, context, at))
                  else
                    l10n.devicesNeverSynced,
                  if (status?.address case final a?) l10n.devicesReachableAt(a),
                  ?status?.message,
                ].join('\n'),
              ),
              isThreeLine: true,
              trailing: FilledButton.tonalIcon(
                icon: const Icon(Icons.sync),
                label: Text(l10n.devicesSyncNow),
                onPressed: status?.phase == SyncPhase.syncing
                    ? null
                    : () => service.syncNow(quiet: false),
              ),
            ),
          ),
          heading(l10n.devicesYours),
          if (others.isEmpty) Text(l10n.devicesNoneYet),
          for (final d in others)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.devices_other),
              title: Text(nameOf(d)),
              subtitle: Text(
                d.lastSyncAt == null
                    ? l10n.devicesNeverSynced
                    : l10n.devicesLastSync(
                        syncAgo(l10n, context, d.lastSyncAt!),
                      ),
              ),
              trailing: service.isNearby(d.deviceId)
                  ? Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: const Icon(Icons.wifi, size: 16),
                      label: Text(l10n.devicesNearbyNow),
                    )
                  : null,
            ),
          heading(l10n.devicesPair),
          Text(l10n.devicesPairHelp),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.add_link),
                label: Text(l10n.devicesLetJoin),
                onPressed: () => showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => _HostDialog(
                    service: service,
                    name: me?.label ?? SyncService.defaultLabel(),
                  ),
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.lan_outlined),
                label: Text(l10n.devicesJoinByAddress),
                onPressed: () async {
                  final text = await promptText(
                    context,
                    title: l10n.devicesAddressPrompt,
                  );
                  if (text == null || text.trim().isEmpty) return;
                  final m = RegExp(r'^\s*([^\s:]+):(\d+)\s*$').firstMatch(text);
                  if (m == null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          persist: false,
                          content: Text(l10n.devicesAddressInvalid),
                        ),
                      );
                    }
                    return;
                  }
                  if (!context.mounted) return;
                  await _join(
                    context,
                    ref,
                    service,
                    m.group(1)!,
                    int.parse(m.group(2)!),
                  );
                },
              ),
            ],
          ),
          heading(l10n.devicesNearby),
          if (strangers.isEmpty) Text(l10n.devicesNearbyNone),
          for (final n in strangers)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                n.platform == 'android' ? Icons.phone_android : Icons.computer,
              ),
              title: Text(
                l10n.devicesPlatformCode(_platformName(n.platform), n.shortId),
              ),
              subtitle: Text(n.host),
              trailing: FilledButton.tonal(
                onPressed: () => _join(context, ref, service, n.host, n.port),
                child: Text(l10n.devicesJoin),
              ),
            ),
          heading(l10n.devicesPin),
          _PinRow(service: service),
        ],
      ],
    );
  }
}

/// Joins the device at [host]:[port] from this one, then reloads this
/// device's identity (it's now one of the other's).
Future<void> _join(
  BuildContext context,
  WidgetRef ref,
  SyncService service,
  String host,
  int port,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final container = ProviderScope.containerOf(context, listen: false);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.pairJoinConfirmTitle),
      content: Text(l10n.pairJoinConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.devicesJoin),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  // A working dialog while it runs; the code check pops up over it.
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _WorkingDialog(text: l10n.pairWorking),
    ),
  );
  final nav = Navigator.of(context);
  try {
    await service.join(
      host,
      port,
      confirm: (_, code) async =>
          await _compareCode(nav.context, code) ?? false,
      askPin: () =>
          promptText(nav.context, title: l10n.devicesPinAsk, number: true),
    );
    nav.pop();
    messenger.showSnackBar(
      SnackBar(persist: false, content: Text(l10n.pairJoined)),
    );
    // This device is now one of the other's: reload who it is.
    container.invalidate(identityProvider);
  } catch (e) {
    nav.pop();
    final reason = switch (e) {
      PairingCancelled(:final reason) => reason,
      HandshakeException(:final message) => message,
      _ => '$e',
    };
    messenger.showSnackBar(
      SnackBar(persist: false, content: Text(l10n.pairFailed(reason))),
    );
  }
}

/// "Does the other device show 123 456?" Yes / No.
Future<bool?> _compareCode(BuildContext context, String code) {
  final l10n = AppLocalizations.of(context);
  final theme = Theme.of(context);
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(l10n.pairCompareTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.pairCompareBody),
          const SizedBox(height: 16),
          Text(
            '${code.substring(0, 3)} ${code.substring(3)}',
            style: theme.textTheme.displaySmall?.copyWith(letterSpacing: 4),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.pairCodesDiffer),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.pairCodesMatch),
        ),
      ],
    ),
  );
}

class _WorkingDialog extends StatelessWidget {
  const _WorkingDialog({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(width: 20),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

/// "Let a device join this one": waits for a request, shows the code to
/// compare, then pairs. Requests are only taken while it's open.
class _HostDialog extends StatefulWidget {
  const _HostDialog({required this.service, required this.name});

  final SyncService service;
  final String name;

  @override
  State<_HostDialog> createState() => _HostDialogState();
}

class _HostDialogState extends State<_HostDialog> {
  /// The window for joining closes by itself.
  static const _open = Duration(minutes: 5);
  Timer? _closeTimer;
  String? _code;
  Completer<bool>? _answer;
  bool _working = false;
  StreamSubscription<String?>? _outcomes;

  @override
  void initState() {
    super.initState();
    widget.service.pairingHost = (_, code) {
      final answer = Completer<bool>();
      if (mounted) {
        setState(() {
          _code = code;
          _answer = answer;
        });
      }
      return answer.future;
    };
    _closeTimer = Timer(_open, () {
      if (mounted && _code == null) Navigator.pop(context);
    });
    _outcomes = widget.service.pairingOutcomes.listen((failure) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          persist: false,
          content: Text(
            failure == null ? l10n.pairJoined : l10n.pairFailed(failure),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    widget.service.pairingHost = null;
    if (_answer case final a? when !a.isCompleted) a.complete(false);
    unawaited(_outcomes?.cancel());
    super.dispose();
  }

  void _say(bool yes) {
    _answer?.complete(yes);
    setState(() {
      _working = yes;
      if (!yes) {
        _code = null;
        _answer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final code = _code;
    return AlertDialog(
      title: Text(code == null ? l10n.pairWaitingTitle : l10n.pairCompareTitle),
      content: SizedBox(
        width: 360,
        child: _working
            ? Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20),
                  Expanded(child: Text(l10n.pairWorking)),
                ],
              )
            : code == null
            ? Row(
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      l10n.pairWaitingBody(
                        l10n.devicesPlatformCode(
                          _platformName(Platform.operatingSystem),
                          widget.service.shortCode,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.pairCompareBody),
                  const SizedBox(height: 16),
                  Text(
                    '${code.substring(0, 3)} ${code.substring(3)}',
                    style: theme.textTheme.displaySmall?.copyWith(
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        if (code != null && !_working) ...[
          TextButton(
            onPressed: () => _say(false),
            child: Text(l10n.pairCodesDiffer),
          ),
          FilledButton(
            onPressed: () => _say(true),
            child: Text(l10n.pairCodesMatch),
          ),
        ] else
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
      ],
    );
  }
}

/// The optional pairing PIN.
class _PinRow extends StatefulWidget {
  const _PinRow({required this.service});
  final SyncService service;

  @override
  State<_PinRow> createState() => _PinRowState();
}

class _PinRowState extends State<_PinRow> {
  bool? _set;

  PairingPin get _pin => PairingPin(widget.service.secrets);

  @override
  void initState() {
    super.initState();
    _pin.required().then((v) {
      if (mounted) setState(() => _set = v);
    });
  }

  Future<void> _change() async {
    final l10n = AppLocalizations.of(context);
    final pin = await promptText(
      context,
      title: l10n.devicesPinPrompt,
      number: true,
    );
    if (pin == null || pin.trim().length < 4) return;
    await _pin.set(pin.trim());
    if (mounted) setState(() => _set = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final set = _set;
    if (set == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(set ? l10n.devicesPinOn : l10n.devicesPinHelp),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton(
              onPressed: _change,
              child: Text(set ? l10n.devicesPinChange : l10n.devicesPinSet),
            ),
            if (set)
              TextButton(
                onPressed: () async {
                  await _pin.set(null);
                  if (mounted) setState(() => _set = false);
                },
                child: Text(l10n.devicesPinRemove),
              ),
          ],
        ),
      ],
    );
  }
}
