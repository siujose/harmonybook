import 'package:flutter/material.dart';
import 'package:cancionero_app/models/song.dart';
import 'package:cancionero_app/screens/song_detail_screen.dart';
import 'package:cancionero_app/services/supabase_service.dart';
import 'package:cancionero_app/screens/add_song_screen.dart';
import 'package:cancionero_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.changeTheme});

  final Function(bool) changeTheme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Song>> _songsFuture;
  final _searchController = TextEditingController();
  List<Song> _songs = [];
  List<Song> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _songsFuture = _getSongs();
  }

  Future<List<Song>> _getSongs() async {
    _songs = await SupabaseService.getSongs();
    _filteredSongs = _songs;
    return _songs;
  }

  void _filterSongs(String query) {
    setState(() {
      _filteredSongs = _songs
          .where((song) =>
              song.title.toLowerCase().contains(query.toLowerCase()) ||
              song.artist.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harmony Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsScreen(changeTheme: widget.changeTheme),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar canción',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterSongs,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Song>>(
              future: _songsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = _filteredSongs[index];
                      return ListTile(
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SongDetailScreen(song: song),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '© 2025 Jose Siu. Todos los derechos reservados.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSongScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
