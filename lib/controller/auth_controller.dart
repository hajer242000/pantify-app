import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:plant_app/repository/auth_repository.dart';


class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repo, this._read) : super(const AsyncValue.data(null));

  final AuthRepository _repo;
  final Ref _read;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'customer',
    bool createProfileRow = true, 
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await _repo.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );


      if (createProfileRow && res.user != null && res.session != null) {
        await _repo.upsertProfile(
          id: res.user!.id,
          email: res.user!.email ?? email,
          fullName: fullName,
          role: role,
        );
      }

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signIn(email: email, password: password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}