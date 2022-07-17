import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_vessels/src/features/authentication/domain/app_user.dart';
import 'package:my_vessels/src/utils/delay.dart';
import 'package:my_vessels/src/utils/in_memory_store.dart';

class FakeAuthRepository {
  FakeAuthRepository({this.addDelay = true});
  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;

  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    _createNewUser(email);
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void _createNewUser(String email) {
    // Note the uid could be any unique string. Here we simply reverse the email.
    _authState.value =
        AppUser(uid: email.split('').reversed.join(), email: email);
  }

  void dispose() => _authState.close();
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
