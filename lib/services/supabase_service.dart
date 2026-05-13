import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Initialize Supabase
  /// Call this once at app startup
  static Future<void> initialize({
    required String supabaseUrl,
    required String supabaseKey,
  }) async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }

  /// Fetch all slides from database
  static Future<List<Map<String, dynamic>>> fetchSlides() async {
    try {
      final response = await _client
          .from('slides')
          .select('*')
          .order('id', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching slides: $e');
      return [];
    }
  }

  /// Fetch slides by pack (for paid content)
  static Future<List<Map<String, dynamic>>> fetchSlidesByPack(String packId) async {
    try {
      final response = await _client
          .from('slides')
          .select('*')
          .eq('pack_id', packId)
          .order('id', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching slides by pack: $e');
      return [];
    }
  }

  /// Log game result to database
  static Future<void> logGameResult({
    required int slidesSeen,
    required bool smileDetected,
    required int duration,
  }) async {
    try {
      await _client.from('game_results').insert({
        'slides_seen': slidesSeen,
        'smile_detected': smileDetected,
        'duration_seconds': duration,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error logging game result: $e');
    }
  }

  /// Get Supabase client (advanced usage)
  static SupabaseClient getClient() {
    return _client;
  }
}
