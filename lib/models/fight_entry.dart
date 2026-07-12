/// Ein Eintrag im persoenlichen Wettkampf-Tagebuch ("Meine Kaempfe"):
/// haelt Eckdaten zu einem Turnier/Wettkampf fest, optional mit Fotos
/// (eigenes Erinnerungsfoto und/oder Kaempferliste/Auslosung).
class FightEntry {
  final String id;
  final DateTime date;
  final String tournamentName;
  final String location;
  final String placement;
  final int? opponentsCount;
  final String notes;

  /// Base64-kodiertes Foto (lokal im Browser-Speicher abgelegt, kein
  /// Backend) - z.B. ein Erinnerungsfoto vom Kampf.
  final String? photoBase64;

  /// Base64-kodiertes Foto der Kaempferliste/Auslosung.
  final String? bracketPhotoBase64;

  const FightEntry({
    required this.id,
    required this.date,
    required this.tournamentName,
    required this.location,
    this.placement = '',
    this.opponentsCount,
    this.notes = '',
    this.photoBase64,
    this.bracketPhotoBase64,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'tournamentName': tournamentName,
    'location': location,
    'placement': placement,
    'opponentsCount': opponentsCount,
    'notes': notes,
    'photoBase64': photoBase64,
    'bracketPhotoBase64': bracketPhotoBase64,
  };

  factory FightEntry.fromJson(Map<String, dynamic> json) => FightEntry(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    tournamentName: json['tournamentName'] as String,
    location: json['location'] as String,
    placement: json['placement'] as String? ?? '',
    opponentsCount: json['opponentsCount'] as int?,
    notes: json['notes'] as String? ?? '',
    photoBase64: json['photoBase64'] as String?,
    bracketPhotoBase64: json['bracketPhotoBase64'] as String?,
  );
}
