@Timeout(Duration(milliseconds: 500))
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_vessels/src/features/authentication/presentation/account/account_screen_controller.dart';

import '../../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(
      authRepository: authRepository,
    );
  });
  group('AccountScreenController', () {
    test('initial state is asyncValue.data', () {
      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });
  });
  test('signOut failure', () async {
    //setup
    final exception = Exception('Connection failed');
    when(authRepository.signOut).thenThrow(exception);
    // verify
    expectLater(
      controller.stream,
      emitsInOrder(
        [
          const AsyncLoading<void>(),
          predicate<AsyncError<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ],
      ),
    );
    // run
    await controller.signOut();
    // verify
    verify(authRepository.signOut).called(1);
    expect(controller.debugState.error, exception);
  });
  test('signOut success', () async {
    // setup
    when(authRepository.signOut).thenAnswer((_) async => Future.value());

    // verify
    expectLater(
      controller.stream,
      emitsInOrder(
        [
          const AsyncLoading<void>(),
          const AsyncData<void>(null),
        ],
      ),
    );
    // run
    await controller.signOut();
    //verify
    verify(authRepository.signOut).called(1);
  });
}
