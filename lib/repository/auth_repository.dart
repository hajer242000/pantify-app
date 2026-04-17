import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabaseClient;
  AuthRepository(this.supabaseClient);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'customer',
  }) {
    return supabaseClient.auth.signUp(
      password: password,
      email: email,
      data: {'full_name': fullName, 'role': role},
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return supabaseClient.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  Future<void> signOut() => supabaseClient.auth.signOut();

  Future<void> upsertProfile({
    required String id,
    required String email,
    required String fullName,
    required String role,
  }) async {
    await supabaseClient.from('users').upsert({
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
    }, onConflict: 'id');
  }

  Stream<AuthState> onAuthStateChange() =>
      supabaseClient.auth.onAuthStateChange;
}
