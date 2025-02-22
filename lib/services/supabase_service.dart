import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cancionero_app/models/song.dart';

class SupabaseService {
  static Future<List<Song>> getSongs() async {
    try {
      final response = await Supabase.instance.client
          .from('songs')
          .select('*')
          .order('title', ascending: true);

      final data = response as List<dynamic>;
      print('Raw Supabase data: $data');
      return data.map((e) => Song.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting songs: $e');
      return [];
    }
  }

  static Future<Song> getSong(int id) async {
    final response = await Supabase.instance.client
        .from('songs')
        .select('*')
        .eq('id', id)
        .single();

    return Song.fromJson(response);
  }

  static Future<void> addSong(Song song) async {
    try {
      await Supabase.instance.client.from('songs').insert(song.toJson());
    } catch (e) {
      print('Error adding song: $e');
    }
  }

  static Future<void> updateSong(Song song) async {
    try {
      print('Updating song: ${song.toJson()}');
      await Supabase.instance.client
          .from('songs')
          .update(song.toJson())
          .eq('id', song.id);
    } catch (e) {
      print('Error updating song: $e');
    }
  }

  static Future<void> deleteSong(int id) async {
    try {
      await Supabase.instance.client.from('songs').delete().eq('id', id);
    } catch (e) {
      print('Error deleting song: $e');
    }
  }

  static Future<void> insertSampleData() async {
    final song = Song(
      id: 0,
      title: 'Bohemian Rhapsody',
      artist: 'Queen',
      tonality: 'Bb Major',
      tempo: '140 bpm',
      rhythm: '4/4',
      duration: '5:55',
      instruments: 'Piano, Guitar, Drums, Bass, Vocals',
      url: 'https://www.youtube.com/watch?v=fJ9rUzIMcZQ',
      lyricsAndChords: 'This is a sample lyrics and chords',
    );
    await Supabase.instance.client.from('songs').insert(song.toJson());
  }
}
