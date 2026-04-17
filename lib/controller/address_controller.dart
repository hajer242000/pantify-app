import 'package:plant_app/models/address_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddressController {
  final SupabaseClient supabase;
  AddressController(this.supabase);

  Future<AddressModel> addAddress(AddressModel address) async {
    final map = address.toMap();
    map.remove('id');
    map['user_id'] = supabase.auth.currentUser!.id;
    final previousDefault = await supabase
        .from('address')
        .select()
        .eq('is_default', true)
        .single();
    updateAddress(
      AddressModel.fromMap(previousDefault).copyWith(isDefault: false),
    );
    final res = await supabase.from('address').insert(map).select().single();

    return AddressModel.fromMap(res);
  }

  Future<List<AddressModel>> getAddresses(String userId) async {
    final res = await supabase
        .from('address')
        .select('*')
        .eq('user_id', userId)
        .order('is_default', ascending: false)
        .order('created_at', ascending: false);

    return (res as List)
        .map((e) => AddressModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<AddressModel?> getDefaultAddress(String userId) async {
    final res = await supabase
        .from('address')
        .select('*')
        .eq('user_id', userId)
        .eq('is_default', true)
        .maybeSingle();
    if (res == null) return null;
    return AddressModel.fromMap(res as Map<String, dynamic>);
  }

  Future<void> updateAddress(AddressModel address) async {
    await supabase
        .from('address')
        .update(address.toMap())
        .eq('id', address.id!)
        .eq('user_id', address.userId);
  }

  Future<void> deleteAddress({
    required String id,
    required String userId,
  }) async {
    await supabase.from('address').delete().eq('id', id).eq('user_id', userId);
  }

  Future<void> setDefaultAddress({
    required String userId,
    required String addressId,
  }) async {
    await supabase
        .from('address')
        .update({'is_default': false})
        .eq('user_id', userId);

    await supabase
        .from('address')
        .update({'is_default': true})
        .eq('id', addressId)
        .eq('user_id', userId);
  }
}
