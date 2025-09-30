class RendezVous {
  final String id;          // ID unique (généré par Firestore ou UUID)
  final String titre;
  final String description;
  final DateTime date;      // date + heure combinée
  final String userId;      // pour lier au user connecté

  RendezVous({
    required this.id,
    required this.titre,
    required this.description,
    required this.date,
    required this.userId,
  });

  // Conversion en Map (pour Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }

  // Conversion depuis Firestore
  factory RendezVous.fromMap(Map<String, dynamic> map) {
    return RendezVous(
      id: map['id'] ?? '',
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      userId: map['userId'] ?? '',
    );
  }
}
