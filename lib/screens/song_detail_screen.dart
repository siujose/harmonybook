import 'package:cancionero_app/models/song.dart';
import 'package:cancionero_app/screens/edit_song_screen.dart';
import 'package:cancionero_app/services/supabase_service.dart';
import 'package:flutter/material.dart';

class Chord {
  String root;
  String suffix;

  Chord(this.root, this.suffix);

  @override
  String toString() {
    return root + suffix;
  }
}

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

  @override
  SongDetailScreenState createState() => SongDetailScreenState();
}

class SongDetailScreenState extends State<SongDetailScreen> {
  String lyricsAndChordsTransposed = '';
  double transposition = 0;

  @override
  void initState() {
    super.initState();
    lyricsAndChordsTransposed = widget.song.lyricsAndChords;
  }

  List<TextSpan> _parseLyricsAndChords(String lyricsAndChords) {
    List<TextSpan> textSpans = [];
    List<String> lines = lyricsAndChords.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (i % 2 == 0) {
        // Acordes (primera línea)
        textSpans.addAll(_parseLine(line, true));
      } else {
        // Letra (segunda línea)
        textSpans.addAll(_parseLine(line, false));
      }
    }

    return textSpans;
  }

  List<TextSpan> _parseLine(String line, bool isChordLine) {
    List<TextSpan> textSpans = [];
    List<String> words = line.split(' ');

    for (String word in words) {
      String trimmedWord = word.trim();
      if (trimmedWord.startsWith('\$') && trimmedWord.endsWith('\$')) {
        String text = trimmedWord.substring(1, trimmedWord.length - 1);
        textSpans.add(
          TextSpan(
            text: '$text ',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: TextStyle(
              color: isChordLine ? Colors.blue : Colors.black,
            ),
          ),
        );
      }
    }

    textSpans.add(const TextSpan(text: '\n'));
    return textSpans;
  }

  // Función para analizar un acorde
  Chord parseChord(String chord) {
    String root = '';
    String suffix = '';
    List<String> notes = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B'
    ];

    for (String note in notes) {
      if (chord.startsWith(note)) {
        root = note;
        suffix = chord.substring(note.length);
        break;
      }
    }

    return Chord(root, suffix);
  }

  // Función para transponer un acorde
  String transposeChord(String chord, double semitones) {
    Chord parsedChord = parseChord(chord);
    if (parsedChord.root.isEmpty) {
      return chord; // No es un acorde válido
    }

    List<String> notes = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B'
    ];

    int index = notes.indexOf(parsedChord.root);
    int transposedIndex = (index + semitones.toInt()) % notes.length;
    if (transposedIndex < 0) {
      transposedIndex += notes.length;
    }

    return notes[transposedIndex] + parsedChord.suffix;
  }

  // Función para transponer todos los acordes
  String transposeAllChords(String lyricsAndChords, double semitones) {
    List<String> lines = lyricsAndChords.split('\n');
    String transposedLyricsAndChords = '';
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (i % 2 == 0) {
        // Acordes (primera línea)
        List<String> chords = line.split(' ');
        List<String> transposedChords = [];
        for (String chord in chords) {
          transposedChords.add(transposeChord(chord, semitones));
        }
        transposedLyricsAndChords += '${transposedChords.join(' ')}\n';
      } else {
        // Letra (segunda línea)
        transposedLyricsAndChords += '$line\n';
      }
    }
    return transposedLyricsAndChords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Artista: ${widget.song.artist}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Tonalidad: ${widget.song.tonality}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Tempo: ${widget.song.tempo}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Ritmo: ${widget.song.rhythm}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Duración: ${widget.song.duration}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Instrumentos: ${widget.song.instruments}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'URL: ${widget.song.url}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      transposition -= 1;
                      lyricsAndChordsTransposed = transposeAllChords(
                          widget.song.lyricsAndChords, transposition);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(
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
                  child: const Text('Bajar 1/2 tono'),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      transposition = 0;
                      lyricsAndChordsTransposed = widget.song.lyricsAndChords;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(
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
                  child: const Text('Reset'),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      transposition += 1;
                      lyricsAndChordsTransposed = transposeAllChords(
                          widget.song.lyricsAndChords, transposition);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(
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
                  child: const Text('Subir 1/2 tono'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Letra y Acordes:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: _parseLyricsAndChords(lyricsAndChordsTransposed),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSongScreen(song: widget.song),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(
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
                  child: const Text('Modificar'),
                ),
                OutlinedButton(
                  onPressed: () async {
                    try {
                      await SupabaseService.deleteSong(widget.song.id);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    } catch (error) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al eliminar la canción: $error'),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(
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
                  child: const Text('Eliminar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2025 José Siu. Todos los derechos reservados.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
