import 'package:elliotts_productivity_app/identity/identity_service.dart';
import 'package:elliotts_productivity_app/providers.dart';
import 'package:elliotts_productivity_app/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home screen shows the identity once it is ready',
      (tester) async {
    const identity = LocalIdentity(
      userId: 'user-123',
      deviceId: 'device-456',
      personalSpaceId: 'space-789',
      userPublicKey: '',
      devicePublicKey: '',
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [identityProvider.overrideWith((ref) async => identity)],
      child: const App(),
    ));
    await tester.pumpAndSettle();

    expect(find.text("Elliott's Productivity App"), findsOneWidget);
    expect(find.text('User ID: user-123'), findsOneWidget);
    expect(find.text('Device ID: device-456'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
