import 'package:plant_app/models/category_model.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/models/seller_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppService {
  final SupabaseClient _sb = Supabase.instance.client;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final row = await _sb.from('categories').select('*');
      return row.map(CategoryModel.fromMap).toList();
    } on PostgrestException catch (e) {
      print('PostgREST error: ${e.code} | ${e.message} | ${e.details}');
      rethrow;
    }
  }

  Future<List<PlantModel>> getPlantsByCategory(String categoryId) async {
    try {
      final rows = await _sb
          .from('plants')
          .select('''
      id, name, description, type, season_label, price, discount, quantity, image,
      category_id, seller_id,
      category:categories!plants_category_id_fkey!inner(id, slug, name),
      seller:sellers!plants_seller_id_fkey(id, name, farm_name, job_title, location, about , image , lat , lng ,farm_image )
    ''')
          .eq('category_id', categoryId);

      return rows.map(PlantModel.fromMap).toList();
    } on PostgrestException catch (e) {
      print('PostgREST error: ${e.code} | ${e.message} | ${e.details}');
      rethrow;
    }
  }

  Future<List<SellerModel>> getSellers() async {
    try {
      final row = await _sb.from('sellers').select('*');
      
      return row.map((element) => SellerModel.fromMap(element)).toList();
    } on PostgrestException catch (e) {
      print('PostgREST error: ${e.code} | ${e.message} | ${e.details}');
      rethrow;
    }
  }

  Future<PlantModel> getPlantsById(String id) async {
    try {
      final rows = await _sb
          .from('plants')
          .select('''
      id, name, description, type, season_label, price, discount, quantity, image,
      category_id, seller_id,
      category:categories!plants_category_id_fkey!inner(id, slug, name),
      seller:sellers!plants_seller_id_fkey(id, name, farm_name, job_title, location, about , image , lat , lng ,farm_image )
    ''')
          .eq('id', id);

      return rows.map(PlantModel.fromMap).first;
    } on PostgrestException catch (e) {
      print('PostgREST error: ${e.code} | ${e.message} | ${e.details}');
      rethrow;
    }
  }

  Future<List<PlantModel>> getAllPlants() async {
    try {
      final rows = await _sb.from('plants').select('''
      id, name, description, type, season_label, price, discount, quantity, image,
      category_id, seller_id,
      category:categories!plants_category_id_fkey!inner(id, slug, name),
      seller:sellers!plants_seller_id_fkey(id, name, farm_name, job_title, location, about , image , lat , lng ,farm_image  )
    ''');

      return rows.map(PlantModel.fromMap).toList();
    } on PostgrestException catch (e) {
      print('PostgREST error: ${e.code} | ${e.message} | ${e.details}');
      rethrow;
    }
  }

  Future<List<PlantModel>> getSellerPlants(String sellerId) async {
    try {
      final rows = await _sb.from('plants').select('''
      id, name, description, type, season_label, price, discount, quantity, image,
      category_id, seller_id,
      category:categories!plants_category_id_fkey!inner(id, slug, name),
      seller:sellers!plants_seller_id_fkey(id, name, farm_name, job_title, location, about , image , lat , lng ,farm_image )
    ''').eq('seller_id', sellerId);

      return rows.map(PlantModel.fromMap).toList();
    } on PostgrestException catch (e) {
      print('PostgREST error: ${e.code} | ${e.message} | ${e.details}');
      rethrow;
    }
  }
}
