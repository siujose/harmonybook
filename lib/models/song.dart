class Song {
  final int id;
  final String title;
  final String artist;
  final String tonality;
  final String tempo;
  final String rhythm;
  final String duration;
  final String instruments;
  final String url;
  final String lyricsAndChords;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.tonality,
    required this.tempo,
    required this.rhythm,
    required this.duration,
    required this.instruments,
    required this.url,
    required this.lyricsAndChords,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      tonality: json['tonality'],
      tempo: json['tempo'],
      rhythm: json['rhythm'],
      duration: json['duration'],
      instruments: json['instruments'],
      url: json['url'],
      lyricsAndChords: json['lyricsandchords'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'tonality': tonality,
      'tempo': tempo,
      'rhythm': rhythm,
      'duration': duration,
      'instruments': instruments,
      'url': url,
      'lyricsandchords': lyricsAndChords,
    };
  }
}
