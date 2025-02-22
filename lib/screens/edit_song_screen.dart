import 'package:flutter/material.dart';
import 'package:cancionero_app/models/song.dart';
import 'package:cancionero_app/services/supabase_service.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSongScreen extends StatefulWidget {
  final Song song;
  const EditSongScreen({super.key, required this.song});

  @override
  EditSongScreenState createState() => EditSongScreenState();
}

class EditSongScreenState extends State<EditSongScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _tonalityController = TextEditingController();
  final _tempoController = TextEditingController();
  final _rhythmController = TextEditingController();
  final _durationController = TextEditingController();
  final _instrumentsController = TextEditingController();
  final _urlController = TextEditingController();
  final _lyricsAndChordsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.song.title;
    _artistController.text = widget.song.artist;
    _tonalityController.text = widget.song.tonality;
    _tempoController.text = widget.song.tempo;
    _rhythmController.text = widget.song.rhythm;
    _durationController.text = widget.song.duration;
    _instrumentsController.text = widget.song.instruments;
    _urlController.text = widget.song.url;
    _lyricsAndChordsController.text = widget.song.lyricsAndChords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Canción'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      hintText: 'Ej: Amazing Grace',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _artistController,
                    decoration: InputDecoration(
                      labelText: 'Artista',
                      hintText: 'Ej: John Newton',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tonalityController,
                    decoration: InputDecoration(
                      labelText: 'Tonalidad',
                      hintText: 'Ej: C Mayor',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tempoController,
                    decoration: InputDecoration(
                      labelText: 'Tempo',
                      hintText: 'Ej: 60 bpm',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _rhythmController,
                    decoration: InputDecoration(
                      labelText: 'Ritmo',
                      hintText: 'Ej: 4/4',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Duración',
                      hintText: 'Ej: 4:00',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _instrumentsController,
                    decoration: InputDecoration(
                      labelText: 'Instrumentos',
                      hintText: 'Ej: Piano, Guitarra, Voz',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: 'URL',
                      hintText: 'Ej: https://youtube.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lyricsAndChordsController,
                    decoration: const InputDecoration(
                      labelText: 'Letra y Acordes',
                      hintText: 'Ej: Verso 1: C G Am F',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 10,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () async {
                      final updatedSong = Song(
                        id: widget.song.id,
                        title: _titleController.text,
                        artist: _artistController.text,
                        tonality: _tonalityController.text,
                        tempo: _tempoController.text,
                        rhythm: _rhythmController.text,
                        duration: _durationController.text,
                        instruments: _instrumentsController.text,
                        url: _urlController.text,
                        lyricsAndChords: _lyricsAndChordsController.text,
                      );
                      await SupabaseService.updateSong(updatedSong);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Guardar'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '© 2025 Jose Siu. Todos los derechos reservados.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
